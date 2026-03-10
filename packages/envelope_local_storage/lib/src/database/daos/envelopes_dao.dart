import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'envelopes_dao.g.dart';

@DriftAccessor(
  tables: [
    CategoryGroups,
    Envelopes,
    EnvelopeAllocations,
    AllocationTemplates,
    AllocationTemplateItems,
  ],
)
class EnvelopesDao extends DatabaseAccessor<AppDatabase>
    with _$EnvelopesDaoMixin {
  EnvelopesDao(super.attachedDatabase);

  // Category Groups CRUD
  Future<List<CategoryGroup>> getAllCategoryGroups() =>
      select(categoryGroups).get();

  Future<List<CategoryGroup>> getCategoryGroupsByBudgetId(String budgetId) =>
      (select(categoryGroups)..where((t) => t.budgetId.equals(budgetId)))
          .get();

  Stream<List<CategoryGroup>> watchCategoryGroupsByBudgetId(String budgetId) =>
      (select(categoryGroups)..where((t) => t.budgetId.equals(budgetId)))
          .watch();

  Future<int> insertCategoryGroup(CategoryGroupsCompanion group) =>
      into(categoryGroups).insert(group);

  Future<bool> updateCategoryGroup(CategoryGroupsCompanion group) =>
      update(categoryGroups).replace(group);

  Future<int> deleteCategoryGroup(String id) =>
      (delete(categoryGroups)..where((t) => t.id.equals(id))).go();

  // Envelopes CRUD
  Future<List<Envelope>> getAllEnvelopes() => select(envelopes).get();

  Future<List<Envelope>> getEnvelopesByBudgetId(String budgetId) =>
      (select(envelopes)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<Envelope>> watchEnvelopesByBudgetId(String budgetId) =>
      (select(envelopes)..where((t) => t.budgetId.equals(budgetId))).watch();

  Future<List<Envelope>> getEnvelopesByCategoryGroupId(
    String categoryGroupId,
  ) =>
      (select(envelopes)
            ..where((t) => t.categoryGroupId.equals(categoryGroupId)))
          .get();

  Stream<List<Envelope>> watchEnvelopesByCategoryGroupId(
    String categoryGroupId,
  ) =>
      (select(envelopes)
            ..where((t) => t.categoryGroupId.equals(categoryGroupId)))
          .watch();

  Future<Envelope?> getEnvelope(String id) =>
      (select(envelopes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertEnvelope(EnvelopesCompanion envelope) =>
      into(envelopes).insert(envelope);

  Future<bool> updateEnvelope(EnvelopesCompanion envelope) =>
      update(envelopes).replace(envelope);

  Future<int> deleteEnvelope(String id) =>
      (delete(envelopes)..where((t) => t.id.equals(id))).go();

  // Envelope Allocations CRUD
  Future<List<EnvelopeAllocation>> getAllocationsByEnvelopeId(
    String envelopeId,
  ) =>
      (select(envelopeAllocations)
            ..where((t) => t.envelopeId.equals(envelopeId)))
          .get();

  Future<List<EnvelopeAllocation>> getAllocationsByPeriodId(
    String budgetPeriodId,
  ) =>
      (select(envelopeAllocations)
            ..where((t) => t.budgetPeriodId.equals(budgetPeriodId)))
          .get();

  Stream<List<EnvelopeAllocation>> watchAllocationsByPeriodId(
    String budgetPeriodId,
  ) =>
      (select(envelopeAllocations)
            ..where((t) => t.budgetPeriodId.equals(budgetPeriodId)))
          .watch();

  Future<int> insertAllocation(EnvelopeAllocationsCompanion allocation) =>
      into(envelopeAllocations).insert(allocation);

  Future<bool> updateAllocation(EnvelopeAllocationsCompanion allocation) =>
      update(envelopeAllocations).replace(allocation);

  Future<int> deleteAllocation(String id) =>
      (delete(envelopeAllocations)..where((t) => t.id.equals(id))).go();

  // Allocation Templates CRUD
  Future<List<AllocationTemplate>> getTemplatesByBudgetId(String budgetId) =>
      (select(allocationTemplates)
            ..where((t) => t.budgetId.equals(budgetId)))
          .get();

  Stream<List<AllocationTemplate>> watchTemplatesByBudgetId(String budgetId) =>
      (select(allocationTemplates)
            ..where((t) => t.budgetId.equals(budgetId)))
          .watch();

  Future<int> insertTemplate(AllocationTemplatesCompanion template) =>
      into(allocationTemplates).insert(template);

  Future<bool> updateTemplate(AllocationTemplatesCompanion template) =>
      update(allocationTemplates).replace(template);

  Future<int> deleteTemplate(String id) =>
      (delete(allocationTemplates)..where((t) => t.id.equals(id))).go();

  // Allocation Template Items CRUD
  Future<List<AllocationTemplateItem>> getTemplateItemsByTemplateId(
    String templateId,
  ) =>
      (select(allocationTemplateItems)
            ..where((t) => t.templateId.equals(templateId)))
          .get();

  Future<int> insertTemplateItem(AllocationTemplateItemsCompanion item) =>
      into(allocationTemplateItems).insert(item);

  Future<bool> updateTemplateItem(AllocationTemplateItemsCompanion item) =>
      update(allocationTemplateItems).replace(item);

  Future<int> deleteTemplateItem(String id) =>
      (delete(allocationTemplateItems)..where((t) => t.id.equals(id))).go();

  Future<int> deleteTemplateItemsByTemplateId(String templateId) =>
      (delete(allocationTemplateItems)
            ..where((t) => t.templateId.equals(templateId)))
          .go();
}
