import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/reports/bloc/bloc.dart';
import 'package:envelope/reports/widgets/widgets.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Trends report page with grouped bar chart.
class TrendsReportPage extends StatelessWidget {
  const TrendsReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTrendsTitle)),
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Months selector
              ReportMonthsSelector(
                months: state.trendMonths,
                onMonthsChanged: (months) {
                  context.read<ReportsBloc>().add(
                    TrendReportRequested(months: months),
                  );
                },
              ),
              const SizedBox(height: 8),
              // Load button if no report yet
              if (state.trendReport == null &&
                  state.status != ReportsStatus.loading)
                Center(
                  child: FilledButton(
                    onPressed: () {
                      context.read<ReportsBloc>().add(
                        TrendReportRequested(months: state.trendMonths),
                      );
                    },
                    child: Text(l10n.reportsTrendsTitle),
                  ),
                ),
              if (state.status == ReportsStatus.loading)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (state.trendReport != null) ...[
                // Legend
                const _Legend(),
                const SizedBox(height: 16),
                if (state.trendReport!.dataPoints.isNotEmpty)
                  TrendBarChart(dataPoints: state.trendReport!.dataPoints)
                else
                  const ReportEmptyState(),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: AppColors.income, label: l10n.reportsIncome),
        const SizedBox(width: 24),
        _LegendItem(color: AppColors.expense, label: l10n.reportsExpenses),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
