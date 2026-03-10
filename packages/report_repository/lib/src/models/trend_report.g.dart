// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trend_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrendReport _$TrendReportFromJson(Map<String, dynamic> json) => _TrendReport(
  dataPoints: (json['dataPoints'] as List<dynamic>)
      .map((e) => TrendDataPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TrendReportToJson(_TrendReport instance) =>
    <String, dynamic>{'dataPoints': instance.dataPoints};

_TrendDataPoint _$TrendDataPointFromJson(Map<String, dynamic> json) =>
    _TrendDataPoint(
      date: DateTime.parse(json['date'] as String),
      income: (json['income'] as num).toInt(),
      spending: (json['spending'] as num).toInt(),
      netSavings: (json['netSavings'] as num).toInt(),
    );

Map<String, dynamic> _$TrendDataPointToJson(_TrendDataPoint instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'income': instance.income,
      'spending': instance.spending,
      'netSavings': instance.netSavings,
    };
