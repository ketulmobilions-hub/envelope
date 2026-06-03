import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/reports/bloc/bloc.dart';
import 'package:envelope/reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Export report page — select report type, format, then share.
class ExportReportPage extends StatelessWidget {
  const ExportReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsExportTitle)),
      body: BlocListener<ReportsBloc, ReportsState>(
        listenWhen: (prev, curr) =>
            prev.exportedFilePath != curr.exportedFilePath &&
            curr.exportedFilePath != null,
        listener: (context, state) {
          context.read<ReportsBloc>().add(
            ReportsShareRequested(filePath: state.exportedFilePath!),
          );
        },
        child: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            final selectedType = state.exportReportType;
            final selectedFormat = state.exportFormat;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Report type selector
                DropdownButtonFormField<ReportType>(
                  decoration: InputDecoration(
                    labelText: l10n.reportsExportReportType,
                    border: const OutlineInputBorder(),
                  ),
                  value: selectedType,
                  items: [
                    DropdownMenuItem(
                      value: ReportType.spending,
                      child: Text(l10n.reportsSpendingTitle),
                    ),
                    DropdownMenuItem(
                      value: ReportType.trends,
                      child: Text(l10n.reportsTrendsTitle),
                    ),
                    DropdownMenuItem(
                      value: ReportType.budgetVsActual,
                      child: Text(
                        l10n.reportsBudgetVsActualTitle,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ReportsBloc>().add(
                        ExportReportTypeChanged(
                          reportType: value,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Format radio buttons
                Text(
                  l10n.reportsExportFormat,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                RadioListTile<ExportFormat>(
                  title: Text(l10n.reportsExportCsv),
                  value: ExportFormat.csv,
                  groupValue: selectedFormat,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ReportsBloc>().add(
                        ExportFormatChanged(format: value),
                      );
                    }
                  },
                ),
                RadioListTile<ExportFormat>(
                  title: Text(l10n.reportsExportPdf),
                  value: ExportFormat.pdf,
                  groupValue: selectedFormat,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ReportsBloc>().add(
                        ExportFormatChanged(format: value),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Date range for spending
                if (selectedType == ReportType.spending &&
                    state.startDate != null &&
                    state.endDate != null) ...[
                  ReportDateRangeSelector(
                    startDate: state.startDate!,
                    endDate: state.endDate!,
                    onDateRangeSelected: (start, end) {
                      context.read<ReportsBloc>().add(
                        SpendingReportRequested(
                          startDate: start,
                          endDate: end,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                if (selectedType == ReportType.trends) ...[
                  ReportMonthsSelector(
                    months: state.trendMonths,
                    onMonthsChanged: (months) {
                      context.read<ReportsBloc>().add(
                        TrendReportRequested(months: months),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                if (selectedType == ReportType.budgetVsActual &&
                    state.budgetPeriods.isNotEmpty) ...[
                  ReportPeriodDropdown(
                    periods: state.budgetPeriods,
                    selectedPeriodId: state.selectedPeriodId,
                    onPeriodSelected: (periodId) {
                      context.read<ReportsBloc>().add(
                        BudgetVsActualReportRequested(
                          periodId: periodId,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                // Export + Share button
                FilledButton.icon(
                  onPressed: state.status == ReportsStatus.loading
                      ? null
                      : () => _export(context, state),
                  icon: const Icon(Icons.share),
                  label: Text(l10n.reportsShare),
                ),
                if (state.status == ReportsStatus.loading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _export(BuildContext context, ReportsState state) {
    final bloc = context.read<ReportsBloc>();
    final selectedType = state.exportReportType;

    switch (selectedType) {
      case ReportType.spending:
        if (state.spendingReport == null) {
          bloc.add(
            SpendingReportRequested(
              startDate: state.startDate ?? DateTime.now(),
              endDate: state.endDate ?? DateTime.now(),
            ),
          );
          return;
        }
      case ReportType.trends:
        if (state.trendReport == null) {
          bloc.add(
            TrendReportRequested(months: state.trendMonths),
          );
          return;
        }
      case ReportType.budgetVsActual:
        if (state.budgetVsActualReport == null) {
          if (state.selectedPeriodId != null) {
            bloc.add(
              BudgetVsActualReportRequested(
                periodId: state.selectedPeriodId!,
              ),
            );
          }
          return;
        }
      case ReportType.netWorth:
        return;
    }

    bloc.add(
      ReportsExportRequested(
        format: state.exportFormat,
        reportType: selectedType,
      ),
    );
  }
}
