import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart'
    hide
        BillReminder,
        RecurringRule,
        Tag,
        Transaction,
        TransactionSplit,
        TransactionTemplate;
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Repository for transaction, recurring rule, bill reminder, and tag
/// operations.
///
/// Uses a remote-first strategy: writes go to the Supabase API first,
/// then sync the result to the local Drift database. Reads stream from
/// local storage for reactive UI updates.
class TransactionRepository {
  /// Creates a [TransactionRepository].
  ///
  /// An optional [supabaseClient] can be provided for Realtime
  /// subscriptions via [subscribeToTransactionChanges].
  TransactionRepository({
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
    SupabaseClient? supabaseClient,
  }) : _apiClient = apiClient,
       _localDatabase = localDatabase,
       _supabaseClient = supabaseClient;

  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;
  final SupabaseClient? _supabaseClient;

  final StreamController<void> _remoteChangeController =
      StreamController<void>.broadcast();

  /// Emits when a remote collaborator's change is received via Realtime.
  Stream<void> get onRemoteChange => _remoteChangeController.stream;

  int _localWriteCount = 0;

  // ---------------------------------------------------------------------------
  // Transactions
  // ---------------------------------------------------------------------------

  /// Creates a new transaction.
  ///
  /// Sends to the API first, then caches locally.
  Future<Transaction> createTransaction({
    required String budgetId,
    required String accountId,
    required String type,
    required int amount,
    required String currency,
    required DateTime date,
    required String createdBy,
    String? envelopeId,
    double exchangeRate = 1.0,
    String? payee,
    String? notes,
    String? recurringRuleId,
    String? transferPairId,
  }) async {
    _beginLocalWrite();
    try {
      // baseCurrencyAmount = amount × exchangeRate, rounded to int cents.
      // The server trigger trg_transactions_base_currency_amount recomputes
      // this on insert/update and is the source of truth; the client value
      // is sent only so the local cache can stay in sync before the server
      // round-trips back.
      final dto = TransactionDto(
        id: '',
        budgetId: budgetId,
        accountId: accountId,
        type: type,
        amount: amount,
        currency: currency,
        date: date,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        envelopeId: envelopeId,
        exchangeRate: exchangeRate,
        baseCurrencyAmount: (amount * exchangeRate).round(),
        payee: payee,
        notes: notes,
        recurringRuleId: recurringRuleId,
        transferPairId: transferPairId,
      );
      final created = await _apiClient.transactions.createTransaction(dto);
      await _cacheTransaction(created);
      _endLocalWrite();
      return _mapTransactionFromDto(created);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw TransactionException('Failed to create transaction', error: e);
    }
  }

  /// Gets a transaction by its [id].
  ///
  /// Tries local storage first, falls back to the API.
  Future<Transaction> getTransaction(String id) async {
    try {
      final local = await _localDatabase.transactionsDao.getTransaction(id);
      if (local != null) {
        return _mapTransactionFromLocal(local);
      }
      final remote = await _apiClient.transactions.getTransaction(id);
      await _cacheTransaction(remote);
      return _mapTransactionFromDto(remote);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to get transaction', error: e);
    }
  }

  /// Watches transactions for a [budgetId], optionally filtered by account
  /// or envelope.
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<Transaction>> watchTransactions({
    required String budgetId,
    String? accountId,
    String? envelopeId,
  }) {
    late Stream<List<storage.Transaction>> stream;

    if (accountId != null) {
      stream = _localDatabase.transactionsDao
          .watchTransactionsByBudgetId(budgetId)
          .map((rows) => rows.where((r) => r.accountId == accountId).toList());
    } else if (envelopeId != null) {
      stream = _localDatabase.transactionsDao
          .watchTransactionsByBudgetId(budgetId)
          .map(
            (rows) => rows.where((r) => r.envelopeId == envelopeId).toList(),
          );
    } else {
      stream = _localDatabase.transactionsDao.watchTransactionsByBudgetId(
        budgetId,
      );
    }

    return stream
        .map((rows) => rows.map(_mapTransactionFromLocal).toList())
        .handleError(
          (Object error) => throw TransactionException(
            'Failed to watch transactions',
            error: error,
          ),
        );
  }

  /// Watches a map of transactionId → envelopeIds for split transactions
  /// belonging to [budgetId].
  Stream<Map<String, List<String>>> watchSplitEnvelopeIds(String budgetId) {
    return _localDatabase.transactionsDao
        .watchSplitEnvelopeIds(budgetId)
        .handleError(
          (Object error) => throw TransactionException(
            'Failed to watch split envelope ids',
            error: error,
          ),
        );
  }

  /// Updates a [transaction].
  ///
  /// Sends the update to the API and syncs locally.
  Future<void> updateTransaction(Transaction transaction) async {
    _beginLocalWrite();
    try {
      // Recompute baseCurrencyAmount client-side; server trigger overwrites.
      final dto = _mapTransactionToDto(
        transaction.copyWith(
          baseCurrencyAmount:
              (transaction.amount * transaction.exchangeRate).round(),
        ),
      );
      final updated = await _apiClient.transactions.updateTransaction(dto);
      await _cacheTransaction(updated);
      _endLocalWrite();
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw TransactionException('Failed to update transaction', error: e);
    }
  }

  /// Soft-deletes a transaction by its [id].
  ///
  /// Sets `deleted_at` on the API. Local cache removal is best-effort.
  Future<void> deleteTransaction(String id) async {
    _beginLocalWrite();
    try {
      await _apiClient.transactions.deleteTransaction(id);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw TransactionException('Failed to delete transaction', error: e);
    }
    try {
      await _localDatabase.transactionsDao.deleteTransaction(id);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
    _endLocalWrite();
  }

  /// Restores a soft-deleted transaction by clearing `deleted_at`.
  ///
  /// Re-caches the row locally so callers don't depend on the realtime push
  /// to surface the restored transaction (offline / unsubscribed clients
  /// would otherwise see optimistic balance bumps with no row).
  Future<void> restoreTransaction(String id) async {
    _beginLocalWrite();
    try {
      await _apiClient.transactions.restoreTransaction(id);
      final dto = await _apiClient.transactions.getTransaction(id);
      await _cacheTransaction(dto);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw TransactionException('Failed to restore transaction', error: e);
    }
    _endLocalWrite();
  }

  /// Fetches transactions from the API and syncs to local storage.
  Future<void> refreshTransactions(String budgetId) async {
    try {
      final remote = await _apiClient.transactions.getTransactionsByBudget(
        budgetId,
      );
      final companions = remote.map(_toTransactionCompanion).toList();
      for (final companion in companions) {
        await _localDatabase.transactionsDao.insertTransaction(
          companion,
          mode: InsertMode.insertOrReplace,
        );
      }
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to refresh transactions', error: e);
    }
  }

  // ---------------------------------------------------------------------------
  // Split Transactions
  // ---------------------------------------------------------------------------

  /// Creates split entries for a transaction.
  ///
  /// Sends each split to the API and caches locally.
  Future<void> createSplitTransaction({
    required String transactionId,
    required List<TransactionSplit> splits,
  }) async {
    try {
      for (final split in splits) {
        final dto = TransactionSplitDto(
          id: '',
          transactionId: transactionId,
          envelopeId: split.envelopeId,
          amount: split.amount.toDouble(),
        );
        final created = await _apiClient.transactions.createTransactionSplit(
          dto,
        );
        await _localDatabase.transactionsDao.insertTransactionSplit(
          _toTransactionSplitCompanion(created),
          mode: InsertMode.insertOrReplace,
        );
      }
    } on EnvelopeApiException catch (e) {
      throw TransactionException(
        'Failed to create split transaction',
        error: e,
      );
    }
  }

  /// Gets all splits for a [transactionId].
  Future<List<TransactionSplit>> getTransactionSplits(
    String transactionId,
  ) async {
    try {
      final local = await _localDatabase.transactionsDao
          .getSplitsByTransactionId(transactionId);
      if (local.isNotEmpty) {
        return local.map(_mapTransactionSplitFromLocal).toList();
      }
      final remote = await _apiClient.transactions.getTransactionSplits(
        transactionId,
      );
      for (final dto in remote) {
        await _localDatabase.transactionsDao.insertTransactionSplit(
          _toTransactionSplitCompanion(dto),
          mode: InsertMode.insertOrReplace,
        );
      }
      return remote.map(_mapTransactionSplitFromDto).toList();
    } on EnvelopeApiException catch (e) {
      throw TransactionException(
        'Failed to get transaction splits',
        error: e,
      );
    }
  }

  /// Deletes all splits for a transaction and replaces them with [splits].
  Future<void> replaceSplits({
    required String transactionId,
    required List<TransactionSplit> splits,
  }) async {
    try {
      await _apiClient.transactions.deleteTransactionSplits(transactionId);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to replace splits', error: e);
    }
    try {
      await _localDatabase.transactionsDao.deleteSplitsByTransactionId(
        transactionId,
      );
    } on Exception {
      // Stale local splits will be cleaned up on next refresh.
    }
    await createSplitTransaction(
      transactionId: transactionId,
      splits: splits,
    );
  }

  // ---------------------------------------------------------------------------
  // Recurring Rules
  // ---------------------------------------------------------------------------

  /// Fetches recurring rules from the API and syncs to local storage.
  Future<void> refreshRecurringRules(String budgetId) async {
    try {
      final remote = await _apiClient.recurring.getRecurringRulesByBudget(
        budgetId,
      );
      for (final dto in remote) {
        await _localDatabase.recurringDao.insertRecurringRule(
          _toRecurringRuleCompanion(dto),
          mode: InsertMode.insertOrReplace,
        );
      }
    } on EnvelopeApiException catch (e) {
      throw TransactionException(
        'Failed to refresh recurring rules',
        error: e,
      );
    }
  }

  /// Creates a new recurring rule.
  ///
  /// Sends to the API first, then caches locally.
  Future<RecurringRule> createRecurringRule({
    required String budgetId,
    required String accountId,
    required String type,
    required int amount,
    required String currency,
    required String frequency,
    required DateTime startDate,
    double exchangeRate = 1.0,
    String? envelopeId,
    String? payee,
    String? notes,
    int? customInterval,
    String? customUnit,
    DateTime? endDate,
    bool autoPost = false,
  }) async {
    try {
      final dto = RecurringRuleDto(
        id: '',
        budgetId: budgetId,
        accountId: accountId,
        type: type,
        amount: amount,
        currency: currency,
        exchangeRate: exchangeRate,
        frequency: frequency,
        startDate: startDate,
        nextOccurrence: startDate,
        createdAt: DateTime.now(),
        envelopeId: envelopeId,
        payee: payee,
        notes: notes,
        customInterval: customInterval,
        customUnit: customUnit,
        endDate: endDate,
        autoPost: autoPost,
      );
      final created = await _apiClient.recurring.createRecurringRule(dto);
      await _cacheRecurringRule(created);
      return _mapRecurringRuleFromDto(created);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to create recurring rule', error: e);
    }
  }

  /// Watches all recurring rules for a [budgetId].
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<RecurringRule>> watchRecurringRules(String budgetId) {
    return _localDatabase.recurringDao
        .watchRecurringRulesByBudgetId(budgetId)
        .map((rows) => rows.map(_mapRecurringRuleFromLocal).toList())
        .handleError(
          (Object error) => throw TransactionException(
            'Failed to watch recurring rules',
            error: error,
          ),
        );
  }

  /// Updates a recurring [rule].
  ///
  /// Sends the update to the API and syncs locally.
  Future<void> updateRecurringRule(RecurringRule rule) async {
    try {
      final dto = _mapRecurringRuleToDto(rule);
      final updated = await _apiClient.recurring.updateRecurringRule(dto);
      await _cacheRecurringRule(updated);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to update recurring rule', error: e);
    }
  }

  /// Deletes a recurring rule by its [id].
  ///
  /// Removes from the API first. Local cache removal is best-effort.
  Future<void> deleteRecurringRule(String id) async {
    try {
      await _apiClient.recurring.deleteRecurringRule(id);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to delete recurring rule', error: e);
    }
    try {
      await _localDatabase.recurringDao.deleteRecurringRule(id);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
  }

  /// Pauses a recurring rule by its [id].
  Future<void> pauseRecurringRule(String id) async {
    try {
      final local = await _localDatabase.recurringDao.getRecurringRule(id);
      if (local != null) {
        final rule = _mapRecurringRuleFromLocal(local);
        await updateRecurringRule(rule.copyWith(isPaused: true));
        return;
      }
      final remote = await _apiClient.recurring.getRecurringRule(id);
      final paused = remote.copyWith(isPaused: true);
      final updated = await _apiClient.recurring.updateRecurringRule(paused);
      await _cacheRecurringRule(updated);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to pause recurring rule', error: e);
    }
  }

  /// Resumes a paused recurring rule by its [id].
  Future<void> resumeRecurringRule(String id) async {
    try {
      final local = await _localDatabase.recurringDao.getRecurringRule(id);
      if (local != null) {
        final rule = _mapRecurringRuleFromLocal(local);
        await updateRecurringRule(rule.copyWith(isPaused: false));
        return;
      }
      final remote = await _apiClient.recurring.getRecurringRule(id);
      final resumed = remote.copyWith(isPaused: false);
      final updated = await _apiClient.recurring.updateRecurringRule(resumed);
      await _cacheRecurringRule(updated);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to resume recurring rule', error: e);
    }
  }

  // ---------------------------------------------------------------------------
  // Bill Reminders
  // ---------------------------------------------------------------------------

  /// Fetches bill reminders from the API and syncs to local storage.
  Future<void> refreshBillReminders(String budgetId) async {
    try {
      final remote = await _apiClient.recurring.getBillRemindersByBudget(
        budgetId,
      );
      for (final dto in remote) {
        await _localDatabase.recurringDao.insertBillReminder(
          _toBillReminderCompanion(dto),
          mode: InsertMode.insertOrReplace,
        );
      }
    } on EnvelopeApiException catch (e) {
      throw TransactionException(
        'Failed to refresh bill reminders',
        error: e,
      );
    }
  }

  /// Creates a new bill reminder.
  ///
  /// Sends to the API first, then caches locally.
  Future<BillReminder> createBillReminder({
    required String budgetId,
    required String name,
    required int estimatedAmount,
    required int dueDay,
    required String frequency,
    String? envelopeId,
    int reminderDaysBefore = 3,
  }) async {
    try {
      final dto = BillReminderDto(
        id: '',
        budgetId: budgetId,
        name: name,
        estimatedAmount: estimatedAmount,
        dueDay: dueDay,
        frequency: frequency,
        createdAt: DateTime.now(),
        envelopeId: envelopeId,
        reminderDaysBefore: reminderDaysBefore,
      );
      final created = await _apiClient.recurring.createBillReminder(dto);
      await _cacheBillReminder(created);
      return _mapBillReminderFromDto(created);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to create bill reminder', error: e);
    }
  }

  /// Watches all bill reminders for a [budgetId].
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<BillReminder>> watchBillReminders(String budgetId) {
    return _localDatabase.recurringDao
        .watchBillRemindersByBudgetId(budgetId)
        .map((rows) => rows.map(_mapBillReminderFromLocal).toList())
        .handleError(
          (Object error) => throw TransactionException(
            'Failed to watch bill reminders',
            error: error,
          ),
        );
  }

  /// Updates a bill [reminder].
  ///
  /// Sends the update to the API and syncs locally.
  Future<void> updateBillReminder(BillReminder reminder) async {
    try {
      final dto = _mapBillReminderToDto(reminder);
      final updated = await _apiClient.recurring.updateBillReminder(dto);
      await _cacheBillReminder(updated);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to update bill reminder', error: e);
    }
  }

  /// Deletes a bill reminder by its [id].
  ///
  /// Removes from the API first. Local cache removal is best-effort.
  Future<void> deleteBillReminder(String id) async {
    try {
      await _apiClient.recurring.deleteBillReminder(id);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to delete bill reminder', error: e);
    }
    try {
      await _localDatabase.recurringDao.deleteBillReminder(id);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
  }

  // ---------------------------------------------------------------------------
  // Tags
  // ---------------------------------------------------------------------------

  /// Creates a new tag.
  ///
  /// Sends to the API first, then caches locally.
  Future<Tag> createTag({
    required String budgetId,
    required String name,
  }) async {
    try {
      final dto = TagDto(id: '', budgetId: budgetId, name: name);
      final created = await _apiClient.transactions.createTag(dto);
      await _localDatabase.transactionsDao.insertTag(
        _toTagCompanion(created),
        mode: InsertMode.insertOrReplace,
      );
      return _mapTagFromDto(created);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to create tag', error: e);
    }
  }

  /// Gets all tags for a [budgetId].
  Future<List<Tag>> getTags(String budgetId) async {
    try {
      final local = await _localDatabase.transactionsDao.getTagsByBudgetId(
        budgetId,
      );
      if (local.isNotEmpty) {
        return local.map(_mapTagFromLocal).toList();
      }
      final remote = await _apiClient.transactions.getTags(budgetId);
      for (final dto in remote) {
        await _localDatabase.transactionsDao.insertTag(
          _toTagCompanion(dto),
          mode: InsertMode.insertOrReplace,
        );
      }
      return remote.map(_mapTagFromDto).toList();
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to get tags', error: e);
    }
  }

  // ---------------------------------------------------------------------------
  // Transaction Templates
  // ---------------------------------------------------------------------------

  /// Creates a transaction template (saved blueprint for one-tap pre-fill).
  ///
  /// Writes to the API first, then caches locally.
  Future<TransactionTemplate> createTransactionTemplate({
    required String budgetId,
    required String name,
    required String type,
    String? accountId,
    String? envelopeId,
    int? amountCents,
    String? payee,
    String? notes,
    String? currency,
    List<String> tagIds = const [],
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final dto = TransactionTemplateDto(
        id: '',
        budgetId: budgetId,
        name: name,
        type: type,
        accountId: accountId,
        envelopeId: envelopeId,
        amountCents: amountCents,
        payee: payee,
        notes: notes,
        currency: currency,
        tagIdsJson: tagIds.isEmpty ? null : _encodeTagIds(tagIds),
        createdAt: now,
        updatedAt: now,
      );
      final created = await _apiClient.transactions
          .createTransactionTemplate(dto);
      await _localDatabase.transactionTemplatesDao.insertTemplate(
        _toTemplateCompanion(created),
      );
      return _mapTemplateFromDto(created);
    } on EnvelopeApiException catch (e) {
      throw TransactionException(
        'Failed to create transaction template',
        error: e,
      );
    }
  }

  /// Fetches all non-deleted transaction templates for a budget.
  ///
  /// Returns the local cache immediately when present, then refreshes from
  /// the remote in the background so multi-device edits propagate. Callers
  /// who need fresh data should consume [watchTransactionTemplates] instead.
  ///
  /// Best-effort: if the remote fetch fails (e.g. the table does not exist
  /// on a stale environment) this returns whatever local has rather than
  /// throwing, so the rest of the form load is unaffected.
  Future<List<TransactionTemplate>> getTransactionTemplates(
    String budgetId,
  ) async {
    final local = await _localDatabase.transactionTemplatesDao
        .getTemplatesByBudgetId(budgetId);
    if (local.isNotEmpty) {
      unawaited(_refreshTransactionTemplatesQuietly(budgetId));
      return local.map(_mapTemplateFromLocal).toList();
    }
    try {
      return await _refreshTransactionTemplates(budgetId);
    } on Exception {
      return const [];
    }
  }

  Future<List<TransactionTemplate>> _refreshTransactionTemplates(
    String budgetId,
  ) async {
    final remote = await _apiClient.transactions.getTransactionTemplates(
      budgetId,
    );
    for (final dto in remote) {
      await _localDatabase.transactionTemplatesDao.insertTemplate(
        _toTemplateCompanion(dto),
      );
    }
    return remote.map(_mapTemplateFromDto).toList();
  }

  Future<void> _refreshTransactionTemplatesQuietly(String budgetId) async {
    try {
      await _refreshTransactionTemplates(budgetId);
    } on Exception {
      // Best-effort background refresh.
    }
  }

  /// Streams the transaction templates for a budget (live updates).
  Stream<List<TransactionTemplate>> watchTransactionTemplates(String budgetId) {
    return _localDatabase.transactionTemplatesDao
        .watchTemplatesByBudgetId(budgetId)
        .map((rows) => rows.map(_mapTemplateFromLocal).toList());
  }

  /// Updates an existing transaction template.
  Future<TransactionTemplate> updateTransactionTemplate(
    TransactionTemplate template,
  ) async {
    try {
      final dto = _toTemplateDto(
        template.copyWith(updatedAt: DateTime.now().toUtc()),
      );
      final updated = await _apiClient.transactions.updateTransactionTemplate(
        dto,
      );
      await _localDatabase.transactionTemplatesDao.insertTemplate(
        _toTemplateCompanion(updated),
      );
      return _mapTemplateFromDto(updated);
    } on EnvelopeApiException catch (e) {
      throw TransactionException(
        'Failed to update transaction template',
        error: e,
      );
    }
  }

  /// Soft-deletes a transaction template by [id].
  Future<void> deleteTransactionTemplate(String id) async {
    try {
      await _apiClient.transactions.deleteTransactionTemplate(id);
    } on EnvelopeApiException catch (e) {
      throw TransactionException(
        'Failed to delete transaction template',
        error: e,
      );
    }
    try {
      await _localDatabase.transactionTemplatesDao.softDeleteTemplate(
        id,
        DateTime.now().toUtc(),
      );
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
  }

  /// Deletes a tag by its [id].
  ///
  /// Removes from the API first. Local cache removal is best-effort.
  Future<void> deleteTag(String id) async {
    try {
      await _apiClient.transactions.deleteTag(id);
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to delete tag', error: e);
    }
    try {
      await _localDatabase.transactionsDao.deleteTag(id);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
  }

  /// Adds a tag to a transaction.
  Future<void> addTagToTransaction({
    required String transactionId,
    required String tagId,
  }) async {
    try {
      await _apiClient.transactions.addTransactionTag(
        transactionId: transactionId,
        tagId: tagId,
      );
      await _localDatabase.transactionsDao.insertTransactionTag(
        storage.TransactionTagsCompanion.insert(
          transactionId: transactionId,
          tagId: tagId,
        ),
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw TransactionException('Failed to add tag to transaction', error: e);
    }
  }

  /// Removes a tag from a transaction.
  Future<void> removeTagFromTransaction({
    required String transactionId,
    required String tagId,
  }) async {
    try {
      await _apiClient.transactions.removeTransactionTag(
        transactionId: transactionId,
        tagId: tagId,
      );
    } on EnvelopeApiException catch (e) {
      throw TransactionException(
        'Failed to remove tag from transaction',
        error: e,
      );
    }
    try {
      await _localDatabase.transactionsDao.deleteTransactionTag(
        transactionId: transactionId,
        tagId: tagId,
      );
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
  }

  /// Gets all tag IDs associated with a transaction.
  Future<List<String>> getTagIdsForTransaction(String transactionId) async {
    try {
      final local = await _localDatabase.transactionsDao.getTagsByTransactionId(
        transactionId,
      );
      if (local.isNotEmpty) {
        return local.map((r) => r.tagId).toList();
      }
      final tagIds = await _apiClient.transactions.getTransactionTags(
        transactionId,
      );
      for (final tagId in tagIds) {
        await _localDatabase.transactionsDao.insertTransactionTag(
          storage.TransactionTagsCompanion.insert(
            transactionId: transactionId,
            tagId: tagId,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
      return tagIds;
    } on EnvelopeApiException catch (e) {
      throw TransactionException(
        'Failed to get tags for transaction',
        error: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Realtime
  // ---------------------------------------------------------------------------

  /// Subscribes to real-time changes on the `transactions` table
  /// filtered by [budgetId].
  RealtimeChannel? subscribeToTransactionChanges(String budgetId) {
    final client = _supabaseClient;
    if (client == null) return null;

    final channel = client
        .channel('transactions:$budgetId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'transactions',
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
                    if (newRecord['deleted_at'] != null) {
                      // Soft-deleted remotely — remove from local cache.
                      final id = newRecord['id'] as String?;
                      if (id != null) {
                        await _localDatabase.transactionsDao.deleteTransaction(
                          id,
                        );
                      }
                    } else {
                      final dto = TransactionDto.fromJson(newRecord);
                      await _cacheTransaction(dto);
                    }
                    if (_localWriteCount == 0) {
                      _remoteChangeController.add(null);
                    }
                  }
                case PostgresChangeEvent.delete:
                  if (oldRecord.isNotEmpty) {
                    final id = oldRecord['id'] as String?;
                    if (id != null) {
                      await _localDatabase.transactionsDao.deleteTransaction(
                        id,
                      );
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

  void _beginLocalWrite() => _localWriteCount++;

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

  static Transaction _mapTransactionFromDto(TransactionDto dto) {
    return Transaction(
      id: dto.id,
      budgetId: dto.budgetId,
      accountId: dto.accountId,
      type: dto.type,
      amount: dto.amount,
      currency: dto.currency,
      date: dto.date,
      createdBy: dto.createdBy,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      envelopeId: dto.envelopeId,
      exchangeRate: dto.exchangeRate,
      baseCurrencyAmount: dto.baseCurrencyAmount,
      payee: dto.payee,
      notes: dto.notes,
      isReconciled: dto.isReconciled,
      recurringRuleId: dto.recurringRuleId,
      transferPairId: dto.transferPairId,
    );
  }

  static Transaction _mapTransactionFromLocal(storage.Transaction row) {
    return Transaction(
      id: row.id,
      budgetId: row.budgetId,
      accountId: row.accountId,
      type: row.type,
      amount: row.amount,
      currency: row.currency,
      date: row.date,
      createdBy: row.createdBy,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      envelopeId: row.envelopeId,
      exchangeRate: row.exchangeRate,
      baseCurrencyAmount: row.baseCurrencyAmount,
      payee: row.payee,
      notes: row.notes,
      isReconciled: row.isReconciled,
      recurringRuleId: row.recurringRuleId,
      transferPairId: row.transferPairId,
    );
  }

  static TransactionDto _mapTransactionToDto(Transaction transaction) {
    return TransactionDto(
      id: transaction.id,
      budgetId: transaction.budgetId,
      accountId: transaction.accountId,
      type: transaction.type,
      amount: transaction.amount,
      currency: transaction.currency,
      date: transaction.date,
      createdBy: transaction.createdBy,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      envelopeId: transaction.envelopeId,
      exchangeRate: transaction.exchangeRate,
      baseCurrencyAmount: transaction.baseCurrencyAmount,
      payee: transaction.payee,
      notes: transaction.notes,
      isReconciled: transaction.isReconciled,
      recurringRuleId: transaction.recurringRuleId,
      transferPairId: transaction.transferPairId,
    );
  }

  static TransactionSplit _mapTransactionSplitFromDto(
    TransactionSplitDto dto,
  ) {
    return TransactionSplit(
      id: dto.id,
      transactionId: dto.transactionId,
      envelopeId: dto.envelopeId,
      amount: dto.amount.toInt(),
    );
  }

  static TransactionSplit _mapTransactionSplitFromLocal(
    storage.TransactionSplit row,
  ) {
    return TransactionSplit(
      id: row.id,
      transactionId: row.transactionId,
      envelopeId: row.envelopeId,
      amount: row.amount.toInt(),
    );
  }

  static RecurringRule _mapRecurringRuleFromDto(RecurringRuleDto dto) {
    return RecurringRule(
      id: dto.id,
      budgetId: dto.budgetId,
      accountId: dto.accountId,
      type: dto.type,
      amount: dto.amount,
      currency: dto.currency,
      exchangeRate: dto.exchangeRate,
      frequency: dto.frequency,
      startDate: dto.startDate,
      nextOccurrence: dto.nextOccurrence,
      createdAt: dto.createdAt,
      envelopeId: dto.envelopeId,
      payee: dto.payee,
      notes: dto.notes,
      customInterval: dto.customInterval,
      customUnit: dto.customUnit,
      endDate: dto.endDate,
      autoPost: dto.autoPost,
      isPaused: dto.isPaused,
    );
  }

  static RecurringRule _mapRecurringRuleFromLocal(storage.RecurringRule row) {
    return RecurringRule(
      id: row.id,
      budgetId: row.budgetId,
      accountId: row.accountId,
      type: row.type,
      amount: row.amount,
      currency: row.currency,
      exchangeRate: row.exchangeRate,
      frequency: row.frequency,
      startDate: row.startDate,
      nextOccurrence: row.nextOccurrence,
      createdAt: row.createdAt,
      envelopeId: row.envelopeId,
      payee: row.payee,
      notes: row.notes,
      customInterval: row.customInterval,
      customUnit: row.customUnit,
      endDate: row.endDate,
      autoPost: row.autoPost,
      isPaused: row.isPaused,
    );
  }

  static RecurringRuleDto _mapRecurringRuleToDto(RecurringRule rule) {
    return RecurringRuleDto(
      id: rule.id,
      budgetId: rule.budgetId,
      accountId: rule.accountId,
      type: rule.type,
      amount: rule.amount,
      currency: rule.currency,
      exchangeRate: rule.exchangeRate,
      frequency: rule.frequency,
      startDate: rule.startDate,
      nextOccurrence: rule.nextOccurrence,
      createdAt: rule.createdAt,
      envelopeId: rule.envelopeId,
      payee: rule.payee,
      notes: rule.notes,
      customInterval: rule.customInterval,
      customUnit: rule.customUnit,
      endDate: rule.endDate,
      autoPost: rule.autoPost,
      isPaused: rule.isPaused,
    );
  }

  static BillReminder _mapBillReminderFromDto(BillReminderDto dto) {
    return BillReminder(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
      estimatedAmount: dto.estimatedAmount,
      dueDay: dto.dueDay,
      frequency: dto.frequency,
      createdAt: dto.createdAt,
      envelopeId: dto.envelopeId,
      reminderDaysBefore: dto.reminderDaysBefore,
    );
  }

  static BillReminder _mapBillReminderFromLocal(storage.BillReminder row) {
    return BillReminder(
      id: row.id,
      budgetId: row.budgetId,
      name: row.name,
      estimatedAmount: row.estimatedAmount,
      dueDay: row.dueDay,
      frequency: row.frequency,
      createdAt: row.createdAt,
      envelopeId: row.envelopeId,
      reminderDaysBefore: row.reminderDaysBefore,
    );
  }

  static BillReminderDto _mapBillReminderToDto(BillReminder reminder) {
    return BillReminderDto(
      id: reminder.id,
      budgetId: reminder.budgetId,
      name: reminder.name,
      estimatedAmount: reminder.estimatedAmount,
      dueDay: reminder.dueDay,
      frequency: reminder.frequency,
      createdAt: reminder.createdAt,
      envelopeId: reminder.envelopeId,
      reminderDaysBefore: reminder.reminderDaysBefore,
    );
  }

  static Tag _mapTagFromDto(TagDto dto) {
    return Tag(id: dto.id, budgetId: dto.budgetId, name: dto.name);
  }

  static Tag _mapTagFromLocal(storage.Tag row) {
    return Tag(id: row.id, budgetId: row.budgetId, name: row.name);
  }

  // ---------------------------------------------------------------------------
  // Private — Local cache helpers
  // ---------------------------------------------------------------------------

  static storage.TransactionsCompanion _toTransactionCompanion(
    TransactionDto dto,
  ) {
    return storage.TransactionsCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      accountId: dto.accountId,
      type: dto.type,
      amount: dto.amount,
      currency: dto.currency,
      date: dto.date,
      createdBy: dto.createdBy,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      envelopeId: Value(dto.envelopeId),
      exchangeRate: Value(dto.exchangeRate),
      baseCurrencyAmount: Value(dto.baseCurrencyAmount),
      payee: Value(dto.payee),
      notes: Value(dto.notes),
      isReconciled: Value(dto.isReconciled),
      recurringRuleId: Value(dto.recurringRuleId),
      transferPairId: Value(dto.transferPairId),
    );
  }

  Future<void> _cacheTransaction(TransactionDto dto) async {
    await _localDatabase.transactionsDao.insertTransaction(
      _toTransactionCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  static storage.TransactionSplitsCompanion _toTransactionSplitCompanion(
    TransactionSplitDto dto,
  ) {
    return storage.TransactionSplitsCompanion.insert(
      id: dto.id,
      transactionId: dto.transactionId,
      envelopeId: dto.envelopeId,
      amount: dto.amount,
    );
  }

  static storage.RecurringRulesCompanion _toRecurringRuleCompanion(
    RecurringRuleDto dto,
  ) {
    return storage.RecurringRulesCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      accountId: dto.accountId,
      type: dto.type,
      amount: dto.amount,
      currency: dto.currency,
      exchangeRate: Value(dto.exchangeRate),
      frequency: dto.frequency,
      startDate: dto.startDate,
      nextOccurrence: dto.nextOccurrence,
      createdAt: dto.createdAt,
      envelopeId: Value(dto.envelopeId),
      payee: Value(dto.payee),
      notes: Value(dto.notes),
      customInterval: Value(dto.customInterval),
      customUnit: Value(dto.customUnit),
      endDate: Value(dto.endDate),
      autoPost: Value(dto.autoPost),
      isPaused: Value(dto.isPaused),
    );
  }

  Future<void> _cacheRecurringRule(RecurringRuleDto dto) async {
    await _localDatabase.recurringDao.insertRecurringRule(
      _toRecurringRuleCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  static storage.BillRemindersCompanion _toBillReminderCompanion(
    BillReminderDto dto,
  ) {
    return storage.BillRemindersCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
      estimatedAmount: dto.estimatedAmount,
      dueDay: dto.dueDay,
      frequency: dto.frequency,
      createdAt: dto.createdAt,
      envelopeId: Value(dto.envelopeId),
      reminderDaysBefore: Value(dto.reminderDaysBefore),
    );
  }

  Future<void> _cacheBillReminder(BillReminderDto dto) async {
    await _localDatabase.recurringDao.insertBillReminder(
      _toBillReminderCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  static storage.TagsCompanion _toTagCompanion(TagDto dto) {
    return storage.TagsCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
    );
  }

  // --- Transaction template mappers ---

  static String _encodeTagIds(List<String> ids) => jsonEncode(ids);

  static List<String> _decodeTagIds(String? json) {
    if (json == null || json.isEmpty) return const [];
    try {
      final decoded = jsonDecode(json);
      if (decoded is! List) return const [];
      return decoded.whereType<String>().toList();
    } on FormatException {
      return const [];
    }
  }

  static TransactionTemplate _mapTemplateFromDto(TransactionTemplateDto dto) {
    return TransactionTemplate(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
      type: dto.type,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      accountId: dto.accountId,
      envelopeId: dto.envelopeId,
      amountCents: dto.amountCents,
      payee: dto.payee,
      notes: dto.notes,
      currency: dto.currency,
      tagIds: _decodeTagIds(dto.tagIdsJson),
      sortOrder: dto.sortOrder,
      deletedAt: dto.deletedAt,
    );
  }

  static TransactionTemplate _mapTemplateFromLocal(
    storage.TransactionTemplate row,
  ) {
    return TransactionTemplate(
      id: row.id,
      budgetId: row.budgetId,
      name: row.name,
      type: row.type,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      accountId: row.accountId,
      envelopeId: row.envelopeId,
      amountCents: row.amountCents,
      payee: row.payee,
      notes: row.notes,
      currency: row.currency,
      tagIds: _decodeTagIds(row.tagIdsJson),
      sortOrder: row.sortOrder,
      deletedAt: row.deletedAt,
    );
  }

  static TransactionTemplateDto _toTemplateDto(TransactionTemplate template) {
    return TransactionTemplateDto(
      id: template.id,
      budgetId: template.budgetId,
      name: template.name,
      type: template.type,
      createdAt: template.createdAt,
      updatedAt: template.updatedAt,
      accountId: template.accountId,
      envelopeId: template.envelopeId,
      amountCents: template.amountCents,
      payee: template.payee,
      notes: template.notes,
      currency: template.currency,
      tagIdsJson: template.tagIds.isEmpty
          ? null
          : _encodeTagIds(template.tagIds),
      sortOrder: template.sortOrder,
      deletedAt: template.deletedAt,
    );
  }

  static storage.TransactionTemplatesCompanion _toTemplateCompanion(
    TransactionTemplateDto dto,
  ) {
    return storage.TransactionTemplatesCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
      type: dto.type,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      accountId: Value(dto.accountId),
      envelopeId: Value(dto.envelopeId),
      amountCents: Value(dto.amountCents),
      payee: Value(dto.payee),
      notes: Value(dto.notes),
      currency: Value(dto.currency),
      tagIdsJson: Value(dto.tagIdsJson),
      sortOrder: Value(dto.sortOrder),
      deletedAt: Value(dto.deletedAt),
    );
  }
}
