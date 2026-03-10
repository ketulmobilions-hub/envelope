// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountDto _$AccountDtoFromJson(Map<String, dynamic> json) => _AccountDto(
  id: json['id'] as String,
  budgetId: json['budget_id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  currency: json['currency'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  startingBalance: (json['starting_balance'] as num?)?.toInt() ?? 0,
  currentBalance: (json['current_balance'] as num?)?.toInt() ?? 0,
  isArchived: json['is_archived'] as bool? ?? false,
);

Map<String, dynamic> _$AccountDtoToJson(_AccountDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'name': instance.name,
      'type': instance.type,
      'currency': instance.currency,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'starting_balance': instance.startingBalance,
      'current_balance': instance.currentBalance,
      'is_archived': instance.isArchived,
    };
