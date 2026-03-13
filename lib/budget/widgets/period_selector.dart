import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Horizontal period navigation bar: left arrow, period label, right arrow.
class PeriodSelector extends StatelessWidget {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      buildWhen: (prev, curr) =>
          prev.selectedPeriod != curr.selectedPeriod ||
          prev.hasPreviousPeriod != curr.hasPreviousPeriod ||
          prev.hasNextPeriod != curr.hasNextPeriod,
      builder: (context, state) {
        return Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: state.hasPreviousPeriod
                    ? () => context
                        .read<BudgetBloc>()
                        .add(const BudgetPreviousPeriodRequested())
                    : null,
              ),
              Text(
                state.selectedPeriod != null
                    ? _formatPeriod(state.selectedPeriod!)
                    : '—',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: state.hasNextPeriod
                    ? () => context
                        .read<BudgetBloc>()
                        .add(const BudgetNextPeriodRequested())
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatPeriod(BudgetPeriod period) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final start = period.startDate;
    final end = period.endDate;
    if (start.year == end.year && start.month == end.month) {
      return '${months[start.month - 1]} ${start.year}';
    }
    final startLabel = months[start.month - 1];
    final endLabel = months[end.month - 1];
    return '$startLabel \u2013 $endLabel ${end.year}';
  }
}
