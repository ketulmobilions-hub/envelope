import 'package:drift/drift.dart';

class TransactionSplits extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text().named('transaction_id')();
  TextColumn get envelopeId => text().named('envelope_id')();
  RealColumn get amount => real()();

  @override
  Set<Column> get primaryKey => {id};
}
