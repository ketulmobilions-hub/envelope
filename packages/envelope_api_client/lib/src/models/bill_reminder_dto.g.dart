// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_reminder_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillReminderDto _$BillReminderDtoFromJson(Map<String, dynamic> json) =>
    _BillReminderDto(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      name: json['name'] as String,
      estimatedAmount: (json['estimated_amount'] as num).toInt(),
      dueDay: (json['due_day'] as num).toInt(),
      frequency: json['frequency'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      reminderDaysBefore: (json['reminder_days_before'] as num?)?.toInt() ?? 3,
      envelopeId: json['envelope_id'] as String?,
    );

Map<String, dynamic> _$BillReminderDtoToJson(_BillReminderDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'name': instance.name,
      'estimated_amount': instance.estimatedAmount,
      'due_day': instance.dueDay,
      'frequency': instance.frequency,
      'created_at': instance.createdAt.toIso8601String(),
      'reminder_days_before': instance.reminderDaysBefore,
      'envelope_id': instance.envelopeId,
    };
