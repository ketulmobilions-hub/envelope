import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/reports/bloc/bloc.dart';
import 'package:envelope/reports/widgets/widgets.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Budget vs Actual report page with horizontal bar chart.
class BudgetVsActualReportPage extends StatelessWidget {
  const BudgetVsActualReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsBudgetVsActualTitle)),
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Period dropdown
              if (state.budgetPeriods.isNotEmpty)
                ReportPeriodDropdown(
                  periods: state.budgetPeriods,
                  selectedPeriodId: state.selectedPeriodId,
                  onPeriodSelected: (periodId) {
                    context.read<ReportsBloc>().add(
                      BudgetVsActualReportRequested(periodId: periodId),
                    );
                  },
                ),
              const SizedBox(height: 16),
              // Load button if no report yet
              if (state.budgetVsActualReport == null &&
                  state.status != ReportsStatus.loading)
                Center(
                  child: FilledButton(
                    onPressed: state.selectedPeriodId != null
                        ? () {
                            context.read<ReportsBloc>().add(
                              BudgetVsActualReportRequested(
                                periodId: state.selectedPeriodId!,
                              ),
                            );
                          }
                        : null,
                    child: Text(l10n.reportsBudgetVsActualTitle),
                  ),
                ),
              if (state.status == ReportsStatus.loading)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (state.budgetVsActualReport != null) ...[
                // Summary
                _BudgetSummary(
                  totalAllocated:
                      state.budgetVsActualReport!.totalAllocated,
                  totalSpent: state.budgetVsActualReport!.totalSpent,
                ),
                const SizedBox(height: 16),
                if (state.budgetVsActualReport!.items.isNotEmpty)
                  BudgetVsActualBars(
                    items: state.budgetVsActualReport!.items,
                  )
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

class _BudgetSummary extends StatelessWidget {
  const _BudgetSummary({
    required this.totalAllocated,
    required this.totalSpent,
  });

  final int totalAllocated;
  final int totalSpent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final remaining = totalAllocated - totalSpent;
    final isOver = remaining < 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    l10n.reportsAllocated,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                  Text(
                    formatCents(totalAllocated),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    l10n.reportsSpent,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                  Text(
                    formatCents(totalSpent),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    l10n.reportsRemaining,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                  Text(
                    formatCents(remaining),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color:
                              isOver ? AppColors.expense : AppColors.income,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
