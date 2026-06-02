import 'package:drift/drift.dart';

class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().named('owner_id')();
  TextColumn get name => text()();
  TextColumn get periodType =>
      text().named('period_type').withDefault(const Constant('monthly'))();
  IntColumn get periodStartDay =>
      integer().named('period_start_day').withDefault(const Constant(1))();
  TextColumn get baseCurrency => text().named('base_currency')();
  BoolColumn get isArchived =>
      boolean().named('is_archived').withDefault(const Constant(false))();
  IntColumn get openingBalance =>
      integer().named('opening_balance').withDefault(const Constant(0))();
  IntColumn get accountSeedBalance =>
      integer().named('account_seed_balance').withDefault(const Constant(0))();
  DateTimeColumn get openingDate =>
      dateTime().named('opening_date').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
