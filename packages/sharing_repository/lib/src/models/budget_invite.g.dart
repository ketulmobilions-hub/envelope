// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetInvite _$BudgetInviteFromJson(Map<String, dynamic> json) =>
    _BudgetInvite(
      id: json['id'] as String,
      budgetId: json['budgetId'] as String,
      role: json['role'] as String,
      createdBy: json['createdBy'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      redeemedAt: json['redeemedAt'] == null
          ? null
          : DateTime.parse(json['redeemedAt'] as String),
      redeemedBy: json['redeemedBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BudgetInviteToJson(_BudgetInvite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'role': instance.role,
      'createdBy': instance.createdBy,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'redeemedAt': instance.redeemedAt?.toIso8601String(),
      'redeemedBy': instance.redeemedBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };
