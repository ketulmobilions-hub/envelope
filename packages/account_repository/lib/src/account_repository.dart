// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:account_repository/src/models/models.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart'
    hide Account, DebtAccount;

/// Repository for account operations.
class AccountRepository {
  const AccountRepository({
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;

  /// Creates a new account.
  Future<Account> createAccount({
    required String budgetId,
    required String name,
    required String type,
    required String currency,
    int startingBalance = 0,
  }) async {
    // TODO(envelope): Implement create account
    throw UnimplementedError();
  }

  /// Gets an account by its [id].
  Future<Account> getAccount(String id) async {
    // TODO(envelope): Implement get account
    throw UnimplementedError();
  }

  /// Watches all accounts for a [budgetId].
  Stream<List<Account>> watchAccounts(String budgetId) {
    // TODO(envelope): Implement watch accounts
    throw UnimplementedError();
  }

  /// Updates an [account].
  Future<void> updateAccount(Account account) async {
    // TODO(envelope): Implement update account
    throw UnimplementedError();
  }

  /// Deletes an account by its [id].
  Future<void> deleteAccount(String id) async {
    // TODO(envelope): Implement delete account
    throw UnimplementedError();
  }

  /// Archives an account by its [id].
  Future<void> archiveAccount(String id) async {
    // TODO(envelope): Implement archive account
    throw UnimplementedError();
  }

  /// Reconciles an account balance.
  Future<void> reconcileAccount(String id, int balance) async {
    // TODO(envelope): Implement reconcile account
    throw UnimplementedError();
  }

  /// Creates a debt account linked to an existing account.
  Future<DebtAccount> createDebtAccount({
    required String accountId,
    required double interestRate,
    required int minimumPayment,
    required int originalBalance,
    String? payoffStrategy,
  }) async {
    // TODO(envelope): Implement create debt account
    throw UnimplementedError();
  }

  /// Gets the debt account details for an [accountId].
  Future<DebtAccount?> getDebtAccount(String accountId) async {
    // TODO(envelope): Implement get debt account
    throw UnimplementedError();
  }

  /// Updates a [debtAccount].
  Future<void> updateDebtAccount(DebtAccount debtAccount) async {
    // TODO(envelope): Implement update debt account
    throw UnimplementedError();
  }

  /// Deletes a debt account by its [accountId].
  Future<void> deleteDebtAccount(String accountId) async {
    // TODO(envelope): Implement delete debt account
    throw UnimplementedError();
  }
}
