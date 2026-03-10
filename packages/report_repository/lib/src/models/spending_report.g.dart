// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spending_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpendingReport _$SpendingReportFromJson(Map<String, dynamic> json) =>
    _SpendingReport(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalSpent: (json['totalSpent'] as num).toInt(),
      totalIncome: (json['totalIncome'] as num).toInt(),
      byCategory:
          (json['byCategory'] as List<dynamic>?)
              ?.map(
                (e) => SpendingByCategory.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <SpendingByCategory>[],
    );

Map<String, dynamic> _$SpendingReportToJson(_SpendingReport instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'totalSpent': instance.totalSpent,
      'totalIncome': instance.totalIncome,
      'byCategory': instance.byCategory,
    };

_SpendingByCategory _$SpendingByCategoryFromJson(Map<String, dynamic> json) =>
    _SpendingByCategory(
      categoryGroupId: json['categoryGroupId'] as String,
      categoryGroupName: json['categoryGroupName'] as String,
      amount: (json['amount'] as num).toInt(),
      envelopes:
          (json['envelopes'] as List<dynamic>?)
              ?.map(
                (e) => SpendingByEnvelope.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <SpendingByEnvelope>[],
    );

Map<String, dynamic> _$SpendingByCategoryToJson(_SpendingByCategory instance) =>
    <String, dynamic>{
      'categoryGroupId': instance.categoryGroupId,
      'categoryGroupName': instance.categoryGroupName,
      'amount': instance.amount,
      'envelopes': instance.envelopes,
    };

_SpendingByEnvelope _$SpendingByEnvelopeFromJson(Map<String, dynamic> json) =>
    _SpendingByEnvelope(
      envelopeId: json['envelopeId'] as String,
      envelopeName: json['envelopeName'] as String,
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$SpendingByEnvelopeToJson(_SpendingByEnvelope instance) =>
    <String, dynamic>{
      'envelopeId': instance.envelopeId,
      'envelopeName': instance.envelopeName,
      'amount': instance.amount,
    };
