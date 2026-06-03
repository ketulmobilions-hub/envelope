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
    TransactionTemplates,
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
    TransactionTemplatesDao,
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
  int get schemaVersion => 19;

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
      if (from < 16) {
        await m.createTable(transactionTemplates);
      }
      if (from < 17) {
        await m.addColumn(budgetPeriods, budgetPeriods.carriedRta);
      }
      if (from < 18) {
        // Adds the period-agnostic seed-cash columns to budgets (issue #80).
        // Backfill of existing budgets (moving seed cash off the onboarding
        // period's `total_income`) ships in a paired migration alongside
        // the Phase 3 RTA-logic PR to avoid an interim RTA regression for
        // existing users.
        await m.addColumn(budgets, budgets.openingBalance);
        await m.addColumn(budgets, budgets.openingDate);
      }
      if (from < 19) {
        // Issue #80 phase 7: data backfill paired with Supabase 00040.
        //
        // Moves the seed cash for pre-phase-2 budgets off the onboarding
        // period's `total_income` onto `budgets.opening_balance` /
        // `budgets.opening_date`. The per-period RTA is invariant under this
        // swap because the phase-3 formula folds `opening_contribution` into
        // the same period that previously sourced the seed via `total_income`
        // — so no `carried_rta` recompute is needed.
        await backfillOpeningBalance(this);
      }
    },
  );
}

/// Backfills `opening_balance` / `opening_date` for pre-phase-2 budgets by
/// moving the seed cash off the earliest period's `total_income` onto the
/// budget row. Idempotent — only touches budgets that still hold the column
/// defaults (`opening_balance = 0 AND opening_date IS NULL`).
///
/// `opening_date` is set to the earliest period's `start_date` precisely so
/// the phase-3 `calculateReadyToAssign` formula folds `opening_contribution`
/// into the same period that previously sourced the seed via `total_income`
/// — making the per-period RTA invariant under this swap.
///
/// Exposed at library level so the migration step and the integration test
/// can share the same SQL. Match-up with Supabase migration 00040.
Future<void> backfillOpeningBalance(AppDatabase db) async {
  await db.transaction(() async {
    // Gate: budget still on phase-1 defaults AND its EARLIEST period (by
    // start_date) holds positive income. Matching the *earliest* — rather
    // than any period — keeps Drift parity with the Postgres CTE
    // (`distinct on (budget_id) ... order by start_date asc` in 00040). A
    // pathological budget whose earliest period has total_income = 0 but a
    // later one has positive income is intentionally skipped: pre-phase-2
    // onboarding always wrote the seed to the very first period, so any
    // other shape is corrupted state we should not silently move.
    await db.customStatement('''
      UPDATE budgets
         SET opening_balance = (
               SELECT bp.total_income
                 FROM budget_periods bp
                WHERE bp.budget_id = budgets.id
                ORDER BY bp.start_date ASC
                LIMIT 1
             ),
             opening_date = (
               SELECT bp.start_date
                 FROM budget_periods bp
                WHERE bp.budget_id = budgets.id
                ORDER BY bp.start_date ASC
                LIMIT 1
             ),
             updated_at = ?
       WHERE opening_balance = 0
         AND opening_date IS NULL
         AND (
               SELECT bp.total_income
                 FROM budget_periods bp
                WHERE bp.budget_id = budgets.id
                ORDER BY bp.start_date ASC
                LIMIT 1
             ) > 0;
    ''', [DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000]);

    // Tight gate: only zero the period whose `total_income` matches the
    // budget's `opening_balance` we just set. This protects phase-2 budgets
    // (whose anchor period typically has `total_income = 0` already) and any
    // budget whose anchor-period income coincidentally diverges from the
    // stored anchor amount. It also makes the second statement idempotent —
    // re-running finds `total_income = 0 != opening_balance`, so nothing
    // matches.
    await db.customStatement('''
      UPDATE budget_periods
         SET total_income = 0
       WHERE id IN (
               SELECT bp.id FROM budget_periods bp
                 JOIN budgets b ON b.id = bp.budget_id
                WHERE b.opening_date IS NOT NULL
                  AND b.opening_balance > 0
                  AND bp.start_date = b.opening_date
                  AND bp.total_income = b.opening_balance
             );
    ''');
  });
}
