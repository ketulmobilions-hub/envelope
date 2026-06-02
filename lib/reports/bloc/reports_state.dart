part of 'reports_bloc.dart';

enum ReportsStatus { initial, loading, loaded, error }

enum ReportType { spending, trends, budgetVsActual, netWorth }

enum ExportFormat { csv, pdf }

enum ReportsError { loadFailed, exportFailed, snapshotFailed }

final class ReportsState extends Equatable {
  const ReportsState({
    this.status = ReportsStatus.initial,
    this.activeReport = ReportType.spending,
    this.error,
    this.spendingReport,
    this.trendReport,
    this.budgetVsActualReport,
    this.netWorthSnapshots = const [],
    this.startDate,
    this.endDate,
    this.trendMonths = 6,
    this.exportReportType = ReportType.spending,
    this.exportFormat = ExportFormat.csv,
    this.exportedFilePath,
  });

  final ReportsStatus status;
  final ReportType activeReport;
  final ReportsError? error;

  // Report data
  final SpendingReport? spendingReport;
  final TrendReport? trendReport;
  final BudgetVsActualReport? budgetVsActualReport;
  final List<NetWorthSnapshot> netWorthSnapshots;

  // Filter state — calendar date range (no period selector).
  final DateTime? startDate;
  final DateTime? endDate;
  final int trendMonths;

  // Export state
  final ReportType exportReportType;
  final ExportFormat exportFormat;
  final String? exportedFilePath;

  ReportsState copyWith({
    ReportsStatus? status,
    ReportType? activeReport,
    Object? error = _sentinel,
    Object? spendingReport = _sentinel,
    Object? trendReport = _sentinel,
    Object? budgetVsActualReport = _sentinel,
    List<NetWorthSnapshot>? netWorthSnapshots,
    Object? startDate = _sentinel,
    Object? endDate = _sentinel,
    int? trendMonths,
    ReportType? exportReportType,
    ExportFormat? exportFormat,
    Object? exportedFilePath = _sentinel,
  }) {
    return ReportsState(
      status: status ?? this.status,
      activeReport: activeReport ?? this.activeReport,
      error: error == _sentinel ? this.error : error as ReportsError?,
      spendingReport: spendingReport == _sentinel
          ? this.spendingReport
          : spendingReport as SpendingReport?,
      trendReport: trendReport == _sentinel
          ? this.trendReport
          : trendReport as TrendReport?,
      budgetVsActualReport: budgetVsActualReport == _sentinel
          ? this.budgetVsActualReport
          : budgetVsActualReport as BudgetVsActualReport?,
      netWorthSnapshots: netWorthSnapshots ?? this.netWorthSnapshots,
      startDate: startDate == _sentinel
          ? this.startDate
          : startDate as DateTime?,
      endDate: endDate == _sentinel ? this.endDate : endDate as DateTime?,
      trendMonths: trendMonths ?? this.trendMonths,
      exportReportType: exportReportType ?? this.exportReportType,
      exportFormat: exportFormat ?? this.exportFormat,
      exportedFilePath: exportedFilePath == _sentinel
          ? this.exportedFilePath
          : exportedFilePath as String?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [
    status,
    activeReport,
    error,
    spendingReport,
    trendReport,
    budgetVsActualReport,
    netWorthSnapshots,
    startDate,
    endDate,
    trendMonths,
    exportReportType,
    exportFormat,
    exportedFilePath,
  ];
}
