import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:report_repository/report_repository.dart';

part 'reports_event.dart';
part 'reports_state.dart';

/// Callback to write export data to a temporary file and return its path.
typedef ExportFileWriter = Future<String> Function({
  required String fileName,
  String? content,
  List<int>? bytes,
});

/// Callback to share a file via the platform share sheet.
typedef FileSharer = Future<void> Function(String filePath);

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc({
    required ReportRepository reportRepository,
    required BudgetRepository budgetRepository,
    required String budgetId,
    ExportFileWriter? exportFileWriter,
    FileSharer? fileSharer,
  })  : _reportRepository = reportRepository,
        _budgetRepository = budgetRepository,
        _budgetId = budgetId,
        _exportFileWriter = exportFileWriter,
        _fileSharer = fileSharer,
        super(const ReportsState()) {
    on<ReportsStarted>(_onStarted);
    on<_PeriodsUpdated>(_onPeriodsUpdated);
    on<SpendingReportRequested>(_onSpendingReportRequested);
    on<TrendReportRequested>(_onTrendReportRequested);
    on<BudgetVsActualReportRequested>(
      _onBudgetVsActualReportRequested,
    );
    on<NetWorthReportRequested>(_onNetWorthReportRequested);
    on<NetWorthSnapshotRequested>(_onNetWorthSnapshotRequested);
    on<ExportReportTypeChanged>(_onExportReportTypeChanged);
    on<ExportFormatChanged>(_onExportFormatChanged);
    on<ReportsExportRequested>(_onExportRequested);
    on<ReportsShareRequested>(_onShareRequested);
  }

  final ReportRepository _reportRepository;
  final BudgetRepository _budgetRepository;
  final String _budgetId;
  final ExportFileWriter? _exportFileWriter;
  final FileSharer? _fileSharer;

  StreamSubscription<List<BudgetPeriod>>? _periodsSubscription;

  Future<void> _onStarted(
    ReportsStarted event,
    Emitter<ReportsState> emit,
  ) async {
    emit(state.copyWith(status: ReportsStatus.loading));

    // Default date range: current month.
    final now = DateTime.now();
    final defaultStart = DateTime(now.year, now.month);
    final defaultEnd =
        DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    emit(
      state.copyWith(
        startDate: defaultStart,
        endDate: defaultEnd,
      ),
    );

    // Subscribe to budget periods stream for reactivity.
    await _periodsSubscription?.cancel();
    _periodsSubscription = _budgetRepository
        .watchBudgetPeriods(_budgetId)
        .listen(
          (periods) => add(_PeriodsUpdated(periods)),
          onError: (Object _) {
            add(const _PeriodsUpdated([]));
          },
        );
  }

  void _onPeriodsUpdated(
    _PeriodsUpdated event,
    Emitter<ReportsState> emit,
  ) {
    final sortedPeriods = [...event.periods]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    // Select the current period by default if none selected.
    var periodId = state.selectedPeriodId;
    if (periodId == null && sortedPeriods.isNotEmpty) {
      final now = DateTime.now();
      final currentPeriod = sortedPeriods
          .where(
            (p) =>
                !p.isClosed &&
                !p.startDate.isAfter(now) &&
                !p.endDate.isBefore(now),
          )
          .firstOrNull;
      periodId = currentPeriod?.id ?? sortedPeriods.first.id;
    }

    emit(
      state.copyWith(
        status: ReportsStatus.loaded,
        budgetPeriods: sortedPeriods,
        selectedPeriodId: periodId,
      ),
    );
  }

  Future<void> _onSpendingReportRequested(
    SpendingReportRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ReportsStatus.loading,
        activeReport: ReportType.spending,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    try {
      final report = await _reportRepository.getSpendingReport(
        budgetId: _budgetId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(
        state.copyWith(
          status: ReportsStatus.loaded,
          spendingReport: report,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ReportsStatus.error,
          error: ReportsError.loadFailed,
        ),
      );
      emit(state.copyWith(status: ReportsStatus.loaded, error: null));
    }
  }

  Future<void> _onTrendReportRequested(
    TrendReportRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ReportsStatus.loading,
        activeReport: ReportType.trends,
        trendMonths: event.months,
      ),
    );

    try {
      final report = await _reportRepository.getTrendReport(
        budgetId: _budgetId,
        months: event.months,
      );
      emit(
        state.copyWith(
          status: ReportsStatus.loaded,
          trendReport: report,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ReportsStatus.error,
          error: ReportsError.loadFailed,
        ),
      );
      emit(state.copyWith(status: ReportsStatus.loaded, error: null));
    }
  }

  Future<void> _onBudgetVsActualReportRequested(
    BudgetVsActualReportRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ReportsStatus.loading,
        activeReport: ReportType.budgetVsActual,
        selectedPeriodId: event.periodId,
      ),
    );

    try {
      final report = await _reportRepository.getBudgetVsActualReport(
        budgetPeriodId: event.periodId,
      );
      emit(
        state.copyWith(
          status: ReportsStatus.loaded,
          budgetVsActualReport: report,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ReportsStatus.error,
          error: ReportsError.loadFailed,
        ),
      );
      emit(state.copyWith(status: ReportsStatus.loaded, error: null));
    }
  }

  Future<void> _onNetWorthReportRequested(
    NetWorthReportRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ReportsStatus.loading,
        activeReport: ReportType.netWorth,
      ),
    );

    try {
      final snapshots =
          await _reportRepository.getNetWorthHistory(_budgetId);
      emit(
        state.copyWith(
          status: ReportsStatus.loaded,
          netWorthSnapshots: snapshots,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ReportsStatus.error,
          error: ReportsError.loadFailed,
        ),
      );
      emit(state.copyWith(status: ReportsStatus.loaded, error: null));
    }
  }

  Future<void> _onNetWorthSnapshotRequested(
    NetWorthSnapshotRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(state.copyWith(status: ReportsStatus.loading));
    try {
      await _reportRepository.recordNetWorthSnapshot(
        budgetId: _budgetId,
      );
      final snapshots =
          await _reportRepository.getNetWorthHistory(_budgetId);
      emit(
        state.copyWith(
          status: ReportsStatus.loaded,
          netWorthSnapshots: snapshots,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ReportsStatus.error,
          error: ReportsError.snapshotFailed,
        ),
      );
      emit(state.copyWith(status: ReportsStatus.loaded, error: null));
    }
  }

  void _onExportReportTypeChanged(
    ExportReportTypeChanged event,
    Emitter<ReportsState> emit,
  ) {
    emit(state.copyWith(exportReportType: event.reportType));
  }

  void _onExportFormatChanged(
    ExportFormatChanged event,
    Emitter<ReportsState> emit,
  ) {
    emit(state.copyWith(exportFormat: event.format));
  }

  Future<void> _onExportRequested(
    ReportsExportRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(state.copyWith(status: ReportsStatus.loading));

    try {
      late final String content;
      late final List<int>? pdfBytes;
      late final String fileName;

      switch (event.reportType) {
        case ReportType.spending:
          final report = state.spendingReport;
          if (report == null) {
            throw Exception('No spending report loaded');
          }
          if (event.format == ExportFormat.csv) {
            content =
                _reportRepository.exportSpendingReportCsv(report);
            pdfBytes = null;
            fileName = 'spending_report.csv';
          } else {
            content = '';
            pdfBytes = await _reportRepository
                .exportSpendingReportPdf(report);
            fileName = 'spending_report.pdf';
          }
        case ReportType.trends:
          final report = state.trendReport;
          if (report == null) {
            throw Exception('No trend report loaded');
          }
          if (event.format == ExportFormat.csv) {
            content =
                _reportRepository.exportTrendReportCsv(report);
            pdfBytes = null;
            fileName = 'trend_report.csv';
          } else {
            content = '';
            pdfBytes = await _reportRepository
                .exportTrendReportPdf(report);
            fileName = 'trend_report.pdf';
          }
        case ReportType.budgetVsActual:
          final report = state.budgetVsActualReport;
          if (report == null) {
            throw Exception('No budget vs actual report loaded');
          }
          if (event.format == ExportFormat.csv) {
            content = _reportRepository
                .exportBudgetVsActualCsv(report);
            pdfBytes = null;
            fileName = 'budget_vs_actual_report.csv';
          } else {
            content = '';
            pdfBytes = await _reportRepository
                .exportBudgetVsActualPdf(report);
            fileName = 'budget_vs_actual_report.pdf';
          }
        case ReportType.netWorth:
          throw Exception('Net worth export not supported');
      }

      final writer = _exportFileWriter;
      if (writer == null) {
        throw Exception('Export not available on this platform');
      }

      final filePath = await writer(
        fileName: fileName,
        content: pdfBytes == null ? content : null,
        bytes: pdfBytes,
      );

      emit(
        state.copyWith(
          status: ReportsStatus.loaded,
          exportedFilePath: filePath,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ReportsStatus.error,
          error: ReportsError.exportFailed,
        ),
      );
      emit(state.copyWith(status: ReportsStatus.loaded, error: null));
    }
  }

  Future<void> _onShareRequested(
    ReportsShareRequested event,
    Emitter<ReportsState> emit,
  ) async {
    try {
      await _fileSharer?.call(event.filePath);
    } on Exception {
      // Sharing cancelled or failed — not critical.
    }
  }

  @override
  Future<void> close() async {
    await _periodsSubscription?.cancel();
    return super.close();
  }
}
