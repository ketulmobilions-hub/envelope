// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetMember _$BudgetMemberFromJson(Map<String, dynamic> json) =>
    _BudgetMember(
      id: json['id'] as String,
      budgetId: json['budgetId'] as String,
      userId: json['userId'] as String?,
      invitedVia: json['invitedVia'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      role: json['role'] as String? ?? 'viewer',
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
    );

Map<String, dynamic> _$BudgetMemberToJson(_BudgetMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'userId': instance.userId,
      'invitedVia': instance.invitedVia,
      'createdAt': instance.createdAt.toIso8601String(),
      'role': instance.role,
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
    };
