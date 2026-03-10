import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences_dto.freezed.dart';
part 'notification_preferences_dto.g.dart';

/// Data transfer object for the `notification_preferences` table.
@freezed
abstract class NotificationPreferencesDto with _$NotificationPreferencesDto {
  const factory NotificationPreferencesDto({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'push_enabled') @Default(true) bool pushEnabled,
    @JsonKey(name: 'email_enabled') @Default(true) bool emailEnabled,
    @JsonKey(name: 'overspend_alerts') @Default(true) bool overspendAlerts,
    @JsonKey(name: 'bill_reminders') @Default(true) bool billReminders,
    @JsonKey(name: 'daily_logging_reminder')
    @Default(true)
    bool dailyLoggingReminder,
    @JsonKey(name: 'recurring_transaction_alerts')
    @Default(true)
    bool recurringTransactionAlerts,
    @JsonKey(name: 'shared_budget_activity')
    @Default(true)
    bool sharedBudgetActivity,
  }) = _NotificationPreferencesDto;

  factory NotificationPreferencesDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesDtoFromJson(json);
}
