import 'package:drift/drift.dart';

class SyncMetadata extends Table {
  TextColumn get id => text()();
  TextColumn get syncTableName => text().named('table_name')();
  TextColumn get recordId => text().named('record_id')();
  DateTimeColumn get lastModified => dateTime().named('last_modified')();
  BoolColumn get isDeleted =>
      boolean().named('is_deleted').withDefault(const Constant(false))();
  TextColumn get deviceId => text().named('device_id')();
  TextColumn get syncStatus =>
      text().named('sync_status').withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
