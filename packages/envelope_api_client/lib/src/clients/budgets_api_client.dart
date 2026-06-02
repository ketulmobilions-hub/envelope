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

  // --- Budget Invites ---

  /// Creates a new budget invite and returns the invite row.
  Future<BudgetInviteDto> createBudgetInvite({
    required String budgetId,
    required String role,
    required String createdBy,
  }) async {
    try {
      final response = await _supabaseClient
          .from('budget_invites')
          .insert({
            'budget_id': budgetId,
            'role': role,
            'created_by': createdBy,
          })
          .select()
          .single();
      return BudgetInviteDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches pending (non-redeemed, non-expired) invites for a budget.
  Future<List<BudgetInviteDto>> getBudgetInvites(String budgetId) async {
    try {
      final response = await _supabaseClient
          .from('budget_invites')
          .select()
          .eq('budget_id', budgetId)
          .isFilter('redeemed_at', null)
          .gte('expires_at', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);
      return (response as List)
          .map((e) => BudgetInviteDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes (revokes) a pending invite.
  Future<void> deleteBudgetInvite(String inviteId) async {
    try {
      await _supabaseClient.from('budget_invites').delete().eq('id', inviteId);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Invokes the `redeem-invite` Edge Function to redeem an invite.
  Future<Map<String, dynamic>> invokeRedeemInvite(String inviteId) async {
    try {
      final response = await _supabaseClient.functions.invoke(
        'redeem-invite',
        body: {'inviteId': inviteId},
      );
      if (response.status != 200) {
        final data = response.data as Map<String, dynamic>?;
        throw EnvelopeApiException(
          data?['error']?.toString() ?? 'Failed to redeem invite',
        );
      }
      return response.data as Map<String, dynamic>;
    } catch (error) {
      if (error is EnvelopeApiException) rethrow;
      throw EnvelopeApiException('Failed to redeem invite: $error');
    }
  }

}
