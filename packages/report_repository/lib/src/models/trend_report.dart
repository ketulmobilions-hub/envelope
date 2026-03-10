import 'package:freezed_annotation/freezed_annotation.dart';

part 'trend_report.freezed.dart';
part 'trend_report.g.dart';

@freezed
abstract class TrendReport with _$TrendReport {
  const factory TrendReport({
    required List<TrendDataPoint> dataPoints,
  }) = _TrendReport;

  factory TrendReport.fromJson(Map<String, dynamic> json) =>
      _$TrendReportFromJson(json);
}

@freezed
abstract class TrendDataPoint with _$TrendDataPoint {
  const factory TrendDataPoint({
    required DateTime date,
    required int income,
    required int spending,
    required int netSavings,
  }) = _TrendDataPoint;

  factory TrendDataPoint.fromJson(Map<String, dynamic> json) =>
      _$TrendDataPointFromJson(json);
}
