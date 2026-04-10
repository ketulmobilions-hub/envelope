// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_invite_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetInviteDto _$BudgetInviteDtoFromJson(Map<String, dynamic> json) =>
    _BudgetInviteDto(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      role: json['role'] as String? ?? 'viewer',
      createdBy: json['created_by'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      redeemedAt: json['redeemed_at'] == null
          ? null
          : DateTime.parse(json['redeemed_at'] as String),
      redeemedBy: json['redeemed_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BudgetInviteDtoToJson(_BudgetInviteDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'role': instance.role,
      'created_by': instance.createdBy,
      'expires_at': instance.expiresAt.toIso8601String(),
      'redeemed_at': instance.redeemedAt?.toIso8601String(),
      'redeemed_by': instance.redeemedBy,
      'created_at': instance.createdAt.toIso8601String(),
    };
