import 'dart:async';

import 'package:account_repository/src/exceptions.dart';
import 'package:account_repository/src/models/models.dart';
import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for account operations.
///
/// Uses a remote-first strategy: writes go to the Supabase API first,
/// then sync the result to the local Drift database. Reads stream from
/// local storage for reactive UI updates.
class AccountRepository {
  /// Creates an [AccountRepository].
  ///
  /// An optional [supabaseClient] can be provided for Realtime
  /// subscriptions via [subscribeToRealtimeChanges].
  AccountRepository({
    required EnvelopeApiClient apiClient,
    required storage.AppDatabase localDatabase,
    SupabaseClient? supabaseClient,
  }) : _apiClient = apiClient,
       _localDatabase = localDatabase,
       _supabaseClient = supabaseClient;

  final EnvelopeApiClient _apiClient;
  final storage.AppDatabase _localDatabase;
  final SupabaseClient? _supabaseClient;

  final StreamController<void> _remoteChangeController =
      StreamController<void>.broadcast();

  /// Emits when a remote collaborator's change is received via Realtime.
  Stream<void> get onRemoteChange => _remoteChangeController.stream;

  /// Tracks the number of local writes in progress to suppress self-change
  /// notifications. Only emits remote changes when count reaches zero.
  int _localWriteCount = 0;

  // ---------------------------------------------------------------------------
  // Accounts
  // ---------------------------------------------------------------------------

  /// Creates a new account.
  ///
  /// Server-generated fields (id, timestamps) are handled by the API.
  Future<Account> createAccount({
    required String budgetId,
    required String name,
    required String type,
    required String currency,
    int startingBalance = 0,
    double displayFxRate = 1.0,
    bool isOnBudget = true,
  }) async {
    _beginLocalWrite();
    try {
      final dto = AccountDto(
        id: '',
        budgetId: budgetId,
        name: name,
        type: type,
        currency: currency,
        displayFxRate: displayFxRate,
        startingBalance: startingBalance,
        currentBalance: startingBalance,
        isOnBudget: isOnBudget,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await _apiClient.accounts.createAccount(dto);
      await _cacheAccount(created);
      _endLocalWrite();
      return _mapAccountFromDto(created);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw AccountException('Failed to create account', error: e);
    }
  }

  /// Gets an account by its [id].
  ///
  /// Tries local storage first, falls back to the API.
  Future<Account> getAccount(String id) async {
    try {
      final local = await _localDatabase.accountsDao.getAccount(id);
      if (local != null) {
        return _mapAccountFromLocal(local);
      }

      final remote = await _apiClient.accounts.getAccount(id);
      await _cacheAccount(remote);
      return _mapAccountFromDto(remote);
    } on EnvelopeApiException catch (e) {
      throw AccountException('Failed to get account', error: e);
    }
  }

  /// Watches all accounts for a [budgetId].
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<Account>> watchAccounts(String budgetId) {
    return _localDatabase.accountsDao
        .watchAccountsByBudgetId(budgetId)
        .map((rows) => rows.map(_mapAccountFromLocal).toList())
        .handleError(
          (Object error) =>
              throw AccountException('Failed to watch accounts', error: error),
        );
  }

  /// Fetches accounts from the API and syncs them to local storage.
  Future<void> refreshAccounts(String budgetId) async {
    try {
      final remoteAccounts = await _apiClient.accounts.getAccountsByBudget(
        budgetId,
      );
      final companions = remoteAccounts.map(_toAccountCompanion).toList();
      await _localDatabase.accountsDao.batchInsertAccounts(
        companions,
        mode: InsertMode.insertOrReplace,
      );
      // Remove local rows that no longer exist on the server so that accounts
      // deleted outside the app (e.g. via Supabase dashboard) are evicted from
      // the cache on the next refresh rather than lingering indefinitely.
      final remoteIds = remoteAccounts.map((a) => a.id).toSet();
      await _localDatabase.accountsDao.deleteAccountsNotIn(budgetId, remoteIds);
    } on EnvelopeApiException catch (e) {
      throw AccountException('Failed to refresh accounts', error: e);
    }
  }

  /// Updates an [account].
  ///
  /// Sends the update to the API and syncs locally.
  Future<void> updateAccount(Account account) async {
    _beginLocalWrite();
    try {
      final dto = _mapAccountToDto(account);
      final updated = await _apiClient.accounts.updateAccount(dto);
      await _cacheAccount(updated);
      _endLocalWrite();
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw AccountException('Failed to update account', error: e);
    }
  }

  /// Deletes an account by its [id].
  ///
  /// Removes from the API first. Local cache removal is best-effort.
  Future<void> deleteAccount(String id) async {
    _beginLocalWrite();
    try {
      await _apiClient.accounts.deleteAccount(id);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw AccountException('Failed to delete account', error: e);
    }
    // Best-effort local cleanup — remote is already deleted.
    try {
      await _localDatabase.accountsDao.deleteAccount(id);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
    _endLocalWrite();
  }

  /// Archives an account by its [id].
  ///
  /// Sets `isArchived` to `true`, preserving all data.
  Future<void> archiveAccount(String id) async {
    try {
      final account = await getAccount(id);
      final archived = account.copyWith(
        isArchived: true,
        updatedAt: DateTime.now(),
      );
      await updateAccount(archived);
    } on AccountException {
      rethrow;
    } on Exception catch (e) {
      throw AccountException('Failed to archive account', error: e);
    }
  }

  /// Unarchives an account by its [id].
  Future<void> unarchiveAccount(String id) async {
    try {
      final account = await getAccount(id);
      final unarchived = account.copyWith(
        isArchived: false,
        updatedAt: DateTime.now(),
      );
      await updateAccount(unarchived);
    } on AccountException {
      rethrow;
    } on Exception catch (e) {
      throw AccountException('Failed to unarchive account', error: e);
    }
  }

  /// Reconciles an account by setting its current balance to [balance].
  ///
  /// Used when the user verifies their actual bank balance matches or
  /// differs from the computed balance.
  Future<void> reconcileAccount(String id, int balance) async {
    try {
      final account = await getAccount(id);
      final reconciled = account.copyWith(
        currentBalance: balance,
        updatedAt: DateTime.now(),
      );
      await updateAccount(reconciled);
    } on AccountException {
      rethrow;
    } on Exception catch (e) {
      throw AccountException('Failed to reconcile account', error: e);
    }
  }

  // ---------------------------------------------------------------------------
  // Debt Accounts
  // ---------------------------------------------------------------------------

  /// Creates a debt account linked to an existing account.
  Future<DebtAccount> createDebtAccount({
    required String accountId,
    required double interestRate,
    required int minimumPayment,
    required int originalBalance,
    String? payoffStrategy,
    int? creditLimit,
  }) async {
    try {
      final dto = DebtAccountDto(
        accountId: accountId,
        interestRate: interestRate,
        minimumPayment: minimumPayment,
        originalBalance: originalBalance,
        payoffStrategy: payoffStrategy,
        creditLimit: creditLimit,
      );

      final created = await _apiClient.accounts.createDebtAccount(dto);
      await _cacheDebtAccount(created);
      return _mapDebtAccountFromDto(created);
    } on EnvelopeApiException catch (e) {
      throw AccountException('Failed to create debt account', error: e);
    }
  }

  /// Gets the debt account details for an [accountId].
  ///
  /// Returns `null` if no debt account exists for the given account.
  Future<DebtAccount?> getDebtAccount(String accountId) async {
    try {
      final local = await _localDatabase.accountsDao.getDebtAccount(accountId);
      if (local != null) {
        return _mapDebtAccountFromLocal(local);
      }

      final remote = await _apiClient.accounts.getDebtAccount(accountId);
      if (remote == null) return null;
      await _cacheDebtAccount(remote);
      return _mapDebtAccountFromDto(remote);
    } on EnvelopeApiException catch (e) {
      throw AccountException('Failed to get debt account', error: e);
    }
  }

  /// Updates a [debtAccount].
  Future<void> updateDebtAccount(DebtAccount debtAccount) async {
    try {
      final dto = _mapDebtAccountToDto(debtAccount);
      final updated = await _apiClient.accounts.updateDebtAccount(dto);
      await _cacheDebtAccount(updated);
    } on EnvelopeApiException catch (e) {
      throw AccountException('Failed to update debt account', error: e);
    }
  }

  /// Deletes a debt account by its [accountId].
  ///
  /// Removes from the API first. Local cache removal is best-effort.
  Future<void> deleteDebtAccount(String accountId) async {
    try {
      await _apiClient.accounts.deleteDebtAccount(accountId);
    } on EnvelopeApiException catch (e) {
      throw AccountException('Failed to delete debt account', error: e);
    }
    try {
      await _localDatabase.accountsDao.deleteDebtAccount(accountId);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
  }

  // ---------------------------------------------------------------------------
  // Realtime
  // ---------------------------------------------------------------------------

  /// Subscribes to real-time changes on the `accounts` table
  /// filtered by [budgetId].
  ///
  /// Returns the [RealtimeChannel] so the caller (bloc) can call
  /// `.unsubscribe()` on dispose.
  ///
  /// Requires a [SupabaseClient] to be passed to the constructor.
  RealtimeChannel? subscribeToRealtimeChanges(String budgetId) {
    final client = _supabaseClient;
    if (client == null) return null;

    final channel = client
        .channel('accounts:$budgetId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'accounts',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'budget_id',
            value: budgetId,
          ),
          callback: (payload) async {
            try {
              final newRecord = payload.newRecord;
              final oldRecord = payload.oldRecord;

              switch (payload.eventType) {
                case PostgresChangeEvent.insert:
                case PostgresChangeEvent.update:
                  if (newRecord.isNotEmpty) {
                    final dto = AccountDto.fromJson(newRecord);
                    await _cacheAccount(dto);
                    if (_localWriteCount == 0) {
                      _remoteChangeController.add(null);
                    }
                  }
                case PostgresChangeEvent.delete:
                  if (oldRecord.isNotEmpty) {
                    final id = oldRecord['id'] as String?;
                    if (id != null) {
                      await _localDatabase.accountsDao.deleteAccount(id);
                      if (_localWriteCount == 0) {
                        _remoteChangeController.add(null);
                      }
                    }
                  }
                case PostgresChangeEvent.all:
                  break;
              }
            } on Exception {
              // Prevent malformed payload from breaking the channel.
            }
          },
        )
        .subscribe();

    return channel;
  }

  void beginExternalWrite() => _beginLocalWrite();

  void endExternalWrite() => _endLocalWrite();

  /// Marks a local write as in progress to suppress self-change notifications.
  void _beginLocalWrite() => _localWriteCount++;

  /// Decrements the local write counter after a short debounce.
  void _endLocalWrite() {
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (_localWriteCount > 0) _localWriteCount--;
    });
  }

  /// Closes resources held by this repository.
  void dispose() {
    _remoteChangeController.close();
  }

  // ---------------------------------------------------------------------------
  // Private — DTO ↔ Domain mapping
  // ---------------------------------------------------------------------------

  static Account _mapAccountFromDto(AccountDto dto) {
    return Account(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
      type: dto.type,
      currency: dto.currency,
      displayFxRate: dto.displayFxRate,
      startingBalance: dto.startingBalance,
      currentBalance: dto.currentBalance,
      isArchived: dto.isArchived,
      isOnBudget: dto.isOnBudget,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static Account _mapAccountFromLocal(storage.Account row) {
    return Account(
      id: row.id,
      budgetId: row.budgetId,
      name: row.name,
      type: row.type,
      currency: row.currency,
      displayFxRate: row.displayFxRate,
      startingBalance: row.startingBalance,
      currentBalance: row.currentBalance,
      isArchived: row.isArchived,
      isOnBudget: row.isOnBudget,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static AccountDto _mapAccountToDto(Account account) {
    return AccountDto(
      id: account.id,
      budgetId: account.budgetId,
      name: account.name,
      type: account.type,
      currency: account.currency,
      displayFxRate: account.displayFxRate,
      startingBalance: account.startingBalance,
      currentBalance: account.currentBalance,
      isArchived: account.isArchived,
      isOnBudget: account.isOnBudget,
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
    );
  }

  static DebtAccount _mapDebtAccountFromDto(DebtAccountDto dto) {
    return DebtAccount(
      accountId: dto.accountId,
      interestRate: dto.interestRate,
      minimumPayment: dto.minimumPayment,
      originalBalance: dto.originalBalance,
      payoffStrategy: dto.payoffStrategy,
      creditLimit: dto.creditLimit,
    );
  }

  static DebtAccount _mapDebtAccountFromLocal(storage.DebtAccount row) {
    return DebtAccount(
      accountId: row.accountId,
      interestRate: row.interestRate,
      minimumPayment: row.minimumPayment,
      originalBalance: row.originalBalance,
      payoffStrategy: row.payoffStrategy,
      creditLimit: row.creditLimit,
    );
  }

  static DebtAccountDto _mapDebtAccountToDto(DebtAccount debtAccount) {
    return DebtAccountDto(
      accountId: debtAccount.accountId,
      interestRate: debtAccount.interestRate,
      minimumPayment: debtAccount.minimumPayment,
      originalBalance: debtAccount.originalBalance,
      payoffStrategy: debtAccount.payoffStrategy,
      creditLimit: debtAccount.creditLimit,
    );
  }

  // ---------------------------------------------------------------------------
  // Private — Local cache helpers
  // ---------------------------------------------------------------------------

  static storage.AccountsCompanion _toAccountCompanion(AccountDto dto) {
    return storage.AccountsCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
      type: dto.type,
      currency: dto.currency,
      displayFxRate: Value(dto.displayFxRate),
      startingBalance: Value(dto.startingBalance),
      currentBalance: Value(dto.currentBalance),
      isArchived: Value(dto.isArchived),
      isOnBudget: Value(dto.isOnBudget),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  Future<void> _cacheAccount(AccountDto dto) async {
    await _localDatabase.accountsDao.insertAccount(
      _toAccountCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> _cacheDebtAccount(DebtAccountDto dto) async {
    final companion = storage.DebtAccountsCompanion.insert(
      accountId: dto.accountId,
      interestRate: dto.interestRate,
      minimumPayment: dto.minimumPayment,
      originalBalance: dto.originalBalance,
      payoffStrategy: Value(dto.payoffStrategy),
      creditLimit: Value(dto.creditLimit),
    );
    await _localDatabase.accountsDao.insertDebtAccount(
      companion,
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Creates or updates the credit limit for a CC account's debt record.
  ///
  /// Uses default zero-values for required debt fields when creating a new row.
  Future<void> upsertDebtAccountCreditLimit(
    String accountId,
    int? creditLimit,
  ) async {
    try {
      final existing = await getDebtAccount(accountId);
      if (existing != null) {
        await updateDebtAccount(existing.copyWith(creditLimit: creditLimit));
      } else {
        await createDebtAccount(
          accountId: accountId,
          interestRate: 0,
          minimumPayment: 0,
          originalBalance: 0,
          creditLimit: creditLimit,
        );
      }
    } on AccountException {
      rethrow;
    } on Exception catch (e) {
      throw AccountException(
        'Failed to upsert debt account credit limit',
        error: e,
      );
    }
  }
}
