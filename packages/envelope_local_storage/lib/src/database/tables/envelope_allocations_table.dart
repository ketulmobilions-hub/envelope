import 'package:drift/drift.dart';

class EnvelopeAllocations extends Table {
  TextColumn get id => text()();
  TextColumn get envelopeId => text().named('envelope_id').unique()();
  IntColumn get allocatedAmount =>
      integer().named('allocated_amount').withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
