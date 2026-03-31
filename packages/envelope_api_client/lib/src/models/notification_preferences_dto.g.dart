// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferencesDto _$NotificationPreferencesDtoFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferencesDto(
  userId: json['user_id'] as String,
  pushEnabled: json['push_enabled'] as bool? ?? true,
  emailEnabled: json['email_enabled'] as bool? ?? true,
  overspendAlerts: json['overspend_alerts'] as bool? ?? true,
  billReminders: json['bill_reminders'] as bool? ?? true,
  dailyLoggingReminder: json['daily_logging_reminder'] as bool? ?? true,
  recurringTransactionAlerts:
      json['recurring_transaction_alerts'] as bool? ?? true,
  sharedBudgetActivity: json['shared_budget_activity'] as bool? ?? true,
  weeklySummary: json['weekly_summary'] as bool? ?? true,
);

Map<String, dynamic> _$NotificationPreferencesDtoToJson(
  _NotificationPreferencesDto instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'push_enabled': instance.pushEnabled,
  'email_enabled': instance.emailEnabled,
  'overspend_alerts': instance.overspendAlerts,
  'bill_reminders': instance.billReminders,
  'daily_logging_reminder': instance.dailyLoggingReminder,
  'recurring_transaction_alerts': instance.recurringTransactionAlerts,
  'shared_budget_activity': instance.sharedBudgetActivity,
  'weekly_summary': instance.weeklySummary,
};
