// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetDto _$BudgetDtoFromJson(Map<String, dynamic> json) => _BudgetDto(
  id: json['id'] as String,
  ownerId: json['owner_id'] as String,
  name: json['name'] as String,
  baseCurrency: json['base_currency'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  periodType: json['period_type'] as String? ?? 'monthly',
  periodStartDay: (json['period_start_day'] as num?)?.toInt() ?? 1,
  isArchived: json['is_archived'] as bool? ?? false,
  openingBalance: (json['opening_balance'] as num?)?.toInt() ?? 0,
  openingDate: json['opening_date'] == null
      ? null
      : DateTime.parse(json['opening_date'] as String),
);

Map<String, dynamic> _$BudgetDtoToJson(_BudgetDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'base_currency': instance.baseCurrency,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'period_type': instance.periodType,
      'period_start_day': instance.periodStartDay,
      'is_archived': instance.isArchived,
      'opening_balance': instance.openingBalance,
      'opening_date': instance.openingDate?.toIso8601String(),
    };
