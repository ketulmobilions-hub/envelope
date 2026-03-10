import 'package:drift/drift.dart';

class NetWorthSnapshots extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  DateTimeColumn get date => dateTime()();
  IntColumn get assets => integer()();
  IntColumn get liabilities => integer()();
  IntColumn get netWorth => integer().named('net_worth')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
