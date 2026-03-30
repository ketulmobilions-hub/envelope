import 'package:drift/drift.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart'
    as local
    show AppDatabase, NotificationPreferencesCompanion, PushTokensCompanion;
import 'package:notification_repository/src/models/models.dart';

/// Repository for notification preferences and push tokens.
class NotificationRepository {
  const NotificationRepository({
    required EnvelopeApiClient apiClient,
    required local.AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final local.AppDatabase _localDatabase;

  /// Gets notification preferences for a user.
  Future<NotificationPreferences> getPreferences(String userId) async {
    try {
      final dto = await _apiClient.users.getNotificationPreferences(userId);
      final prefs = _mapDtoToDomain(dto);

      // Cache locally.
      await _localDatabase
          .into(_localDatabase.notificationPreferences)
          .insertOnConflictUpdate(
            local.NotificationPreferencesCompanion.insert(
              userId: prefs.userId,
              pushEnabled: Value(prefs.pushEnabled),
              emailEnabled: Value(prefs.emailEnabled),
              overspendAlerts: Value(prefs.overspendAlerts),
              billReminders: Value(prefs.billReminders),
              dailyLoggingReminder: Value(prefs.dailyLoggingReminder),
              recurringTransactionAlerts:
                  Value(prefs.recurringTransactionAlerts),
              sharedBudgetActivity: Value(prefs.sharedBudgetActivity),
              weeklySummary: Value(prefs.weeklySummary),
            ),
          );

      return prefs;
    } on Exception catch (_) {
      // Fallback to local cache.
      final row = await (_localDatabase.select(
        _localDatabase.notificationPreferences,
      )..where((t) => t.userId.equals(userId)))
          .getSingleOrNull();

      if (row == null) {
        throw NotificationPreferencesNotFoundException(userId);
      }

      return NotificationPreferences(
        userId: row.userId,
        pushEnabled: row.pushEnabled,
        emailEnabled: row.emailEnabled,
        overspendAlerts: row.overspendAlerts,
        billReminders: row.billReminders,
        dailyLoggingReminder: row.dailyLoggingReminder,
        recurringTransactionAlerts: row.recurringTransactionAlerts,
        sharedBudgetActivity: row.sharedBudgetActivity,
        weeklySummary: row.weeklySummary,
      );
    }
  }

  /// Updates notification preferences.
  Future<void> updatePreferences(
    NotificationPreferences preferences,
  ) async {
    final dto = NotificationPreferencesDto(
      userId: preferences.userId,
      pushEnabled: preferences.pushEnabled,
      emailEnabled: preferences.emailEnabled,
      overspendAlerts: preferences.overspendAlerts,
      billReminders: preferences.billReminders,
      dailyLoggingReminder: preferences.dailyLoggingReminder,
      recurringTransactionAlerts: preferences.recurringTransactionAlerts,
      sharedBudgetActivity: preferences.sharedBudgetActivity,
      weeklySummary: preferences.weeklySummary,
    );

    await _apiClient.users.updateNotificationPreferences(dto);

    // Update local cache.
    await (_localDatabase.update(_localDatabase.notificationPreferences)
          ..where((t) => t.userId.equals(preferences.userId)))
        .write(
      local.NotificationPreferencesCompanion(
        pushEnabled: Value(preferences.pushEnabled),
        emailEnabled: Value(preferences.emailEnabled),
        overspendAlerts: Value(preferences.overspendAlerts),
        billReminders: Value(preferences.billReminders),
        dailyLoggingReminder: Value(preferences.dailyLoggingReminder),
        recurringTransactionAlerts:
            Value(preferences.recurringTransactionAlerts),
        sharedBudgetActivity: Value(preferences.sharedBudgetActivity),
        weeklySummary: Value(preferences.weeklySummary),
      ),
    );
  }

  /// Registers a push notification token for a user.
  Future<void> registerPushToken({
    required String userId,
    required String token,
    required String platform,
  }) async {
    final now = DateTime.now();

    final dto = PushTokenDto(
      userId: userId,
      token: token,
      platform: platform,
      createdAt: now,
      updatedAt: now,
    );

    final result = await _apiClient.notifications.registerToken(dto);

    // Cache locally if server returned an ID.
    if (result.id == null) return;
    await _localDatabase
        .into(_localDatabase.pushTokens)
        .insertOnConflictUpdate(
          local.PushTokensCompanion.insert(
            id: result.id!,
            userId: result.userId,
            token: result.token,
            platform: result.platform,
            createdAt: result.createdAt,
            updatedAt: result.updatedAt,
          ),
        );
  }

  /// Unregisters a push notification token for a user.
  Future<void> unregisterPushToken({
    required String userId,
    required String token,
  }) async {
    await _apiClient.notifications.unregisterToken(userId, token);

    // Remove from local cache.
    await (_localDatabase.delete(_localDatabase.pushTokens)
          ..where(
            (t) => t.userId.equals(userId) & t.token.equals(token),
          ))
        .go();
  }

  NotificationPreferences _mapDtoToDomain(NotificationPreferencesDto dto) {
    return NotificationPreferences(
      userId: dto.userId,
      pushEnabled: dto.pushEnabled,
      emailEnabled: dto.emailEnabled,
      overspendAlerts: dto.overspendAlerts,
      billReminders: dto.billReminders,
      dailyLoggingReminder: dto.dailyLoggingReminder,
      recurringTransactionAlerts: dto.recurringTransactionAlerts,
      sharedBudgetActivity: dto.sharedBudgetActivity,
      weeklySummary: dto.weeklySummary,
    );
  }
}

/// Exception thrown when notification preferences are not found locally.
class NotificationPreferencesNotFoundException implements Exception {
  const NotificationPreferencesNotFoundException(this.userId);

  final String userId;

  @override
  String toString() =>
      'NotificationPreferencesNotFoundException: '
      'No cached preferences for user $userId';
}
