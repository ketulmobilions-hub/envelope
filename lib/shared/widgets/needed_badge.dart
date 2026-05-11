import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Compact chip showing the amount still needed this period to hit a target.
///
/// Renders nothing when [amountCents] is zero or negative.
class NeededBadge extends StatelessWidget {
  const NeededBadge({
    required this.amountCents,
    required this.symbol,
    super.key,
  });

  final int amountCents;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    if (amountCents <= 0) return const SizedBox.shrink();

    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final formatted = formatCents(amountCents, symbol: symbol);

    return Tooltip(
      message: l10n.budgetNeededThisMonth(formatted),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: scheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          l10n.budgetNeededShort(formatted),
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: scheme.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
