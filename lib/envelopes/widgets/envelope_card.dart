import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/envelopes/widgets/envelope_shape_painter.dart';
import 'package:envelope/l10n/l10n.dart';
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
    this.color,
    this.heroTag,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final String name;
  final int availableCents;
  final int allocatedCents;
  final int spentCents;
  final bool isOverspent;
  final Color? color;
  final String? heroTag;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fillColor =
        isOverspent ? AppColors.expense : (color ?? AppColors.primary);
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
                Text(
                  formatCents(availableCents),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Divider(
                  height: 1,
                  thickness: 0.8,
                  color: textColor.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.envelopeCardOfAllocated(
                    formatCents(allocatedCents),
                  ),
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor,
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
        flightShuttleBuilder: (
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
              final radius =
                  BorderRadius.circular(12 * (1 - t));
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
      onLongPressHint: onLongPress != null ? 'Quick allocate' : null,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: card,
      ),
    );
  }
}
