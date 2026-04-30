import 'package:drift/drift.dart';

class BudgetMembers extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get userId => text().named('user_id').nullable()();
  TextColumn get role => text().withDefault(const Constant('viewer'))();
  TextColumn get invitedVia => text().named('invited_via')();
  DateTimeColumn get acceptedAt => dateTime().named('accepted_at').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
