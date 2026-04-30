import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'budgets_dao.g.dart';

@DriftAccessor(tables: [Budgets, BudgetMembers, BudgetPeriods])
class BudgetsDao extends DatabaseAccessor<AppDatabase> with _$BudgetsDaoMixin {
  BudgetsDao(super.attachedDatabase);

  // Budgets CRUD
  Future<List<Budget>> getAllBudgets() => select(budgets).get();

  Stream<List<Budget>> watchAllBudgets() => select(budgets).watch();

  Future<Budget?> getBudget(String id) =>
      (select(budgets)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<Budget> watchBudget(String id) =>
      (select(budgets)..where((t) => t.id.equals(id))).watchSingle();

  Future<List<Budget>> getBudgetsByOwnerId(String ownerId) =>
      (select(budgets)..where((t) => t.ownerId.equals(ownerId))).get();

  Stream<List<Budget>> watchBudgetsByOwnerId(String ownerId) =>
      (select(budgets)..where((t) => t.ownerId.equals(ownerId))).watch();

  Future<int> insertBudget(
    BudgetsCompanion budget, {
    InsertMode mode = InsertMode.insert,
  }) => into(budgets).insert(budget, mode: mode);

  Future<void> batchInsertBudgets(
    List<BudgetsCompanion> entries, {
    InsertMode mode = InsertMode.insert,
  }) async {
    await batch((b) {
      b.insertAll(budgets, entries, mode: mode);
    });
  }

  Future<bool> updateBudget(BudgetsCompanion budget) =>
      update(budgets).replace(budget);

  Future<int> deleteBudget(String id) =>
      (delete(budgets)..where((t) => t.id.equals(id))).go();

  // Budget Members CRUD
  Future<BudgetMember?> getBudgetMember(String id) =>
      (select(budgetMembers)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<BudgetMember>> getMembersByBudgetId(String budgetId) =>
      (select(budgetMembers)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<BudgetMember>> watchMembersByBudgetId(String budgetId) => (select(
    budgetMembers,
  )..where((t) => t.budgetId.equals(budgetId))).watch();

  Future<int> insertBudgetMember(
    BudgetMembersCompanion member, {
    InsertMode mode = InsertMode.insert,
  }) => into(budgetMembers).insert(member, mode: mode);

  Future<void> batchInsertBudgetMembers(
    List<BudgetMembersCompanion> entries, {
    InsertMode mode = InsertMode.insert,
  }) async {
    await batch((b) {
      b.insertAll(budgetMembers, entries, mode: mode);
    });
  }

  Future<bool> updateBudgetMember(BudgetMembersCompanion member) =>
      update(budgetMembers).replace(member);

  Future<int> deleteBudgetMember(String id) =>
      (delete(budgetMembers)..where((t) => t.id.equals(id))).go();

  // Budget Periods CRUD
  Future<List<BudgetPeriod>> getPeriodsByBudgetId(String budgetId) =>
      (select(budgetPeriods)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<BudgetPeriod>> watchPeriodsByBudgetId(String budgetId) => (select(
    budgetPeriods,
  )..where((t) => t.budgetId.equals(budgetId))).watch();

  Future<BudgetPeriod?> getBudgetPeriod(String id) =>
      (select(budgetPeriods)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertBudgetPeriod(
    BudgetPeriodsCompanion period, {
    InsertMode mode = InsertMode.insert,
  }) => into(budgetPeriods).insert(period, mode: mode);

  Future<void> batchInsertBudgetPeriods(
    List<BudgetPeriodsCompanion> entries, {
    InsertMode mode = InsertMode.insert,
  }) async {
    await batch((b) {
      b.insertAll(budgetPeriods, entries, mode: mode);
    });
  }

  Future<bool> updateBudgetPeriod(BudgetPeriodsCompanion period) =>
      update(budgetPeriods).replace(period);

  Future<int> deleteBudgetPeriod(String id) =>
      (delete(budgetPeriods)..where((t) => t.id.equals(id))).go();
}
