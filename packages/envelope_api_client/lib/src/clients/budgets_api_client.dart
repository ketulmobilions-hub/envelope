import 'package:envelope_api_client/src/exceptions.dart';
import 'package:envelope_api_client/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for budget-related operations.
class BudgetsApiClient {
  /// Creates a [BudgetsApiClient] with the given [SupabaseClient].
  const BudgetsApiClient({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  // --- Budgets ---

  /// Fetches a budget by [id].
  Future<BudgetDto> getBudget(String id) async {
    try {
      final response = await _supabaseClient
          .from('budgets')
          .select()
          .eq('id', id)
          .single();
      return BudgetDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all budgets owned by [ownerId].
  Future<List<BudgetDto>> getBudgetsByOwner(String ownerId) async {
    try {
      final response = await _supabaseClient
          .from('budgets')
          .select()
          .eq('owner_id', ownerId);
      return response.map(BudgetDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new budget.
  Future<BudgetDto> createBudget(BudgetDto budget) async {
    try {
      final json = budget.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('updated_at');
      final response = await _supabaseClient
          .from('budgets')
          .insert(json)
          .select()
          .single();
      return BudgetDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing budget.
  Future<BudgetDto> updateBudget(BudgetDto budget) async {
    try {
      final response = await _supabaseClient
          .from('budgets')
          .update(budget.toJson())
          .eq('id', budget.id)
          .select()
          .single();
      return BudgetDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a budget by [id].
  Future<void> deleteBudget(String id) async {
    try {
      await _supabaseClient.from('budgets').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Budget Members ---

  /// Fetches all members of a budget.
  Future<List<BudgetMemberDto>> getBudgetMembers(String budgetId) async {
    try {
      final response = await _supabaseClient
          .from('budget_members')
          .select()
          .eq('budget_id', budgetId);
      return response.map(BudgetMemberDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Adds a member to a budget.
  Future<BudgetMemberDto> addBudgetMember(BudgetMemberDto member) async {
    try {
      final json = member.toJson()
        ..remove('id')
        ..remove('created_at');
      final response = await _supabaseClient
          .from('budget_members')
          .insert(json)
          .select()
          .single();
      return BudgetMemberDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates a budget member.
  Future<BudgetMemberDto> updateBudgetMember(BudgetMemberDto member) async {
    try {
      final response = await _supabaseClient
          .from('budget_members')
          .update(member.toJson())
          .eq('id', member.id)
          .select()
          .single();
      return BudgetMemberDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Removes a budget member by [id].
  Future<void> removeBudgetMember(String id) async {
    try {
      await _supabaseClient.from('budget_members').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Invokes the `send-invite-email` Edge Function to send an invitation.
  Future<void> invokeSendInviteEmail({
    required String email,
    required String budgetName,
    required String inviterName,
    required String inviteId,
  }) async {
    try {
      await _supabaseClient.functions.invoke(
        'send-invite-email',
        body: {
          'email': email,
          'budgetName': budgetName,
          'inviterName': inviterName,
          'inviteId': inviteId,
        },
      );
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Budget Periods ---

  /// Fetches all periods for a budget.
  Future<List<BudgetPeriodDto>> getBudgetPeriods(String budgetId) async {
    try {
      final response = await _supabaseClient
          .from('budget_periods')
          .select()
          .eq('budget_id', budgetId);
      return response.map(BudgetPeriodDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new budget period.
  Future<BudgetPeriodDto> createBudgetPeriod(BudgetPeriodDto period) async {
    try {
      final json = period.toJson()
        ..remove('id')
        ..remove('created_at');
      final response = await _supabaseClient
          .from('budget_periods')
          .insert(json)
          .select()
          .single();
      return BudgetPeriodDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates a budget period.
  Future<BudgetPeriodDto> updateBudgetPeriod(BudgetPeriodDto period) async {
    try {
      final response = await _supabaseClient
          .from('budget_periods')
          .update(period.toJson())
          .eq('id', period.id)
          .select()
          .single();
      return BudgetPeriodDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Closes a budget period by setting `is_closed` to `true`.
  Future<BudgetPeriodDto> closeBudgetPeriod(String id) async {
    try {
      final response = await _supabaseClient
          .from('budget_periods')
          .update({'is_closed': true})
          .eq('id', id)
          .select()
          .single();
      return BudgetPeriodDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }
}
