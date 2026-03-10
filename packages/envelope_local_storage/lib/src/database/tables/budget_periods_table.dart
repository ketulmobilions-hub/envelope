import 'package:drift/drift.dart';

class BudgetPeriods extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  DateTimeColumn get startDate => dateTime().named('start_date')();
  DateTimeColumn get endDate => dateTime().named('end_date')();
  IntColumn get totalIncome =>
      integer().named('total_income').withDefault(const Constant(0))();
  IntColumn get totalAllocated =>
      integer().named('total_allocated').withDefault(const Constant(0))();
  BoolColumn get isClosed =>
      boolean().named('is_closed').withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
