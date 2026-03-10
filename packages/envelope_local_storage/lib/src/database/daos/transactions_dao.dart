import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [Transactions, TransactionSplits, Tags, TransactionTags])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.attachedDatabase);

  // Transactions CRUD
  Future<List<Transaction>> getAllTransactions() =>
      select(transactions).get();

  Stream<List<Transaction>> watchAllTransactions() =>
      select(transactions).watch();

  Future<Transaction?> getTransaction(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<Transaction> watchTransaction(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).watchSingle();

  Future<List<Transaction>> getTransactionsByBudgetId(String budgetId) =>
      (select(transactions)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<Transaction>> watchTransactionsByBudgetId(String budgetId) =>
      (select(transactions)..where((t) => t.budgetId.equals(budgetId)))
          .watch();

  Future<List<Transaction>> getTransactionsByAccountId(String accountId) =>
      (select(transactions)..where((t) => t.accountId.equals(accountId)))
          .get();

  Future<List<Transaction>> getTransactionsByEnvelopeId(String envelopeId) =>
      (select(transactions)..where((t) => t.envelopeId.equals(envelopeId)))
          .get();

  Future<int> insertTransaction(TransactionsCompanion transaction) =>
      into(transactions).insert(transaction);

  Future<bool> updateTransaction(TransactionsCompanion transaction) =>
      update(transactions).replace(transaction);

  Future<int> deleteTransaction(String id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  // Transaction Splits CRUD
  Future<List<TransactionSplit>> getSplitsByTransactionId(
    String transactionId,
  ) =>
      (select(transactionSplits)
            ..where((t) => t.transactionId.equals(transactionId)))
          .get();

  Stream<List<TransactionSplit>> watchSplitsByTransactionId(
    String transactionId,
  ) =>
      (select(transactionSplits)
            ..where((t) => t.transactionId.equals(transactionId)))
          .watch();

  Future<int> insertTransactionSplit(TransactionSplitsCompanion split) =>
      into(transactionSplits).insert(split);

  Future<bool> updateTransactionSplit(TransactionSplitsCompanion split) =>
      update(transactionSplits).replace(split);

  Future<int> deleteTransactionSplit(String id) =>
      (delete(transactionSplits)..where((t) => t.id.equals(id))).go();

  Future<int> deleteSplitsByTransactionId(String transactionId) =>
      (delete(transactionSplits)
            ..where((t) => t.transactionId.equals(transactionId)))
          .go();

  // Tags CRUD
  Future<List<Tag>> getAllTags() => select(tags).get();

  Future<List<Tag>> getTagsByBudgetId(String budgetId) =>
      (select(tags)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<Tag>> watchTagsByBudgetId(String budgetId) =>
      (select(tags)..where((t) => t.budgetId.equals(budgetId))).watch();

  Future<int> insertTag(TagsCompanion tag) => into(tags).insert(tag);

  Future<bool> updateTag(TagsCompanion tag) => update(tags).replace(tag);

  Future<int> deleteTag(String id) =>
      (delete(tags)..where((t) => t.id.equals(id))).go();

  // Transaction Tags CRUD
  Future<List<TransactionTag>> getTagsByTransactionId(
    String transactionId,
  ) =>
      (select(transactionTags)
            ..where((t) => t.transactionId.equals(transactionId)))
          .get();

  Future<List<TransactionTag>> getTransactionsByTagId(String tagId) =>
      (select(transactionTags)..where((t) => t.tagId.equals(tagId))).get();

  Future<int> insertTransactionTag(TransactionTagsCompanion transactionTag) =>
      into(transactionTags).insert(transactionTag);

  Future<int> deleteTransactionTag({
    required String transactionId,
    required String tagId,
  }) =>
      (delete(transactionTags)
            ..where(
              (t) =>
                  t.transactionId.equals(transactionId) &
                  t.tagId.equals(tagId),
            ))
          .go();

  Future<int> deleteTagsByTransactionId(String transactionId) =>
      (delete(transactionTags)
            ..where((t) => t.transactionId.equals(transactionId)))
          .go();
}
