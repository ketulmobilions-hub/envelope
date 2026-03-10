import 'package:drift/drift.dart';

class ActivityLog extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get userId => text().named('user_id')();
  TextColumn get action => text()();
  TextColumn get entityType => text().named('entity_type')();
  TextColumn get entityId => text().named('entity_id')();
  TextColumn get details => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
