// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_contribution_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoalContributionDto _$GoalContributionDtoFromJson(Map<String, dynamic> json) =>
    _GoalContributionDto(
      id: json['id'] as String,
      goalId: json['goal_id'] as String,
      amountCents: (json['amount_cents'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$GoalContributionDtoToJson(
  _GoalContributionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'goal_id': instance.goalId,
  'amount_cents': instance.amountCents,
  'created_at': instance.createdAt.toIso8601String(),
  'note': instance.note,
};
