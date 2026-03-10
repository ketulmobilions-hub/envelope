import 'package:drift/drift.dart';

class TransactionTags extends Table {
  TextColumn get transactionId => text().named('transaction_id')();
  TextColumn get tagId => text().named('tag_id')();

  @override
  Set<Column> get primaryKey => {transactionId, tagId};
}
