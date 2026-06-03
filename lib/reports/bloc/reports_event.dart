part of 'reports_bloc.dart';

sealed class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize the reports feature — loads budget periods for selectors.
final class ReportsStarted extends ReportsEvent {
  const ReportsStarted();
}

/// Request a spending report for the given date range.
final class SpendingReportRequested extends ReportsEvent {
  const SpendingReportRequested({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Request a trend report for the given number of months.
final class TrendReportRequested extends ReportsEvent {
  const TrendReportRequested({required this.months});

  final int months;

  @override
  List<Object?> get props => [months];
}

/// Request a budget vs actual report for the given period.
final class BudgetVsActualReportRequested extends ReportsEvent {
  const BudgetVsActualReportRequested({required this.periodId});

  final String periodId;

  @override
  List<Object?> get props => [periodId];
}

/// Request the net worth history.
final class NetWorthReportRequested extends ReportsEvent {
  const NetWorthReportRequested();
}

/// Record a new net worth snapshot.
final class NetWorthSnapshotRequested extends ReportsEvent {
  const NetWorthSnapshotRequested();
}

/// Change the selected export report type.
final class ExportReportTypeChanged extends ReportsEvent {
  const ExportReportTypeChanged({required this.reportType});

  final ReportType reportType;

  @override
  List<Object?> get props => [reportType];
}

/// Change the selected export format.
final class ExportFormatChanged extends ReportsEvent {
  const ExportFormatChanged({required this.format});

  final ExportFormat format;

  @override
  List<Object?> get props => [format];
}

/// Export a report to CSV or PDF.
final class ReportsExportRequested extends ReportsEvent {
  const ReportsExportRequested({
    required this.format,
    required this.reportType,
  });

  final ExportFormat format;
  final ReportType reportType;

  @override
  List<Object?> get props => [format, reportType];
}

/// Internal event when budget periods stream emits.
final class _PeriodsUpdated extends ReportsEvent {
  const _PeriodsUpdated(this.periods);

  final List<BudgetPeriod> periods;

  @override
  List<Object?> get props => [periods];
}

/// Share an exported file.
final class ReportsShareRequested extends ReportsEvent {
  const ReportsShareRequested({required this.filePath});

  final String filePath;

  @override
  List<Object?> get props => [filePath];
}
