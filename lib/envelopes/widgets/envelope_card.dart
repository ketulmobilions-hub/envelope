import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/envelopes/widgets/envelope_shape_painter.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A card widget that overlays envelope info on an envelope-shaped background.
class EnvelopeCard extends StatelessWidget {
  const EnvelopeCard({
    required this.name,
    required this.availableCents,
    required this.allocatedCents,
    required this.spentCents,
    this.isOverspent = false,
    this.primaryLabel,
    this.limitLabel,
    this.color,
    this.heroTag,
    this.onTap,
    this.onEditTap,
    this.onFixOverspend,
    this.onPay,
    super.key,
  });

  final String name;
  final int availableCents;
  final int allocatedCents;
  final int spentCents;
  final bool isOverspent;

  /// When set, replaces the big amount with this text (e.g. "Due: $450").
  final String? primaryLabel;

  /// Small secondary line shown below [primaryLabel] (e.g. "$550 of $1,000").
  final String? limitLabel;
  final Color? color;
  final String? heroTag;
  final VoidCallback? onTap;

  /// Called when the user taps the allocated amount / edit icon.
  /// Typically opens the allocate bottom sheet.
  final VoidCallback? onEditTap;

  /// Called when the user taps "Fix Overspend" on an overspent card.
  final VoidCallback? onFixOverspend;

  /// Called when the user taps "Pay" on a CC payment envelope card.
  final VoidCallback? onPay;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);
    final fillColor = isOverspent
        ? AppColors.expense
        : (color ?? AppColors.primary);
    final textColor = AppColors.onPrimary.withValues(alpha: 0.9);

    Widget card = SizedBox(
      height: 140,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: EnvelopeShapePainter(
                fillColor: fillColor,
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              44,
              14,
              12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: IgnorePointer(
                    child: SizedBox.expand(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              letterSpacing: 0.8,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          if (primaryLabel != null) ...[
                            Text(
                              primaryLabel!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            if (limitLabel != null)
                              Text(
                                limitLabel!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textColor.withValues(alpha: 0.7),
                                ),
                              ),
                          ] else
                            Text(
                              formatCents(
                                availableCents,
                                symbol: symbol,
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Divider(
                  height: 1,
                  thickness: 0.8,
                  color: textColor.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 4),
                if (onPay != null)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onPay,
                    child: Row(
                      children: [
                        Icon(
                          Icons.credit_card_outlined,
                          size: 10,
                          color: textColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.ccPayButton,
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (isOverspent && onFixOverspend != null)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onFixOverspend,
                    child: Row(
                      children: [
                        Icon(
                          Icons.build_outlined,
                          size: 10,
                          color: textColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.envelopeFixOverspend,
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onEditTap,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            l10n.envelopeCardOfAllocated(
                              formatCents(
                                allocatedCents,
                                symbol: symbol,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (onEditTap != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 10,
                              color: textColor,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (heroTag != null) {
      card = Hero(
        tag: heroTag!,
        flightShuttleBuilder:
            (
              _,
              animation,
              direction,
              fromContext,
              toContext,
            ) {
              final curvedAnim = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );
              return AnimatedBuilder(
                animation: curvedAnim,
                builder: (context, _) {
                  final t = curvedAnim.value;
                  final radius = BorderRadius.circular(12 * (1 - t));
                  return ClipRRect(
                    borderRadius: radius,
                    child: Container(color: fillColor),
                  );
                },
              );
            },
        child: Material(
          type: MaterialType.transparency,
          child: card,
        ),
      );
    }

    return Semantics(
      label: onEditTap != null ? 'Edit envelope allocation' : null,
      child: card,
    );
  }
}
