import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Prominently displays the "Ready to Assign" amount for the selected period.
///
/// The card is green when the amount is positive, red when over-allocated,
/// and shows a warning message if the user has allocated more than available.
class ReadyToAssignCard extends StatelessWidget {
  const ReadyToAssignCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<BudgetBloc, BudgetState>(
      buildWhen: (prev, curr) =>
          prev.localReadyToAssign != curr.localReadyToAssign ||
          prev.isOverAllocated != curr.isOverAllocated,
      builder: (context, state) {
        final amount = state.localReadyToAssign;
        final isOver = state.isOverAllocated;
        final symbol = currencySymbol(context);
        final color = isOver
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.budgetReadyToAssign,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatCents(amount, symbol: symbol),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isOver) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        l10n.budgetOverAllocatedWarning,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
