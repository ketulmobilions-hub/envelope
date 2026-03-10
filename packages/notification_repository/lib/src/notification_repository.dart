// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart'
    hide NotificationPreferences;
import 'package:notification_repository/src/models/models.dart';

/// Repository for notification preferences and push tokens.
class NotificationRepository {
  const NotificationRepository({
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;

  /// Gets notification preferences for a user.
  Future<NotificationPreferences> getPreferences(String userId) async {
    // TODO(envelope): Implement get preferences
    throw UnimplementedError();
  }

  /// Updates notification preferences.
  Future<void> updatePreferences(
    NotificationPreferences preferences,
  ) async {
    // TODO(envelope): Implement update preferences
    throw UnimplementedError();
  }

  /// Registers a push notification token.
  Future<void> registerPushToken(String token) async {
    // TODO(envelope): Implement register push token
    throw UnimplementedError();
  }

  /// Unregisters a push notification token.
  Future<void> unregisterPushToken(String token) async {
    // TODO(envelope): Implement unregister push token
    throw UnimplementedError();
  }
}
