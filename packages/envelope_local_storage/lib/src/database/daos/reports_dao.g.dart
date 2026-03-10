// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_dao.dart';

// ignore_for_file: type=lint
mixin _$ReportsDaoMixin on DatabaseAccessor<AppDatabase> {
  $NetWorthSnapshotsTable get netWorthSnapshots =>
      attachedDatabase.netWorthSnapshots;
  $ActivityLogTable get activityLog => attachedDatabase.activityLog;
  ReportsDaoManager get managers => ReportsDaoManager(this);
}

class ReportsDaoManager {
  final _$ReportsDaoMixin _db;
  ReportsDaoManager(this._db);
  $$NetWorthSnapshotsTableTableManager get netWorthSnapshots =>
      $$NetWorthSnapshotsTableTableManager(
        _db.attachedDatabase,
        _db.netWorthSnapshots,
      );
  $$ActivityLogTableTableManager get activityLog =>
      $$ActivityLogTableTableManager(_db.attachedDatabase, _db.activityLog);
}
