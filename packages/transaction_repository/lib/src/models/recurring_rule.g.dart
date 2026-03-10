// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringRule _$RecurringRuleFromJson(Map<String, dynamic> json) =>
    _RecurringRule(
      id: json['id'] as String,
      budgetId: json['budgetId'] as String,
      accountId: json['accountId'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      frequency: json['frequency'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      nextOccurrence: DateTime.parse(json['nextOccurrence'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      envelopeId: json['envelopeId'] as String?,
      payee: json['payee'] as String?,
      notes: json['notes'] as String?,
      customInterval: (json['customInterval'] as num?)?.toInt(),
      customUnit: json['customUnit'] as String?,
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      autoPost: json['autoPost'] as bool? ?? false,
      isPaused: json['isPaused'] as bool? ?? false,
    );

Map<String, dynamic> _$RecurringRuleToJson(_RecurringRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'accountId': instance.accountId,
      'type': instance.type,
      'amount': instance.amount,
      'currency': instance.currency,
      'frequency': instance.frequency,
      'startDate': instance.startDate.toIso8601String(),
      'nextOccurrence': instance.nextOccurrence.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'envelopeId': instance.envelopeId,
      'payee': instance.payee,
      'notes': instance.notes,
      'customInterval': instance.customInterval,
      'customUnit': instance.customUnit,
      'endDate': instance.endDate?.toIso8601String(),
      'autoPost': instance.autoPost,
      'isPaused': instance.isPaused,
    };
