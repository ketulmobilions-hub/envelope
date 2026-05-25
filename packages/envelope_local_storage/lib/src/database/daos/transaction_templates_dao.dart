import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'transaction_templates_dao.g.dart';

@DriftAccessor(tables: [TransactionTemplates])
class TransactionTemplatesDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionTemplatesDaoMixin {
  TransactionTemplatesDao(super.attachedDatabase);

  Future<List<TransactionTemplate>> getTemplatesByBudgetId(
    String budgetId,
  ) => (select(transactionTemplates)
        ..where((t) => t.budgetId.equals(budgetId) & t.deletedAt.isNull())
        ..orderBy([
          (t) => OrderingTerm.asc(t.sortOrder),
          (t) => OrderingTerm.asc(t.name),
        ]))
      .get();

  Stream<List<TransactionTemplate>> watchTemplatesByBudgetId(
    String budgetId,
  ) => (select(transactionTemplates)
        ..where((t) => t.budgetId.equals(budgetId) & t.deletedAt.isNull())
        ..orderBy([
          (t) => OrderingTerm.asc(t.sortOrder),
          (t) => OrderingTerm.asc(t.name),
        ]))
      .watch();

  Future<int> insertTemplate(
    TransactionTemplatesCompanion template, {
    InsertMode mode = InsertMode.insertOrReplace,
  }) => into(transactionTemplates).insert(template, mode: mode);

  Future<bool> updateTemplate(TransactionTemplatesCompanion template) =>
      update(transactionTemplates).replace(template);

  Future<int> softDeleteTemplate(String id, DateTime deletedAt) =>
      (update(transactionTemplates)..where((t) => t.id.equals(id))).write(
        TransactionTemplatesCompanion(
          deletedAt: Value(deletedAt),
          updatedAt: Value(deletedAt),
        ),
      );

  Future<int> hardDeleteTemplate(String id) =>
      (delete(transactionTemplates)..where((t) => t.id.equals(id))).go();
}
