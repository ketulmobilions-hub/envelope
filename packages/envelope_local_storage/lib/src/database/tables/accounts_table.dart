import 'package:drift/drift.dart';

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get name => text()();
  TextColumn get type => text()();
  IntColumn get startingBalance =>
      integer().named('starting_balance').withDefault(const Constant(0))();
  IntColumn get currentBalance =>
      integer().named('current_balance').withDefault(const Constant(0))();
  TextColumn get currency => text()();
  BoolColumn get isArchived =>
      boolean().named('is_archived').withDefault(const Constant(false))();
  BoolColumn get isOnBudget =>
      boolean().named('is_on_budget').withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
