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
    DebtAccounts,
    ActivityLog,
    NotificationPreferences,
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(envelopes, envelopes.color);
          }
        },
      );
}
