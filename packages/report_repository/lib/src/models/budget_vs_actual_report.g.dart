// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_vs_actual_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetVsActualReport _$BudgetVsActualReportFromJson(
  Map<String, dynamic> json,
) => _BudgetVsActualReport(
  budgetId: json['budgetId'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  totalAllocated: (json['totalAllocated'] as num).toInt(),
  totalSpent: (json['totalSpent'] as num).toInt(),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => BudgetVsActualItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BudgetVsActualItem>[],
);

Map<String, dynamic> _$BudgetVsActualReportToJson(
  _BudgetVsActualReport instance,
) => <String, dynamic>{
  'budgetId': instance.budgetId,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'totalAllocated': instance.totalAllocated,
  'totalSpent': instance.totalSpent,
  'items': instance.items,
};

_BudgetVsActualItem _$BudgetVsActualItemFromJson(Map<String, dynamic> json) =>
    _BudgetVsActualItem(
      envelopeId: json['envelopeId'] as String,
      envelopeName: json['envelopeName'] as String,
      categoryGroupName: json['categoryGroupName'] as String,
      allocated: (json['allocated'] as num).toInt(),
      spent: (json['spent'] as num).toInt(),
      remaining: (json['remaining'] as num).toInt(),
    );

Map<String, dynamic> _$BudgetVsActualItemToJson(_BudgetVsActualItem instance) =>
    <String, dynamic>{
      'envelopeId': instance.envelopeId,
      'envelopeName': instance.envelopeName,
      'categoryGroupName': instance.categoryGroupName,
      'allocated': instance.allocated,
      'spent': instance.spent,
      'remaining': instance.remaining,
    };
