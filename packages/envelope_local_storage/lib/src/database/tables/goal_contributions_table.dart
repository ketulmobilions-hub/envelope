import 'package:drift/drift.dart';

class GoalContributions extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text().named('goal_id')();
  IntColumn get amountCents => integer().named('amount_cents')();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
