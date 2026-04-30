import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:report_repository/report_repository.dart';

/// Horizontal bars showing allocated vs spent, with over/under coloring.
class BudgetVsActualBars extends StatelessWidget {
  const BudgetVsActualBars({required this.items, super.key});

  final List<BudgetVsActualItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final maxAmount = items.fold<int>(0, (max, item) {
      final m = item.allocated > item.spent ? item.allocated : item.spent;
      return m > max ? m : max;
    });

    return Column(
      children: items.map((item) {
        return _BudgetBar(item: item, maxAmount: maxAmount);
      }).toList(),
    );
  }
}

class _BudgetBar extends StatelessWidget {
  const _BudgetBar({required this.item, required this.maxAmount});

  final BudgetVsActualItem item;
  final int maxAmount;

  @override
  Widget build(BuildContext context) {
    final symbol = currencySymbol(context);
    final isOver = item.remaining < 0;
    final allocatedFraction = maxAmount > 0 ? item.allocated / maxAmount : 0.0;
    final spentFraction = maxAmount > 0 ? item.spent / maxAmount : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.envelopeName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                formatCents(item.remaining, symbol: symbol),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isOver ? AppColors.expense : AppColors.income,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.categoryGroupName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          // Allocated bar
          _ProgressBar(
            fraction: allocatedFraction,
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 4),
          // Spent bar
          _ProgressBar(
            fraction: spentFraction,
            color: isOver ? AppColors.expense : AppColors.income,
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.fraction,
    required this.color,
  });

  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: fraction.clamp(0, 1),
        backgroundColor: AppColors.divider,
        color: color,
        minHeight: 8,
      ),
    );
  }
}
