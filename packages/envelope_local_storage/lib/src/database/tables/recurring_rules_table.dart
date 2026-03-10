import 'package:drift/drift.dart';

class RecurringRules extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get accountId => text().named('account_id')();
  TextColumn get envelopeId => text().named('envelope_id').nullable()();
  TextColumn get type => text()();
  IntColumn get amount => integer()();
  TextColumn get currency => text()();
  TextColumn get payee => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get frequency => text()();
  IntColumn get customInterval =>
      integer().named('custom_interval').nullable()();
  TextColumn get customUnit => text().named('custom_unit').nullable()();
  DateTimeColumn get startDate => dateTime().named('start_date')();
  DateTimeColumn get endDate => dateTime().named('end_date').nullable()();
  DateTimeColumn get nextOccurrence => dateTime().named('next_occurrence')();
  BoolColumn get autoPost =>
      boolean().named('auto_post').withDefault(const Constant(false))();
  BoolColumn get isPaused =>
      boolean().named('is_paused').withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
