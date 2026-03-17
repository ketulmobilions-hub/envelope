import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/envelopes/widgets/envelope_shape_painter.dart';
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
    this.onTap,
    super.key,
  });

  final String name;
  final int availableCents;
  final int allocatedCents;
  final int spentCents;
  final bool isOverspent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = isOverspent ? AppColors.expense : AppColors.primary;
    final progress = allocatedCents > 0
        ? (spentCents / allocatedCents).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 120,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: EnvelopeShapePainter(
                  fillColor: fillColor.withValues(alpha: 0.12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: fillColor.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation(fillColor),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatCents(availableCents),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: fillColor,
                      fontWeight: FontWeight.w600,
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
