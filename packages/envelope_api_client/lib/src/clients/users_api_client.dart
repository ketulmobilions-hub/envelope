import 'dart:convert';

import 'package:envelope_api_client/src/exceptions.dart';
import 'package:envelope_api_client/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for user-related operations.
class UsersApiClient {
  /// Creates a [UsersApiClient] with the given [SupabaseClient].
  const UsersApiClient({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  /// Fetches a user by [id].
  Future<UserDto> getUser(String id) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', id)
          .single();
      return UserDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new user.
  Future<UserDto> createUser(UserDto user) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .insert(user.toJson())
          .select()
          .single();
      return UserDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing user.
  Future<UserDto> updateUser(UserDto user) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .update(user.toJson())
          .eq('id', user.id)
          .select()
          .single();
      return UserDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a user by [id].
  Future<void> deleteUser(String id) async {
    try {
      await _supabaseClient.from('users').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Invokes the `delete-account` Edge Function to fully delete the
  /// user's data and auth account (GDPR-compliant deletion).
  Future<void> invokeDeleteAccount() async {
    try {
      final response = await _supabaseClient.functions.invoke(
        'delete-account',
      );
      if (response.status != 200) {
        throw EnvelopeApiException(
          'Account deletion failed: ${response.data}',
        );
      }
    } catch (error) {
      if (error is EnvelopeApiException) rethrow;
      throw EnvelopeApiException('Account deletion failed: $error');
    }
  }

  /// Fetches all user data for GDPR data portability export.
  /// Returns a JSON-encodable map of all user-associated data.
  Future<String> exportAllUserData(String userId) async {
    try {
      final user = await getUser(userId);

      // Fetch all budgets owned by user.
      final budgets = await _supabaseClient
          .from('budgets')
          .select()
          .eq('owner_id', userId);

      final budgetIds = (budgets as List)
          .map((b) => b['id'] as String)
          .toList();

      // Fetch data for all user's budgets.
      List<dynamic> accounts = [];
      List<dynamic> envelopes = [];
      List<dynamic> transactions = [];
      List<dynamic> periods = [];
      List<dynamic> allocations = [];
      List<dynamic> goals = [];
      List<dynamic> billReminders = [];
      List<dynamic> recurringRules = [];
      List<dynamic> activityLogs = [];

      if (budgetIds.isNotEmpty) {
        accounts = await _supabaseClient
            .from('accounts')
            .select()
            .inFilter('budget_id', budgetIds);
        envelopes = await _supabaseClient
            .from('envelopes')
            .select()
            .inFilter('budget_id', budgetIds);
        transactions = await _supabaseClient
            .from('transactions')
            .select()
            .inFilter('budget_id', budgetIds);
        periods = await _supabaseClient
            .from('budget_periods')
            .select()
            .inFilter('budget_id', budgetIds);
        goals = await _supabaseClient
            .from('goals')
            .select()
            .inFilter('budget_id', budgetIds);
        billReminders = await _supabaseClient
            .from('bill_reminders')
            .select()
            .inFilter('budget_id', budgetIds);
        recurringRules = await _supabaseClient
            .from('recurring_rules')
            .select()
            .inFilter('budget_id', budgetIds);
        activityLogs = await _supabaseClient
            .from('activity_log')
            .select()
            .inFilter('budget_id', budgetIds);

        final periodIds = (periods as List)
            .map((p) => p['id'] as String)
            .toList();
        if (periodIds.isNotEmpty) {
          allocations = await _supabaseClient
              .from('envelope_allocations')
              .select()
              .inFilter('budget_period_id', periodIds);
        }
      }

      // Fetch shared memberships.
      final memberships = await _supabaseClient
          .from('budget_members')
          .select()
          .eq('user_id', userId);

      // Fetch notification preferences.
      List<dynamic> notificationPrefs = [];
      try {
        final prefs = await _supabaseClient
            .from('notification_preferences')
            .select()
            .eq('user_id', userId);
        notificationPrefs = prefs;
      } catch (_) {
        // May not exist yet.
      }

      // Fetch email log.
      final emailLog = await _supabaseClient
          .from('email_log')
          .select()
          .eq('user_id', userId);

      final exportData = {
        'export_date': DateTime.now().toIso8601String(),
        'user': user.toJson(),
        'budgets': budgets,
        'budget_periods': periods,
        'accounts': accounts,
        'envelopes': envelopes,
        'envelope_allocations': allocations,
        'transactions': transactions,
        'goals': goals,
        'bill_reminders': billReminders,
        'recurring_rules': recurringRules,
        'budget_memberships': memberships,
        'activity_log': activityLogs,
        'notification_preferences': notificationPrefs,
        'email_log': emailLog,
      };

      return const JsonEncoder.withIndent('  ').convert(exportData);
    } catch (error) {
      if (error is EnvelopeApiException) rethrow;
      throw EnvelopeApiException('Failed to export user data: $error');
    }
  }

  /// Fetches notification preferences for a user, creating a default row
  /// if none exists yet.
  Future<NotificationPreferencesDto> getNotificationPreferences(
    String userId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('notification_preferences')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        return NotificationPreferencesDto.fromJson(response);
      }

      // First visit — insert a row with all defaults enabled.
      return createNotificationPreferences(
        NotificationPreferencesDto(userId: userId),
      );
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates notification preferences for a user.
  Future<NotificationPreferencesDto> createNotificationPreferences(
    NotificationPreferencesDto preferences,
  ) async {
    try {
      final response = await _supabaseClient
          .from('notification_preferences')
          .insert(preferences.toJson())
          .select()
          .single();
      return NotificationPreferencesDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates notification preferences for a user.
  Future<NotificationPreferencesDto> updateNotificationPreferences(
    NotificationPreferencesDto preferences,
  ) async {
    try {
      final response = await _supabaseClient
          .from('notification_preferences')
          .update(preferences.toJson())
          .eq('user_id', preferences.userId)
          .select()
          .single();
      return NotificationPreferencesDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }
}
