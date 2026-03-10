// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillReminder _$BillReminderFromJson(Map<String, dynamic> json) =>
    _BillReminder(
      id: json['id'] as String,
      budgetId: json['budgetId'] as String,
      name: json['name'] as String,
      estimatedAmount: (json['estimatedAmount'] as num).toInt(),
      dueDay: (json['dueDay'] as num).toInt(),
      frequency: json['frequency'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      envelopeId: json['envelopeId'] as String?,
      reminderDaysBefore: (json['reminderDaysBefore'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$BillReminderToJson(_BillReminder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'name': instance.name,
      'estimatedAmount': instance.estimatedAmount,
      'dueDay': instance.dueDay,
      'frequency': instance.frequency,
      'createdAt': instance.createdAt.toIso8601String(),
      'envelopeId': instance.envelopeId,
      'reminderDaysBefore': instance.reminderDaysBefore,
    };
