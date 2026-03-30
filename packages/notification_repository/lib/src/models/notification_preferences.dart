import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences.freezed.dart';
part 'notification_preferences.g.dart';

@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    required String userId,
    @Default(true) bool pushEnabled,
    @Default(true) bool emailEnabled,
    @Default(true) bool overspendAlerts,
    @Default(true) bool billReminders,
    @Default(true) bool dailyLoggingReminder,
    @Default(true) bool recurringTransactionAlerts,
    @Default(true) bool sharedBudgetActivity,
    @Default(true) bool weeklySummary,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}
