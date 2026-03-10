// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferences(
  userId: json['userId'] as String,
  pushEnabled: json['pushEnabled'] as bool? ?? true,
  emailEnabled: json['emailEnabled'] as bool? ?? true,
  overspendAlerts: json['overspendAlerts'] as bool? ?? true,
  billReminders: json['billReminders'] as bool? ?? true,
  dailyLoggingReminder: json['dailyLoggingReminder'] as bool? ?? true,
  recurringTransactionAlerts:
      json['recurringTransactionAlerts'] as bool? ?? true,
  sharedBudgetActivity: json['sharedBudgetActivity'] as bool? ?? true,
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  _NotificationPreferences instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'pushEnabled': instance.pushEnabled,
  'emailEnabled': instance.emailEnabled,
  'overspendAlerts': instance.overspendAlerts,
  'billReminders': instance.billReminders,
  'dailyLoggingReminder': instance.dailyLoggingReminder,
  'recurringTransactionAlerts': instance.recurringTransactionAlerts,
  'sharedBudgetActivity': instance.sharedBudgetActivity,
};
