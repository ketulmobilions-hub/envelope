import 'package:envelope_api_client/src/exceptions.dart';
import 'package:envelope_api_client/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for goal-related operations.
class GoalsApiClient {
  /// Creates a [GoalsApiClient] with the given [SupabaseClient].
  const GoalsApiClient({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  /// Fetches a goal by [id].
  Future<GoalDto> getGoal(String id) async {
    try {
      final response = await _supabaseClient
          .from('goals')
          .select()
          .eq('id', id)
          .single();
      return GoalDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all goals for a budget.
  Future<List<GoalDto>> getGoalsByBudget(String budgetId) async {
    try {
      final response = await _supabaseClient
          .from('goals')
          .select()
          .eq('budget_id', budgetId);
      return response.map(GoalDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new goal.
  Future<GoalDto> createGoal(GoalDto goal) async {
    try {
      final json = goal.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('updated_at');
      final response = await _supabaseClient
          .from('goals')
          .insert(json)
          .select()
          .single();
      return GoalDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing goal.
  Future<GoalDto> updateGoal(GoalDto goal) async {
    try {
      final response = await _supabaseClient
          .from('goals')
          .update(goal.toJson())
          .eq('id', goal.id)
          .select()
          .single();
      return GoalDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a goal by [id].
  Future<void> deleteGoal(String id) async {
    try {
      await _supabaseClient.from('goals').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new goal contribution.
  Future<GoalContributionDto> createContribution(
    GoalContributionDto contribution,
  ) async {
    try {
      final json = contribution.toJson()
        ..remove('id')
        ..remove('created_at');
      final response = await _supabaseClient
          .from('goal_contributions')
          .insert(json)
          .select()
          .single();
      return GoalContributionDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all contributions for a goal, newest first.
  Future<List<GoalContributionDto>> getContributionsByGoal(
    String goalId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('goal_contributions')
          .select()
          .eq('goal_id', goalId)
          .order('created_at', ascending: false);
      return response.map(GoalContributionDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a goal contribution by [id].
  Future<void> deleteContribution(String id) async {
    try {
      await _supabaseClient
          .from('goal_contributions')
          .delete()
          .eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }
}
