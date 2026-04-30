import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:goal_repository/goal_repository.dart';

/// Repository for goal operations.
///
/// Uses a remote-first strategy: writes go to the Supabase API first,
/// then sync the result to the local Drift database. Reads stream from
/// local storage for reactive UI updates.
class GoalRepository {
  /// Creates a [GoalRepository].
  const GoalRepository({
    required EnvelopeApiClient apiClient,
    required storage.AppDatabase localDatabase,
  }) : _apiClient = apiClient,
       _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final storage.AppDatabase _localDatabase;

  /// Creates a new goal.
  ///
  /// Server-generated fields (id, timestamps) are handled by the API.
  Future<Goal> createGoal({
    required String budgetId,
    required String type,
    required String name,
    String? envelopeId,
    String? accountId,
    int? targetAmount,
    DateTime? targetDate,
    int? monthlyContribution,
  }) async {
    try {
      final dto = GoalDto(
        id: '',
        budgetId: budgetId,
        type: type,
        name: name,
        envelopeId: envelopeId,
        accountId: accountId,
        targetAmount: targetAmount,
        targetDate: targetDate,
        monthlyContribution: monthlyContribution,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await _apiClient.goals.createGoal(dto);
      await _cacheGoal(created);
      return _mapGoalFromDto(created);
    } on EnvelopeApiException catch (e) {
      throw GoalException('Failed to create goal', error: e);
    }
  }

  /// Returns a goal by its [id].
  ///
  /// Tries local storage first, falls back to the API.
  Future<Goal> getGoal(String id) async {
    try {
      final local = await _localDatabase.goalsDao.getGoal(id);
      if (local != null) {
        return _mapGoalFromLocal(local);
      }

      final remote = await _apiClient.goals.getGoal(id);
      await _cacheGoal(remote);
      return _mapGoalFromDto(remote);
    } on EnvelopeApiException catch (e) {
      throw GoalException('Failed to get goal', error: e);
    }
  }

  /// Watches all goals for a [budgetId].
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<Goal>> watchGoals(String budgetId) {
    return _localDatabase.goalsDao
        .watchGoalsByBudgetId(budgetId)
        .map((rows) => rows.map(_mapGoalFromLocal).toList())
        .handleError(
          (Object error) =>
              throw GoalException('Failed to watch goals', error: error),
        );
  }

  /// Updates a [goal].
  ///
  /// Sends the update to the API and syncs locally.
  Future<void> updateGoal(Goal goal) async {
    try {
      final dto = _mapGoalToDto(goal);
      final updated = await _apiClient.goals.updateGoal(dto);
      await _cacheGoal(updated);
    } on EnvelopeApiException catch (e) {
      throw GoalException('Failed to update goal', error: e);
    }
  }

  /// Deletes a goal by its [id].
  ///
  /// Removes from the API first. Local cache removal is best-effort.
  Future<void> deleteGoal(String id) async {
    try {
      await _apiClient.goals.deleteGoal(id);
    } on EnvelopeApiException catch (e) {
      throw GoalException('Failed to delete goal', error: e);
    }
    // Best-effort local cleanup — remote is already deleted.
    try {
      await _localDatabase.goalsDao.deleteContributionsByGoalId(id);
      await _localDatabase.goalsDao.deleteGoal(id);
    } on Exception {
      // Stale local entries will be cleaned up on next refresh.
    }
  }

  /// Marks a goal as complete by its [id].
  Future<void> completeGoal(String id) async {
    try {
      final goal = await getGoal(id);
      final completed = goal.copyWith(
        isCompleted: true,
        updatedAt: DateTime.now(),
      );
      await updateGoal(completed);
    } on GoalException {
      rethrow;
    } on Exception catch (e) {
      throw GoalException('Failed to complete goal', error: e);
    }
  }

  /// Marks a goal as incomplete by its [id].
  Future<void> uncompleteGoal(String id) async {
    try {
      final goal = await getGoal(id);
      final uncompleted = goal.copyWith(
        isCompleted: false,
        updatedAt: DateTime.now(),
      );
      await updateGoal(uncompleted);
    } on GoalException {
      rethrow;
    } on Exception catch (e) {
      throw GoalException('Failed to uncomplete goal', error: e);
    }
  }

  /// Adds a contribution toward a goal and updates [goal.currentAmount].
  Future<GoalContribution> addContribution({
    required String goalId,
    required int amountCents,
    String? note,
  }) async {
    try {
      final dto = GoalContributionDto(
        id: '',
        goalId: goalId,
        amountCents: amountCents,
        createdAt: DateTime.now(),
        note: note,
      );
      final created = await _apiClient.goals.createContribution(dto);
      await _localDatabase.goalsDao.insertContribution(
        _toContributionCompanion(created),
        mode: InsertMode.insertOrReplace,
      );
      // Update goal's currentAmount to reflect the new contribution.
      final goal = await getGoal(goalId);
      await updateGoal(
        goal.copyWith(currentAmount: goal.currentAmount + amountCents),
      );
      return _mapContributionFromDto(created);
    } on EnvelopeApiException catch (e) {
      throw GoalException('Failed to add contribution', error: e);
    }
  }

  /// Removes a contribution and decrements [goal.currentAmount].
  Future<void> removeContribution(GoalContribution contribution) async {
    try {
      await _apiClient.goals.deleteContribution(contribution.id);
    } on EnvelopeApiException catch (e) {
      throw GoalException('Failed to delete contribution', error: e);
    }
    // Best-effort local cleanup.
    try {
      await _localDatabase.goalsDao.deleteContribution(contribution.id);
      final goal = await getGoal(contribution.goalId);
      await updateGoal(
        goal.copyWith(
          currentAmount: (goal.currentAmount - contribution.amountCents).clamp(
            0,
            999999999,
          ),
        ),
      );
    } on Exception {
      // Local state will reconcile on next refresh.
    }
  }

  /// Watches contributions for a goal from local storage, newest first.
  Stream<List<GoalContribution>> watchContributions(String goalId) {
    return _localDatabase.goalsDao
        .watchContributionsByGoalId(goalId)
        .map((rows) => rows.map(_mapContributionFromLocal).toList())
        .handleError(
          (Object error) => throw GoalException(
            'Failed to watch contributions',
            error: error,
          ),
        );
  }

  /// Fetches contributions from the API and syncs them locally.
  Future<void> refreshContributions(String goalId) async {
    try {
      final remote = await _apiClient.goals.getContributionsByGoal(goalId);
      for (final dto in remote) {
        await _localDatabase.goalsDao.insertContribution(
          _toContributionCompanion(dto),
          mode: InsertMode.insertOrReplace,
        );
      }
    } on EnvelopeApiException catch (e) {
      throw GoalException('Failed to refresh contributions', error: e);
    }
  }

  /// Fetches goals from the API and syncs them to local storage.
  Future<void> refreshGoals(String budgetId) async {
    try {
      final remoteGoals = await _apiClient.goals.getGoalsByBudget(budgetId);
      final companions = remoteGoals.map(_toGoalCompanion).toList();
      await _localDatabase.goalsDao.batchInsertGoals(
        companions,
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw GoalException('Failed to refresh goals', error: e);
    }
  }

  // ---------------------------------------------------------------------------
  // Private — DTO ↔ Domain mapping
  // ---------------------------------------------------------------------------

  static Goal _mapGoalFromDto(GoalDto dto) {
    return Goal(
      id: dto.id,
      budgetId: dto.budgetId,
      type: dto.type,
      name: dto.name,
      envelopeId: dto.envelopeId,
      accountId: dto.accountId,
      targetAmount: dto.targetAmount,
      targetDate: dto.targetDate,
      monthlyContribution: dto.monthlyContribution,
      currentAmount: dto.currentAmount,
      isCompleted: dto.isCompleted,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static Goal _mapGoalFromLocal(storage.Goal row) {
    return Goal(
      id: row.id,
      budgetId: row.budgetId,
      type: row.type,
      name: row.name,
      envelopeId: row.envelopeId,
      accountId: row.accountId,
      targetAmount: row.targetAmount,
      targetDate: row.targetDate,
      monthlyContribution: row.monthlyContribution,
      currentAmount: row.currentAmount,
      isCompleted: row.isCompleted,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static GoalDto _mapGoalToDto(Goal goal) {
    return GoalDto(
      id: goal.id,
      budgetId: goal.budgetId,
      type: goal.type,
      name: goal.name,
      envelopeId: goal.envelopeId,
      accountId: goal.accountId,
      targetAmount: goal.targetAmount,
      targetDate: goal.targetDate,
      monthlyContribution: goal.monthlyContribution,
      currentAmount: goal.currentAmount,
      isCompleted: goal.isCompleted,
      createdAt: goal.createdAt,
      updatedAt: goal.updatedAt,
    );
  }

  // ---------------------------------------------------------------------------
  // Private — Local cache helpers
  // ---------------------------------------------------------------------------

  static storage.GoalsCompanion _toGoalCompanion(GoalDto dto) {
    return storage.GoalsCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      type: dto.type,
      name: dto.name,
      envelopeId: Value(dto.envelopeId),
      accountId: Value(dto.accountId),
      targetAmount: Value(dto.targetAmount),
      targetDate: Value(dto.targetDate),
      monthlyContribution: Value(dto.monthlyContribution),
      currentAmount: Value(dto.currentAmount),
      isCompleted: Value(dto.isCompleted),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  Future<void> _cacheGoal(GoalDto dto) async {
    await _localDatabase.goalsDao.insertGoal(
      _toGoalCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  static GoalContribution _mapContributionFromDto(GoalContributionDto dto) {
    return GoalContribution(
      id: dto.id,
      goalId: dto.goalId,
      amountCents: dto.amountCents,
      createdAt: dto.createdAt,
      note: dto.note,
    );
  }

  static GoalContribution _mapContributionFromLocal(
    storage.GoalContribution row,
  ) {
    return GoalContribution(
      id: row.id,
      goalId: row.goalId,
      amountCents: row.amountCents,
      createdAt: row.createdAt,
      note: row.note,
    );
  }

  static storage.GoalContributionsCompanion _toContributionCompanion(
    GoalContributionDto dto,
  ) {
    return storage.GoalContributionsCompanion.insert(
      id: dto.id,
      goalId: dto.goalId,
      amountCents: dto.amountCents,
      createdAt: dto.createdAt,
      note: Value(dto.note),
    );
  }
}
