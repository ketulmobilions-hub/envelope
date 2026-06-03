// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_period_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetPeriodDto _$BudgetPeriodDtoFromJson(Map<String, dynamic> json) =>
    _BudgetPeriodDto(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      totalIncome: (json['total_income'] as num?)?.toInt() ?? 0,
      totalAllocated: (json['total_allocated'] as num?)?.toInt() ?? 0,
      carriedRta: (json['carried_rta'] as num?)?.toInt() ?? 0,
      isClosed: json['is_closed'] as bool? ?? false,
    );

Map<String, dynamic> _$BudgetPeriodDtoToJson(_BudgetPeriodDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'total_income': instance.totalIncome,
      'total_allocated': instance.totalAllocated,
      'carried_rta': instance.carriedRta,
      'is_closed': instance.isClosed,
    };
