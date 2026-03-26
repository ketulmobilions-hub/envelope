import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'goals_dao.g.dart';

@DriftAccessor(tables: [Goals])
class GoalsDao extends DatabaseAccessor<AppDatabase> with _$GoalsDaoMixin {
  GoalsDao(super.attachedDatabase);

  Future<List<Goal>> getAllGoals() => select(goals).get();

  Future<List<Goal>> getGoalsByBudgetId(String budgetId) =>
      (select(goals)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<Goal>> watchGoalsByBudgetId(String budgetId) =>
      (select(goals)..where((t) => t.budgetId.equals(budgetId))).watch();

  Future<Goal?> getGoal(String id) =>
      (select(goals)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<Goal> watchGoal(String id) =>
      (select(goals)..where((t) => t.id.equals(id))).watchSingle();

  Future<int> insertGoal(
    GoalsCompanion goal, {
    InsertMode mode = InsertMode.insert,
  }) =>
      into(goals).insert(goal, mode: mode);

  Future<void> batchInsertGoals(
    List<GoalsCompanion> entries, {
    InsertMode mode = InsertMode.insert,
  }) async {
    await batch((b) {
      b.insertAll(goals, entries, mode: mode);
    });
  }

  Future<bool> updateGoal(GoalsCompanion goal) => update(goals).replace(goal);

  Future<int> deleteGoal(String id) =>
      (delete(goals)..where((t) => t.id.equals(id))).go();
}
