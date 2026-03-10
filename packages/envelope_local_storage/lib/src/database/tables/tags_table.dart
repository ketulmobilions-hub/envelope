import 'package:drift/drift.dart';

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}
