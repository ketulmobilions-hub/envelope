// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_rule_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringRuleDto _$RecurringRuleDtoFromJson(Map<String, dynamic> json) =>
    _RecurringRuleDto(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      accountId: json['account_id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      exchangeRate: (json['exchange_rate'] as num?)?.toDouble() ?? 1.0,
      frequency: json['frequency'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      nextOccurrence: DateTime.parse(json['next_occurrence'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      autoPost: json['auto_post'] as bool? ?? false,
      isPaused: json['is_paused'] as bool? ?? false,
      envelopeId: json['envelope_id'] as String?,
      payee: json['payee'] as String?,
      notes: json['notes'] as String?,
      customInterval: (json['custom_interval'] as num?)?.toInt(),
      customUnit: json['custom_unit'] as String?,
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$RecurringRuleDtoToJson(_RecurringRuleDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'account_id': instance.accountId,
      'type': instance.type,
      'amount': instance.amount,
      'currency': instance.currency,
      'exchange_rate': instance.exchangeRate,
      'frequency': instance.frequency,
      'start_date': instance.startDate.toIso8601String(),
      'next_occurrence': instance.nextOccurrence.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'auto_post': instance.autoPost,
      'is_paused': instance.isPaused,
      'envelope_id': instance.envelopeId,
      'payee': instance.payee,
      'notes': instance.notes,
      'custom_interval': instance.customInterval,
      'custom_unit': instance.customUnit,
      'end_date': instance.endDate?.toIso8601String(),
    };
