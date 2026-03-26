// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetMemberDto _$BudgetMemberDtoFromJson(Map<String, dynamic> json) =>
    _BudgetMemberDto(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      userId: json['user_id'] as String?,
      invitedVia: json['invited_via'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      role: json['role'] as String? ?? 'viewer',
      acceptedAt: json['accepted_at'] == null
          ? null
          : DateTime.parse(json['accepted_at'] as String),
    );

Map<String, dynamic> _$BudgetMemberDtoToJson(_BudgetMemberDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'user_id': instance.userId,
      'invited_via': instance.invitedVia,
      'created_at': instance.createdAt.toIso8601String(),
      'role': instance.role,
      'accepted_at': instance.acceptedAt?.toIso8601String(),
    };
