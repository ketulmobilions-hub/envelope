// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' hide Goal;
import 'package:goal_repository/goal_repository.dart';

/// Repository for goal operations.
class GoalRepository {
  const GoalRepository({
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;

  /// Creates a new goal.
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
    // TODO(envelope): implement createGoal
    throw UnimplementedError();
  }

  /// Returns a goal by its [id].
  Future<Goal> getGoal(String id) async {
    // TODO(envelope): implement getGoal
    throw UnimplementedError();
  }

  /// Watches all goals for a [budgetId].
  Stream<List<Goal>> watchGoals(String budgetId) {
    // TODO(envelope): implement watchGoals
    throw UnimplementedError();
  }

  /// Updates a [goal].
  Future<void> updateGoal(Goal goal) async {
    // TODO(envelope): implement updateGoal
    throw UnimplementedError();
  }

  /// Deletes a goal by its [id].
  Future<void> deleteGoal(String id) async {
    // TODO(envelope): implement deleteGoal
    throw UnimplementedError();
  }

  /// Marks a goal as complete by its [id].
  Future<void> completeGoal(String id) async {
    // TODO(envelope): implement completeGoal
    throw UnimplementedError();
  }
}
