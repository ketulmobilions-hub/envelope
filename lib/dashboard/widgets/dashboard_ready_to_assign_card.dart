import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/animated_cents.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Displays the "Ready to Assign" amount on the dashboard, with an optional
/// period-navigation header.
///
/// Green when positive, yellow at zero, red when negative (over-allocated).
///
/// When [period] is provided, a header row with previous/next chevrons lets
/// the user switch the dashboard's active budget period. The chevrons are
/// independent tap targets — only the amount area triggers [onTap].
class DashboardReadyToAssignCard extends StatelessWidget {
  const DashboardReadyToAssignCard({
    required this.readyToAssign,
    required this.totalSpent,
    required this.totalAllocated,
    this.period,
    this.hasPreviousPeriod = false,
    this.hasNextPeriod = false,
    this.onPreviousPeriod,
    this.onNextPeriod,
    this.onTap,
    super.key,
  });

  final int readyToAssign;
  final int totalSpent;
  final int totalAllocated;

  /// The currently-selected budget period. When non-null a period-navigation
  /// header is shown.
  final BudgetPeriod? period;
  final bool hasPreviousPeriod;
  final bool hasNextPeriod;
  final VoidCallback? onPreviousPeriod;
  final VoidCallback? onNextPeriod;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final symbol = currencySymbol(context);

    final Color color;
    if (readyToAssign > 0) {
      color = AppColors.income;
    } else if (readyToAssign == 0) {
      color = AppColors.warning;
    } else {
      color = colorScheme.error;
    }

    final spentColor = totalSpent > totalAllocated
        ? AppColors.expense
        : AppColors.charcoal;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: color.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            if (period != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      tooltip: l10n.dashboardPreviousPeriod,
                      visualDensity: VisualDensity.compact,
                      onPressed: hasPreviousPeriod ? onPreviousPeriod : null,
                    ),
                    Flexible(
                      child: Text(
                        _formatPeriod(period!),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      tooltip: l10n.dashboardNextPeriod,
                      visualDensity: VisualDensity.compact,
                      onPressed: hasNextPeriod ? onNextPeriod : null,
                    ),
                  ],
                ),
              ),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            l10n.dashboardReadyToAssign,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: color),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: AnimatedCents(
                              cents: readyToAssign,
                              symbol: symbol,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      height: 1,
                      color: color.withValues(alpha: 0.25),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${l10n.budgetSpentLabel} / '
                            '${l10n.budgetAllocatedLabel}',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: AppColors.secondaryText),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedCents(
                                  cents: totalSpent,
                                  symbol: symbol,
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: spentColor,
                                      ),
                                ),
                                AnimatedCents(
                                  cents: totalAllocated,
                                  symbol: symbol,
                                  prefix: ' / ',
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.charcoal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (totalAllocated > 0) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: (totalSpent / totalAllocated).clamp(0.0, 1.0),
                          minHeight: 5,
                          backgroundColor: color.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(spentColor),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatPeriod(BudgetPeriod period) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final start = period.startDate;
    final end = period.endDate;
    if (start.year == end.year && start.month == end.month) {
      return '${months[start.month - 1]} ${start.year}';
    }
    final startLabel = months[start.month - 1];
    final endLabel = months[end.month - 1];
    // Show both years when the period spans a year boundary (weekly/biweekly),
    // otherwise the start month would be mis-attributed to the end year.
    if (start.year != end.year) {
      return '$startLabel ${start.year} – $endLabel ${end.year}';
    }
    return '$startLabel – $endLabel ${end.year}';
  }
}
