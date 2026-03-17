import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Paints an envelope shape: rounded rectangle body + triangular flap on top.
class EnvelopeShapePainter extends CustomPainter {
  const EnvelopeShapePainter({
    this.fillColor = AppColors.primary,
    this.flapRatio = 0.3,
  });

  /// Fill color of the envelope (terracotta default, red for overspent).
  final Color fillColor;

  /// Fraction of height used by the flap.
  final double flapRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final flapH = h * flapRatio;
    final radius = w * 0.08;

    // Body: rounded rectangle from flapH to bottom.
    final bodyRect = RRect.fromLTRBR(
      0,
      flapH,
      w,
      h,
      Radius.circular(radius),
    );
    canvas.drawRRect(bodyRect, paint);

    // Flap: triangle from top-left → top-right → center-bottom of flap area.
    final flapPath = Path()
      ..moveTo(0, flapH)
      ..lineTo(w / 2, flapH * 0.15)
      ..lineTo(w, flapH)
      ..close();
    canvas.drawPath(flapPath, paint);

    // Subtle outline.
    final outlinePaint = Paint()
      ..color = fillColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(bodyRect, outlinePaint);
    canvas.drawPath(flapPath, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant EnvelopeShapePainter oldDelegate) =>
      fillColor != oldDelegate.fillColor ||
      flapRatio != oldDelegate.flapRatio;
}
