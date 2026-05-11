// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
  id: json['id'] as String,
  budgetId: json['budgetId'] as String,
  type: json['type'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  envelopeId: json['envelopeId'] as String?,
  accountId: json['accountId'] as String?,
  targetAmount: (json['targetAmount'] as num?)?.toInt(),
  targetDate: json['targetDate'] == null
      ? null
      : DateTime.parse(json['targetDate'] as String),
  monthlyContribution: (json['monthlyContribution'] as num?)?.toInt(),
  currentAmount: (json['currentAmount'] as num?)?.toInt() ?? 0,
  isCompleted: json['isCompleted'] as bool? ?? false,
  aprBps: (json['aprBps'] as num?)?.toInt(),
  minPaymentCents: (json['minPaymentCents'] as num?)?.toInt(),
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
  'id': instance.id,
  'budgetId': instance.budgetId,
  'type': instance.type,
  'name': instance.name,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'envelopeId': instance.envelopeId,
  'accountId': instance.accountId,
  'targetAmount': instance.targetAmount,
  'targetDate': instance.targetDate?.toIso8601String(),
  'monthlyContribution': instance.monthlyContribution,
  'currentAmount': instance.currentAmount,
  'isCompleted': instance.isCompleted,
  'aprBps': instance.aprBps,
  'minPaymentCents': instance.minPaymentCents,
  'sortOrder': instance.sortOrder,
};
