import 'package:drift/drift.dart';

class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get envelopeId => text().named('envelope_id').nullable()();
  TextColumn get accountId => text().named('account_id').nullable()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  IntColumn get targetAmount => integer().named('target_amount').nullable()();
  DateTimeColumn get targetDate =>
      dateTime().named('target_date').nullable()();
  IntColumn get monthlyContribution =>
      integer().named('monthly_contribution').nullable()();
  IntColumn get currentAmount =>
      integer().named('current_amount').withDefault(const Constant(0))();
  BoolColumn get isCompleted =>
      boolean().named('is_completed').withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
