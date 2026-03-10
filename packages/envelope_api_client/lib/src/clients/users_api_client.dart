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

  /// Fetches notification preferences for a user.
  Future<NotificationPreferencesDto> getNotificationPreferences(
    String userId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('notification_preferences')
          .select()
          .eq('user_id', userId)
          .single();
      return NotificationPreferencesDto.fromJson(response);
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
