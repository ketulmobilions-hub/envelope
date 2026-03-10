import 'package:freezed_annotation/freezed_annotation.dart';

part 'spending_report.freezed.dart';
part 'spending_report.g.dart';

@freezed
abstract class SpendingReport with _$SpendingReport {
  const factory SpendingReport({
    required DateTime startDate,
    required DateTime endDate,
    required int totalSpent,
    required int totalIncome,
    @Default(<SpendingByCategory>[]) List<SpendingByCategory> byCategory,
  }) = _SpendingReport;

  factory SpendingReport.fromJson(Map<String, dynamic> json) =>
      _$SpendingReportFromJson(json);
}

@freezed
abstract class SpendingByCategory with _$SpendingByCategory {
  const factory SpendingByCategory({
    required String categoryGroupId,
    required String categoryGroupName,
    required int amount,
    @Default(<SpendingByEnvelope>[]) List<SpendingByEnvelope> envelopes,
  }) = _SpendingByCategory;

  factory SpendingByCategory.fromJson(Map<String, dynamic> json) =>
      _$SpendingByCategoryFromJson(json);
}

@freezed
abstract class SpendingByEnvelope with _$SpendingByEnvelope {
  const factory SpendingByEnvelope({
    required String envelopeId,
    required String envelopeName,
    required int amount,
  }) = _SpendingByEnvelope;

  factory SpendingByEnvelope.fromJson(Map<String, dynamic> json) =>
      _$SpendingByEnvelopeFromJson(json);
}
