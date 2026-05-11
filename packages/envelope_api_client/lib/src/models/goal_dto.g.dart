// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoalDto _$GoalDtoFromJson(Map<String, dynamic> json) => _GoalDto(
  id: json['id'] as String,
  budgetId: json['budget_id'] as String,
  type: json['type'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  currentAmount: (json['current_amount'] as num?)?.toInt() ?? 0,
  isCompleted: json['is_completed'] as bool? ?? false,
  envelopeId: json['envelope_id'] as String?,
  accountId: json['account_id'] as String?,
  targetAmount: (json['target_amount'] as num?)?.toInt(),
  targetDate: json['target_date'] == null
      ? null
      : DateTime.parse(json['target_date'] as String),
  monthlyContribution: (json['monthly_contribution'] as num?)?.toInt(),
  aprBps: (json['apr_bps'] as num?)?.toInt(),
  minPaymentCents: (json['min_payment_cents'] as num?)?.toInt(),
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GoalDtoToJson(_GoalDto instance) => <String, dynamic>{
  'id': instance.id,
  'budget_id': instance.budgetId,
  'type': instance.type,
  'name': instance.name,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'current_amount': instance.currentAmount,
  'is_completed': instance.isCompleted,
  'envelope_id': instance.envelopeId,
  'account_id': instance.accountId,
  'target_amount': instance.targetAmount,
  'target_date': instance.targetDate?.toIso8601String(),
  'monthly_contribution': instance.monthlyContribution,
  'apr_bps': instance.aprBps,
  'min_payment_cents': instance.minPaymentCents,
  'sort_order': instance.sortOrder,
};
