import 'package:envelope_api_client/src/exceptions.dart';
import 'package:envelope_api_client/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for recurring rule and bill reminder operations.
class RecurringApiClient {
  /// Creates a [RecurringApiClient] with the given [SupabaseClient].
  const RecurringApiClient({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  // --- Recurring Rules ---

  /// Fetches a recurring rule by [id].
  Future<RecurringRuleDto> getRecurringRule(String id) async {
    try {
      final response = await _supabaseClient
          .from('recurring_rules')
          .select()
          .eq('id', id)
          .single();
      return RecurringRuleDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all recurring rules for a budget.
  Future<List<RecurringRuleDto>> getRecurringRulesByBudget(
    String budgetId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('recurring_rules')
          .select()
          .eq('budget_id', budgetId);
      return response.map(RecurringRuleDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new recurring rule.
  Future<RecurringRuleDto> createRecurringRule(
    RecurringRuleDto rule,
  ) async {
    try {
      final response = await _supabaseClient
          .from('recurring_rules')
          .insert(rule.toJson())
          .select()
          .single();
      return RecurringRuleDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing recurring rule.
  Future<RecurringRuleDto> updateRecurringRule(
    RecurringRuleDto rule,
  ) async {
    try {
      final response = await _supabaseClient
          .from('recurring_rules')
          .update(rule.toJson())
          .eq('id', rule.id)
          .select()
          .single();
      return RecurringRuleDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a recurring rule by [id].
  Future<void> deleteRecurringRule(String id) async {
    try {
      await _supabaseClient.from('recurring_rules').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Bill Reminders ---

  /// Fetches a bill reminder by [id].
  Future<BillReminderDto> getBillReminder(String id) async {
    try {
      final response = await _supabaseClient
          .from('bill_reminders')
          .select()
          .eq('id', id)
          .single();
      return BillReminderDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all bill reminders for a budget.
  Future<List<BillReminderDto>> getBillRemindersByBudget(
    String budgetId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('bill_reminders')
          .select()
          .eq('budget_id', budgetId);
      return response.map(BillReminderDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new bill reminder.
  Future<BillReminderDto> createBillReminder(
    BillReminderDto reminder,
  ) async {
    try {
      final response = await _supabaseClient
          .from('bill_reminders')
          .insert(reminder.toJson())
          .select()
          .single();
      return BillReminderDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing bill reminder.
  Future<BillReminderDto> updateBillReminder(
    BillReminderDto reminder,
  ) async {
    try {
      final response = await _supabaseClient
          .from('bill_reminders')
          .update(reminder.toJson())
          .eq('id', reminder.id)
          .select()
          .single();
      return BillReminderDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a bill reminder by [id].
  Future<void> deleteBillReminder(String id) async {
    try {
      await _supabaseClient.from('bill_reminders').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }
}
