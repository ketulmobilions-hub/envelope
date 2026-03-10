// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart'
    hide BillReminder, RecurringRule, Tag, Transaction, TransactionSplit;
import 'package:transaction_repository/transaction_repository.dart';

/// Repository for transaction, recurring rule, bill reminder, and tag
/// operations.
class TransactionRepository {
  const TransactionRepository({
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;

  // --- Transactions ---

  /// Creates a new transaction.
  Future<Transaction> createTransaction({
    required String budgetId,
    required String accountId,
    required String type,
    required int amount,
    required String currency,
    required DateTime date,
    required String createdBy,
    String? envelopeId,
    String? payee,
    String? notes,
  }) async {
    // TODO(envelope): implement createTransaction
    throw UnimplementedError();
  }

  /// Gets a transaction by its [id].
  Future<Transaction> getTransaction(String id) async {
    // TODO(envelope): implement getTransaction
    throw UnimplementedError();
  }

  /// Watches transactions for a [budgetId], optionally filtered by account
  /// or envelope.
  Stream<List<Transaction>> watchTransactions({
    required String budgetId,
    String? accountId,
    String? envelopeId,
  }) {
    // TODO(envelope): implement watchTransactions
    throw UnimplementedError();
  }

  /// Updates a [transaction].
  Future<void> updateTransaction(Transaction transaction) async {
    // TODO(envelope): implement updateTransaction
    throw UnimplementedError();
  }

  /// Deletes a transaction by its [id].
  Future<void> deleteTransaction(String id) async {
    // TODO(envelope): implement deleteTransaction
    throw UnimplementedError();
  }

  // --- Split Transactions ---

  /// Creates split entries for a transaction.
  Future<void> createSplitTransaction({
    required String transactionId,
    required List<TransactionSplit> splits,
  }) async {
    // TODO(envelope): implement createSplitTransaction
    throw UnimplementedError();
  }

  /// Gets all splits for a [transactionId].
  Future<List<TransactionSplit>> getTransactionSplits(
    String transactionId,
  ) async {
    // TODO(envelope): implement getTransactionSplits
    throw UnimplementedError();
  }

  // --- Recurring Rules ---

  /// Creates a new recurring rule.
  Future<RecurringRule> createRecurringRule({
    required String budgetId,
    required String accountId,
    required String type,
    required int amount,
    required String currency,
    required String frequency,
    required DateTime startDate,
    String? envelopeId,
    String? payee,
    String? notes,
    int? customInterval,
    String? customUnit,
    DateTime? endDate,
    bool autoPost = false,
  }) async {
    // TODO(envelope): implement createRecurringRule
    throw UnimplementedError();
  }

  /// Watches all recurring rules for a [budgetId].
  Stream<List<RecurringRule>> watchRecurringRules(String budgetId) {
    // TODO(envelope): implement watchRecurringRules
    throw UnimplementedError();
  }

  /// Updates a recurring [rule].
  Future<void> updateRecurringRule(RecurringRule rule) async {
    // TODO(envelope): implement updateRecurringRule
    throw UnimplementedError();
  }

  /// Deletes a recurring rule by its [id].
  Future<void> deleteRecurringRule(String id) async {
    // TODO(envelope): implement deleteRecurringRule
    throw UnimplementedError();
  }

  /// Pauses a recurring rule by its [id].
  Future<void> pauseRecurringRule(String id) async {
    // TODO(envelope): implement pauseRecurringRule
    throw UnimplementedError();
  }

  // --- Bill Reminders ---

  /// Creates a new bill reminder.
  Future<BillReminder> createBillReminder({
    required String budgetId,
    required String name,
    required int estimatedAmount,
    required int dueDay,
    required String frequency,
    String? envelopeId,
    int reminderDaysBefore = 3,
  }) async {
    // TODO(envelope): implement createBillReminder
    throw UnimplementedError();
  }

  /// Watches all bill reminders for a [budgetId].
  Stream<List<BillReminder>> watchBillReminders(String budgetId) {
    // TODO(envelope): implement watchBillReminders
    throw UnimplementedError();
  }

  /// Updates a bill [reminder].
  Future<void> updateBillReminder(BillReminder reminder) async {
    // TODO(envelope): implement updateBillReminder
    throw UnimplementedError();
  }

  /// Deletes a bill reminder by its [id].
  Future<void> deleteBillReminder(String id) async {
    // TODO(envelope): implement deleteBillReminder
    throw UnimplementedError();
  }

  // --- Tags ---

  /// Creates a new tag.
  Future<Tag> createTag({
    required String budgetId,
    required String name,
  }) async {
    // TODO(envelope): implement createTag
    throw UnimplementedError();
  }

  /// Gets all tags for a [budgetId].
  Future<List<Tag>> getTags(String budgetId) async {
    // TODO(envelope): implement getTags
    throw UnimplementedError();
  }

  /// Deletes a tag by its [id].
  Future<void> deleteTag(String id) async {
    // TODO(envelope): implement deleteTag
    throw UnimplementedError();
  }

  /// Adds a tag to a transaction.
  Future<void> addTagToTransaction({
    required String transactionId,
    required String tagId,
  }) async {
    // TODO(envelope): implement addTagToTransaction
    throw UnimplementedError();
  }

  /// Removes a tag from a transaction.
  Future<void> removeTagFromTransaction({
    required String transactionId,
    required String tagId,
  }) async {
    // TODO(envelope): implement removeTagFromTransaction
    throw UnimplementedError();
  }
}
