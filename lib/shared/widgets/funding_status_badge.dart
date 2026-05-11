import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/services/funding_status_service.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Color-coded chip indicating an envelope or goal's funding state for the
/// current period.
///
/// Renders nothing when [status] is [FundingStatus.noTarget].
class FundingStatusBadge extends StatelessWidget {
  const FundingStatusBadge({
    required this.status,
    required this.amountCents,
    required this.symbol,
    super.key,
  });

  final FundingStatus status;

  /// Shortfall for underfunded badges; ignored for fully-funded / overspent.
  final int amountCents;

  final String symbol;

  @override
  Widget build(BuildContext context) {
    if (status == FundingStatus.noTarget) return const SizedBox.shrink();

    final l10n = context.l10n;
    final config = _configFor(status, l10n);

    return Tooltip(
      message: config.tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: config.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: config.foreground.withValues(alpha: 0.35)),
        ),
        child: Text(
          config.label,
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: config.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  _BadgeConfig _configFor(FundingStatus status, AppLocalizations l10n) {
    final formatted = formatCents(amountCents, symbol: symbol);
    return switch (status) {
      FundingStatus.fullyFunded => _BadgeConfig(
        background: AppColors.income.withValues(alpha: 0.15),
        foreground: AppColors.income,
        label: l10n.fundingStatusFunded,
        tooltip: l10n.fundingStatusFundedTooltip,
      ),
      FundingStatus.underfunded => _BadgeConfig(
        background: AppColors.warning.withValues(alpha: 0.2),
        foreground: AppColors.charcoal,
        label: l10n.budgetNeededShort(formatted),
        tooltip: l10n.budgetNeededThisMonth(formatted),
      ),
      FundingStatus.overspent => _BadgeConfig(
        background: AppColors.expense.withValues(alpha: 0.15),
        foreground: AppColors.expense,
        label: l10n.fundingStatusOverspent,
        tooltip: l10n.fundingStatusOverspentTooltip,
      ),
      FundingStatus.noTarget => throw StateError(
        'FundingStatus.noTarget is short-circuited in build',
      ),
    };
  }
}

class _BadgeConfig {
  const _BadgeConfig({
    required this.background,
    required this.foreground,
    required this.label,
    required this.tooltip,
  });

  final Color background;
  final Color foreground;
  final String label;
  final String tooltip;
}
