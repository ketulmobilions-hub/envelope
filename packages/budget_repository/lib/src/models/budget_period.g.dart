// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetPeriod _$BudgetPeriodFromJson(Map<String, dynamic> json) =>
    _BudgetPeriod(
      id: json['id'] as String,
      budgetId: json['budgetId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalIncome: (json['totalIncome'] as num?)?.toInt() ?? 0,
      totalAllocated: (json['totalAllocated'] as num?)?.toInt() ?? 0,
      isClosed: json['isClosed'] as bool? ?? false,
    );

Map<String, dynamic> _$BudgetPeriodToJson(_BudgetPeriod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'totalIncome': instance.totalIncome,
      'totalAllocated': instance.totalAllocated,
      'isClosed': instance.isClosed,
    };
