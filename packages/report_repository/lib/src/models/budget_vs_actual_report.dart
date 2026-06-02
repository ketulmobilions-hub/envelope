import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_vs_actual_report.freezed.dart';
part 'budget_vs_actual_report.g.dart';

@freezed
abstract class BudgetVsActualReport with _$BudgetVsActualReport {
  const factory BudgetVsActualReport({
    required String budgetId,
    required DateTime startDate,
    required DateTime endDate,
    required int totalAllocated,
    required int totalSpent,
    @Default(<BudgetVsActualItem>[]) List<BudgetVsActualItem> items,
  }) = _BudgetVsActualReport;

  factory BudgetVsActualReport.fromJson(Map<String, dynamic> json) =>
      _$BudgetVsActualReportFromJson(json);
}

@freezed
abstract class BudgetVsActualItem with _$BudgetVsActualItem {
  const factory BudgetVsActualItem({
    required String envelopeId,
    required String envelopeName,
    required String categoryGroupName,
    required int allocated,
    required int spent,
    required int remaining,
  }) = _BudgetVsActualItem;

  factory BudgetVsActualItem.fromJson(Map<String, dynamic> json) =>
      _$BudgetVsActualItemFromJson(json);
}
