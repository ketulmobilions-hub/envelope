import 'package:drift/drift.dart';

class Envelopes extends Table {
  TextColumn get id => text()();
  TextColumn get categoryGroupId => text().named('category_group_id')();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get name => text()();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  BoolColumn get isArchived =>
      boolean().named('is_archived').withDefault(const Constant(false))();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get deletedAt => dateTime().named('deleted_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
