import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/connection/connection.dart';
import 'package:envelope_local_storage/src/database/daos/daos.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Budgets,
    BudgetMembers,
    BudgetPeriods,
    Accounts,
    CategoryGroups,
    Envelopes,
    EnvelopeAllocations,
    Transactions,
    TransactionSplits,
    Tags,
    TransactionTags,
    RecurringRules,
    BillReminders,
    AllocationTemplates,
    AllocationTemplateItems,
    Goals,
    GoalContributions,
    DebtAccounts,
    ActivityLog,
    NotificationPreferences,
    PushTokens,
    NetWorthSnapshots,
    SyncMetadata,
  ],
  daos: [
    UsersDao,
    BudgetsDao,
    AccountsDao,
    EnvelopesDao,
    TransactionsDao,
    RecurringDao,
    GoalsDao,
    ReportsDao,
    SyncDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 15;

  /// Deletes all rows from every table. Used for account deletion / GDPR.
  Future<void> clearAllTables() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(envelopes, envelopes.color);
      }
      if (from < 3) {
        // Make user_id nullable on budget_members for pending invites.
        await customStatement(
          'CREATE TABLE budget_members_tmp ('
          'id TEXT NOT NULL PRIMARY KEY, '
          'budget_id TEXT NOT NULL, '
          'user_id TEXT, '
          'role TEXT NOT NULL DEFAULT \'viewer\', '
          'invited_via TEXT NOT NULL, '
          'accepted_at INTEGER, '
          'created_at INTEGER NOT NULL'
          ')',
        );
        await customStatement(
          'INSERT INTO budget_members_tmp '
          'SELECT * FROM budget_members',
        );
        await customStatement('DROP TABLE budget_members');
        await customStatement(
          'ALTER TABLE budget_members_tmp '
          'RENAME TO budget_members',
        );
      }
      if (from < 4) {
        await m.addColumn(accounts, accounts.isOnBudget);
      }
      if (from < 5) {
        await m.createTable(pushTokens);
      }
      if (from < 6) {
        await m.addColumn(transactions, transactions.deletedAt);
        await m.addColumn(envelopes, envelopes.deletedAt);
      }
      if (from < 7) {
        await m.createTable(goalContributions);
      }
      if (from < 8) {
        await m.addColumn(
          notificationPreferences,
          notificationPreferences.emailBillReminders,
        );
      }
      if (from < 9) {
        await m.addColumn(envelopes, envelopes.linkedAccountId);
      }
      if (from < 10) {
        await m.addColumn(debtAccounts, debtAccounts.creditLimit);
      }
      if (from < 11) {
        await m.addColumn(transactions, transactions.baseCurrencyAmount);
        // Backfill: amount × exchange_rate, rounded to int cents.
        await customStatement(
          'UPDATE transactions '
          'SET base_currency_amount = '
          'CAST(amount * exchange_rate AS INTEGER) '
          'WHERE base_currency_amount = 0',
        );
      }
      if (from < 12) {
        await m.addColumn(accounts, accounts.displayFxRate);
      }
      if (from < 13) {
        await m.addColumn(recurringRules, recurringRules.exchangeRate);
      }
      if (from < 14) {
        await m.addColumn(goals, goals.aprBps);
        await m.addColumn(goals, goals.minPaymentCents);
      }
      if (from < 15) {
        await m.addColumn(goals, goals.sortOrder);
      }
    },
  );
}
