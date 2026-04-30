import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'reports_dao.g.dart';

@DriftAccessor(tables: [NetWorthSnapshots, ActivityLog])
class ReportsDao extends DatabaseAccessor<AppDatabase> with _$ReportsDaoMixin {
  ReportsDao(super.attachedDatabase);

  // Net Worth Snapshots CRUD
  Future<List<NetWorthSnapshot>> getAllNetWorthSnapshots() =>
      select(netWorthSnapshots).get();

  Future<List<NetWorthSnapshot>> getNetWorthSnapshotsByBudgetId(
    String budgetId,
  ) => (select(
    netWorthSnapshots,
  )..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<NetWorthSnapshot>> watchNetWorthSnapshotsByBudgetId(
    String budgetId,
  ) => (select(
    netWorthSnapshots,
  )..where((t) => t.budgetId.equals(budgetId))).watch();

  Future<int> insertNetWorthSnapshot(NetWorthSnapshotsCompanion snapshot) =>
      into(netWorthSnapshots).insert(snapshot);

  Future<int> upsertNetWorthSnapshot(NetWorthSnapshotsCompanion snapshot) =>
      into(
        netWorthSnapshots,
      ).insert(snapshot, mode: InsertMode.insertOrReplace);

  Future<bool> updateNetWorthSnapshot(NetWorthSnapshotsCompanion snapshot) =>
      update(netWorthSnapshots).replace(snapshot);

  Future<int> deleteNetWorthSnapshot(String id) =>
      (delete(netWorthSnapshots)..where((t) => t.id.equals(id))).go();

  // Activity Log CRUD
  Future<List<ActivityLogData>> getAllActivityLogs() =>
      select(activityLog).get();

  Future<List<ActivityLogData>> getActivityLogsByBudgetId(String budgetId) =>
      (select(activityLog)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<ActivityLogData>> watchActivityLogsByBudgetId(String budgetId) =>
      (select(activityLog)..where((t) => t.budgetId.equals(budgetId))).watch();

  Future<List<ActivityLogData>> getActivityLogsByUserId(String userId) =>
      (select(activityLog)..where((t) => t.userId.equals(userId))).get();

  Future<int> insertActivityLog(
    ActivityLogCompanion log, {
    InsertMode mode = InsertMode.insert,
  }) => into(activityLog).insert(log, mode: mode);

  Future<void> batchInsertActivityLogs(
    List<ActivityLogCompanion> entries, {
    InsertMode mode = InsertMode.insert,
  }) async {
    await batch((b) {
      b.insertAll(activityLog, entries, mode: mode);
    });
  }

  Future<int> deleteActivityLog(String id) =>
      (delete(activityLog)..where((t) => t.id.equals(id))).go();

  Future<int> deleteActivityLogsByBudgetId(String budgetId) =>
      (delete(activityLog)..where((t) => t.budgetId.equals(budgetId))).go();
}
