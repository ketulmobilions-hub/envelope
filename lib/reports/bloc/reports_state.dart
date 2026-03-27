part of 'reports_bloc.dart';

enum ReportsStatus { initial, loading, loaded, error }

enum ReportType { spending, trends, budgetVsActual, netWorth }

enum ExportFormat { csv, pdf }

enum ReportsError {
  loadFailed,
  exportFailed,
  snapshotFailed,
}

final class ReportsState extends Equatable {
  const ReportsState({
    this.status = ReportsStatus.initial,
    this.activeReport = ReportType.spending,
    this.error,
    this.budgetPeriods = const [],
    this.spendingReport,
    this.trendReport,
    this.budgetVsActualReport,
    this.netWorthSnapshots = const [],
    this.startDate,
    this.endDate,
    this.trendMonths = 6,
    this.selectedPeriodId,
    this.exportReportType = ReportType.spending,
    this.exportFormat = ExportFormat.csv,
    this.exportedFilePath,
  });

  final ReportsStatus status;
  final ReportType activeReport;
  final ReportsError? error;

  /// Available budget periods for the period selector.
  final List<BudgetPeriod> budgetPeriods;

  // Report data
  final SpendingReport? spendingReport;
  final TrendReport? trendReport;
  final BudgetVsActualReport? budgetVsActualReport;
  final List<NetWorthSnapshot> netWorthSnapshots;

  // Filter state
  final DateTime? startDate;
  final DateTime? endDate;
  final int trendMonths;
  final String? selectedPeriodId;

  // Export state
  final ReportType exportReportType;
  final ExportFormat exportFormat;
  final String? exportedFilePath;

  ReportsState copyWith({
    ReportsStatus? status,
    ReportType? activeReport,
    Object? error = _sentinel,
    List<BudgetPeriod>? budgetPeriods,
    Object? spendingReport = _sentinel,
    Object? trendReport = _sentinel,
    Object? budgetVsActualReport = _sentinel,
    List<NetWorthSnapshot>? netWorthSnapshots,
    Object? startDate = _sentinel,
    Object? endDate = _sentinel,
    int? trendMonths,
    Object? selectedPeriodId = _sentinel,
    ReportType? exportReportType,
    ExportFormat? exportFormat,
    Object? exportedFilePath = _sentinel,
  }) {
    return ReportsState(
      status: status ?? this.status,
      activeReport: activeReport ?? this.activeReport,
      error: error == _sentinel ? this.error : error as ReportsError?,
      budgetPeriods: budgetPeriods ?? this.budgetPeriods,
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
      startDate:
          startDate == _sentinel ? this.startDate : startDate as DateTime?,
      endDate: endDate == _sentinel ? this.endDate : endDate as DateTime?,
      trendMonths: trendMonths ?? this.trendMonths,
      selectedPeriodId: selectedPeriodId == _sentinel
          ? this.selectedPeriodId
          : selectedPeriodId as String?,
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
    budgetPeriods,
    spendingReport,
    trendReport,
    budgetVsActualReport,
    netWorthSnapshots,
    startDate,
    endDate,
    trendMonths,
    selectedPeriodId,
    exportReportType,
    exportFormat,
    exportedFilePath,
  ];
}
