import 'package:envelope_api_client/src/exceptions.dart';
import 'package:envelope_api_client/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for push notification token operations.
class NotificationsApiClient {
  /// Creates a [NotificationsApiClient] with the given [SupabaseClient].
  const NotificationsApiClient({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  /// Registers (upserts) a push token for a user.
  Future<PushTokenDto> registerToken(PushTokenDto pushToken) async {
    try {
      final response = await _supabaseClient
          .from('push_tokens')
          .upsert(pushToken.toJson(), onConflict: 'user_id,token')
          .select()
          .single();
      return PushTokenDto.fromJson(response);
    } on PostgrestException catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Unregisters a push token for a user.
  Future<void> unregisterToken(String userId, String token) async {
    try {
      await _supabaseClient
          .from('push_tokens')
          .delete()
          .eq('user_id', userId)
          .eq('token', token);
    } on PostgrestException catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }
}
