import 'package:drift/drift.dart';

class TransactionTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get accountId => text().named('account_id').nullable()();
  TextColumn get envelopeId => text().named('envelope_id').nullable()();
  IntColumn get amountCents =>
      integer().named('amount_cents').nullable()();
  TextColumn get payee => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get tagIdsJson => text().named('tag_ids_json').nullable()();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get deletedAt => dateTime().named('deleted_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
