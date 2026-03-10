import 'package:drift/drift.dart';

class CategoryGroups extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get name => text()();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  BoolColumn get isDefault =>
      boolean().named('is_default').withDefault(const Constant(false))();
  BoolColumn get isArchived =>
      boolean().named('is_archived').withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
