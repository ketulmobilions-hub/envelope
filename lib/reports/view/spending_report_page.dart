import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/reports/bloc/bloc.dart';
import 'package:envelope/reports/widgets/widgets.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Spending report page with donut chart and category breakdown.
class SpendingReportPage extends StatelessWidget {
  const SpendingReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsSpendingTitle)),
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Date range selector
              if (state.startDate != null && state.endDate != null)
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
              // Load button if no report yet
              if (state.spendingReport == null &&
                  state.status != ReportsStatus.loading)
                Center(
                  child: FilledButton(
                    onPressed: () {
                      if (state.startDate != null && state.endDate != null) {
                        context.read<ReportsBloc>().add(
                          SpendingReportRequested(
                            startDate: state.startDate!,
                            endDate: state.endDate!,
                          ),
                        );
                      }
                    },
                    child: Text(l10n.reportsSpendingTitle),
                  ),
                ),
              if (state.status == ReportsStatus.loading)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              // Report content
              if (state.spendingReport != null) ...[
                // Summary row
                _SummaryRow(
                  totalSpent: state.spendingReport!.totalSpent,
                  totalIncome: state.spendingReport!.totalIncome,
                ),
                const SizedBox(height: 24),
                // Donut chart
                if (state.spendingReport!.byCategory.isNotEmpty) ...[
                  SpendingDonutChart(
                    categories: state.spendingReport!.byCategory,
                  ),
                  const SizedBox(height: 24),
                  SpendingCategoryList(
                    categories: state.spendingReport!.byCategory,
                  ),
                ] else
                  const ReportEmptyState(),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.totalSpent, required this.totalIncome});

  final int totalSpent;
  final int totalIncome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: l10n.reportsTotalIncome,
            amount: totalIncome,
            color: AppColors.income,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: l10n.reportsTotalSpent,
            amount: totalSpent,
            color: AppColors.expense,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final symbol = currencySymbol(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatCents(amount, symbol: symbol),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
