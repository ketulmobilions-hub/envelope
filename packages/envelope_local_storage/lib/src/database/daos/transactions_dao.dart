import 'dart:async';

import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [Transactions, TransactionSplits, Tags, TransactionTags])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.attachedDatabase);

  // Transactions CRUD
  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Stream<List<Transaction>> watchAllTransactions() =>
      select(transactions).watch();

  Future<Transaction?> getTransaction(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<Transaction> watchTransaction(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).watchSingle();

  Future<List<Transaction>> getTransactionsByBudgetId(String budgetId) =>
      (select(transactions)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<Transaction>> watchTransactionsByBudgetId(String budgetId) =>
      (select(transactions)..where((t) => t.budgetId.equals(budgetId))).watch();

  Future<List<Transaction>> getTransactionsByAccountId(String accountId) =>
      (select(transactions)..where((t) => t.accountId.equals(accountId))).get();

  Future<List<Transaction>> getTransactionsByEnvelopeId(String envelopeId) =>
      (select(
        transactions,
      )..where((t) => t.envelopeId.equals(envelopeId))).get();

  Future<int> insertTransaction(
    TransactionsCompanion transaction, {
    InsertMode mode = InsertMode.insert,
  }) => into(transactions).insert(transaction, mode: mode);

  Future<bool> updateTransaction(TransactionsCompanion transaction) =>
      update(transactions).replace(transaction);

  Future<int> deleteTransaction(String id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  /// Sums `base_currency_amount` of all income transactions for [budgetId].
  /// Excludes soft-deleted rows.
  Future<int> sumIncomeByBudgetId(String budgetId) async {
    final sumExp = transactions.baseCurrencyAmount.sum();
    final query = selectOnly(transactions)
      ..addColumns([sumExp])
      ..where(
        transactions.budgetId.equals(budgetId) &
            transactions.type.equals('income') &
            transactions.deletedAt.isNull(),
      );
    final row = await query.getSingleOrNull();
    return row?.read(sumExp)?.toInt() ?? 0;
  }

  /// Streams the running income total for [budgetId].
  Stream<int> watchIncomeByBudgetId(String budgetId) {
    final sumExp = transactions.baseCurrencyAmount.sum();
    final query = selectOnly(transactions)
      ..addColumns([sumExp])
      ..where(
        transactions.budgetId.equals(budgetId) &
            transactions.type.equals('income') &
            transactions.deletedAt.isNull(),
      );
    return query.watchSingleOrNull().map(
      (row) => row?.read(sumExp)?.toInt() ?? 0,
    );
  }

  /// Sums every expense amount charged against [envelopeId], including
  /// split-mode contributions. Parent transactions whose `envelopeId == X`
  /// AND parent splits whose `envelopeId == X` (with their split amount
  /// scaled to the parent's exchange rate) both count.
  Future<int> sumExpensesByEnvelopeId(String envelopeId) async {
    // Direct (non-split) expense rows.
    final sumDirect = transactions.baseCurrencyAmount.sum();
    final directQuery = selectOnly(transactions)
      ..addColumns([sumDirect])
      ..where(
        transactions.envelopeId.equals(envelopeId) &
            transactions.type.equals('expense') &
            transactions.deletedAt.isNull(),
      );
    final directRow = await directQuery.getSingleOrNull();
    final direct = directRow?.read(sumDirect)?.toInt() ?? 0;

    // Split contributions: split.amount * parent.exchange_rate so the result
    // is in the budget's base currency.
    final splitContribution =
        (transactionSplits.amount.cast<double>() * transactions.exchangeRate)
            .sum();
    final splitQuery =
        selectOnly(transactionSplits).join([
            innerJoin(
              transactions,
              transactions.id.equalsExp(transactionSplits.transactionId),
            ),
          ])
          ..addColumns([splitContribution])
          ..where(
            transactionSplits.envelopeId.equals(envelopeId) &
                transactions.type.equals('expense') &
                transactions.deletedAt.isNull(),
          );
    final splitRow = await splitQuery.getSingleOrNull();
    final splits = (splitRow?.read(splitContribution) ?? 0).round();

    return direct + splits;
  }

  /// Streams a per-envelope expense total for [budgetId], including split
  /// contributions. Returns a `Map<envelopeId, totalCents>` emitted once on
  /// subscribe (current state) and then on any transactions /
  /// transaction_splits change in the budget.
  Stream<Map<String, int>> watchExpensesByEnvelopeForBudget(String budgetId) {
    late StreamController<Map<String, int>> controller;
    StreamSubscription<Set<TableUpdate>>? sub;
    var disposed = false;

    Future<void> emitLatest() async {
      if (disposed) return;
      try {
        final value = await _computeExpensesByEnvelope(budgetId);
        if (!disposed && !controller.isClosed) controller.add(value);
      } on Object catch (e, st) {
        if (!disposed && !controller.isClosed) controller.addError(e, st);
      }
    }

    controller = StreamController<Map<String, int>>(
      onListen: () {
        // Initial emission so a fresh subscriber sees current state without
        // having to wait for the next transactions write.
        unawaited(emitLatest());
        sub = attachedDatabase
            .tableUpdates(
              TableUpdateQuery.onAllTables({transactions, transactionSplits}),
            )
            .listen((_) => unawaited(emitLatest()));
      },
      onCancel: () async {
        disposed = true;
        await sub?.cancel();
      },
    );
    return controller.stream.distinct(_mapEquals);
  }

  Future<Map<String, int>> _computeExpensesByEnvelope(String budgetId) async {
    final result = <String, int>{};

    // Direct (non-split) expenses grouped by envelope_id.
    final directSum = transactions.baseCurrencyAmount.sum();
    final directQuery = selectOnly(transactions)
      ..addColumns([transactions.envelopeId, directSum])
      ..where(
        transactions.budgetId.equals(budgetId) &
            transactions.type.equals('expense') &
            transactions.deletedAt.isNull() &
            transactions.envelopeId.isNotNull(),
      )
      ..groupBy([transactions.envelopeId]);
    for (final row in await directQuery.get()) {
      final envId = row.read(transactions.envelopeId);
      final total = row.read(directSum)?.toInt() ?? 0;
      if (envId != null && total != 0) {
        result.update(envId, (v) => v + total, ifAbsent: () => total);
      }
    }

    // Split contributions: split.amount * parent.exchange_rate, grouped by
    // splits.envelope_id.
    final splitSum =
        (transactionSplits.amount.cast<double>() * transactions.exchangeRate)
            .sum();
    final splitQuery =
        selectOnly(transactionSplits).join([
            innerJoin(
              transactions,
              transactions.id.equalsExp(transactionSplits.transactionId),
            ),
          ])
          ..addColumns([transactionSplits.envelopeId, splitSum])
          ..where(
            transactions.budgetId.equals(budgetId) &
                transactions.type.equals('expense') &
                transactions.deletedAt.isNull(),
          )
          ..groupBy([transactionSplits.envelopeId]);
    for (final row in await splitQuery.get()) {
      final envId = row.read(transactionSplits.envelopeId);
      final total = (row.read(splitSum) ?? 0).round();
      if (envId != null && total != 0) {
        result.update(envId, (v) => v + total, ifAbsent: () => total);
      }
    }

    return result;
  }

  static bool _mapEquals(Map<String, int> a, Map<String, int> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }

  // Transaction Splits CRUD
  Future<List<TransactionSplit>> getSplitsByTransactionId(
    String transactionId,
  ) => (select(
    transactionSplits,
  )..where((t) => t.transactionId.equals(transactionId))).get();

  Stream<List<TransactionSplit>> watchSplitsByTransactionId(
    String transactionId,
  ) => (select(
    transactionSplits,
  )..where((t) => t.transactionId.equals(transactionId))).watch();

  Future<int> insertTransactionSplit(
    TransactionSplitsCompanion split, {
    InsertMode mode = InsertMode.insert,
  }) => into(transactionSplits).insert(split, mode: mode);

  Future<bool> updateTransactionSplit(TransactionSplitsCompanion split) =>
      update(transactionSplits).replace(split);

  Future<int> deleteTransactionSplit(String id) =>
      (delete(transactionSplits)..where((t) => t.id.equals(id))).go();

  Future<int> deleteSplitsByTransactionId(String transactionId) => (delete(
    transactionSplits,
  )..where((t) => t.transactionId.equals(transactionId))).go();

  /// Watches a map of transactionId → envelopeIds for all split transactions
  /// belonging to [budgetId].
  Stream<Map<String, List<String>>> watchSplitEnvelopeIds(String budgetId) {
    final query = select(transactions).join([
      innerJoin(
        transactionSplits,
        transactionSplits.transactionId.equalsExp(transactions.id),
      ),
    ])..where(transactions.budgetId.equals(budgetId));
    return query.watch().map((rows) {
      final result = <String, List<String>>{};
      for (final row in rows) {
        final txnId = row.readTable(transactions).id;
        final split = row.readTable(transactionSplits);
        result.putIfAbsent(txnId, () => []).add(split.envelopeId);
      }
      return result;
    });
  }

  // Tags CRUD
  Future<List<Tag>> getAllTags() => select(tags).get();

  Future<List<Tag>> getTagsByBudgetId(String budgetId) =>
      (select(tags)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<Tag>> watchTagsByBudgetId(String budgetId) =>
      (select(tags)..where((t) => t.budgetId.equals(budgetId))).watch();

  Future<int> insertTag(
    TagsCompanion tag, {
    InsertMode mode = InsertMode.insert,
  }) => into(tags).insert(tag, mode: mode);

  Future<bool> updateTag(TagsCompanion tag) => update(tags).replace(tag);

  Future<int> deleteTag(String id) =>
      (delete(tags)..where((t) => t.id.equals(id))).go();

  // Transaction Tags CRUD
  Future<List<TransactionTag>> getTagsByTransactionId(
    String transactionId,
  ) => (select(
    transactionTags,
  )..where((t) => t.transactionId.equals(transactionId))).get();

  Future<List<TransactionTag>> getTransactionsByTagId(String tagId) =>
      (select(transactionTags)..where((t) => t.tagId.equals(tagId))).get();

  Future<int> insertTransactionTag(
    TransactionTagsCompanion transactionTag, {
    InsertMode mode = InsertMode.insert,
  }) => into(transactionTags).insert(transactionTag, mode: mode);

  Future<int> deleteTransactionTag({
    required String transactionId,
    required String tagId,
  }) =>
      (delete(transactionTags)..where(
            (t) =>
                t.transactionId.equals(transactionId) & t.tagId.equals(tagId),
          ))
          .go();

  Future<int> deleteTagsByTransactionId(String transactionId) => (delete(
    transactionTags,
  )..where((t) => t.transactionId.equals(transactionId))).go();
}
