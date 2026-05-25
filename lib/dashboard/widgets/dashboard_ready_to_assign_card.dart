import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/animated_cents.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Displays the "Ready to Assign" amount on the dashboard.
///
/// Green when positive, yellow at zero, red when negative (over-allocated).
///
/// When [carriedRta] is non-zero, a subtitle explains the carried-forward
/// balance so a negative RTA caused by last period's overspend or
/// over-assignment is discoverable (the overspend no longer shows as a
/// per-envelope negative rollover).
class DashboardReadyToAssignCard extends StatelessWidget {
  const DashboardReadyToAssignCard({
    required this.readyToAssign,
    this.carriedRta = 0,
    this.onTap,
    super.key,
  });

  final int readyToAssign;
  final int carriedRta;
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: color.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dashboardReadyToAssign,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedCents(
                  cents: readyToAssign,
                  symbol: symbol,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (carriedRta != 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    carriedRta > 0
                        ? l10n.dashboardRtaCarriedPositive(
                            formatCents(carriedRta, symbol: symbol),
                          )
                        : l10n.dashboardRtaCarriedNegative(
                            formatCents(-carriedRta, symbol: symbol),
                          ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
