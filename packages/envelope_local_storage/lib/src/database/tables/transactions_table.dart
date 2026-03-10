import 'package:drift/drift.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get accountId => text().named('account_id')();
  TextColumn get envelopeId => text().named('envelope_id').nullable()();
  TextColumn get type => text()();
  IntColumn get amount => integer()();
  TextColumn get currency => text()();
  RealColumn get exchangeRate =>
      real().named('exchange_rate').withDefault(const Constant(1))();
  TextColumn get payee => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isReconciled =>
      boolean().named('is_reconciled').withDefault(const Constant(false))();
  TextColumn get recurringRuleId =>
      text().named('recurring_rule_id').nullable()();
  TextColumn get transferPairId =>
      text().named('transfer_pair_id').nullable()();
  TextColumn get createdBy => text().named('created_by')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
