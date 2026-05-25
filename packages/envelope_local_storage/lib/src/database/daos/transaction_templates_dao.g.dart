// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_templates_dao.dart';

// ignore_for_file: type=lint
mixin _$TransactionTemplatesDaoMixin on DatabaseAccessor<AppDatabase> {
  $TransactionTemplatesTable get transactionTemplates =>
      attachedDatabase.transactionTemplates;
  TransactionTemplatesDaoManager get managers =>
      TransactionTemplatesDaoManager(this);
}

class TransactionTemplatesDaoManager {
  final _$TransactionTemplatesDaoMixin _db;
  TransactionTemplatesDaoManager(this._db);
  $$TransactionTemplatesTableTableManager get transactionTemplates =>
      $$TransactionTemplatesTableTableManager(
        _db.attachedDatabase,
        _db.transactionTemplates,
      );
}
