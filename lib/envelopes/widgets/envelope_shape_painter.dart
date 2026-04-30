import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Paints a closed envelope shape with a darker triangular
/// flap and a shadow beneath the flap for a realistic look.
class EnvelopeShapePainter extends CustomPainter {
  const EnvelopeShapePainter({
    this.fillColor = AppColors.primary,
    this.flapRatio = 0.28,
  });

  /// Fill color of the envelope body.
  final Color fillColor;

  /// How far down (as a fraction of height) the flap extends.
  final double flapRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final radius = w * 0.06;
    final flapY = h * flapRatio;

    // 1. Full rounded-rect body.
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(radius),
    );
    canvas.drawRRect(bodyRect, Paint()..color = fillColor);

    // 2. Shadow under the flap — gives depth.
    final shadowPath = Path()
      ..moveTo(4, 0)
      ..lineTo(w / 2, flapY + 3)
      ..lineTo(w - 4, 0);
    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = const Color(0xFF000000).withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // 3. Darker flap triangle on top, clipped to rounded
    //    top corners.
    final flapPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w / 2, flapY)
      ..close();

    final flapColor = Color.lerp(fillColor, Colors.white, 0.2)!;

    canvas
      ..save()
      ..clipRRect(bodyRect)
      ..drawPath(flapPath, Paint()..color = flapColor)
      ..restore();

    // 4. Thin edge line on the flap for crispness.
    final edgePath = Path()
      ..moveTo(0, 0)
      ..lineTo(w / 2, flapY)
      ..lineTo(w, 0);

    canvas
      ..save()
      ..clipRRect(bodyRect)
      ..drawPath(
        edgePath,
        Paint()
          ..color = const Color(0xFF000000).withValues(alpha: 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(
    covariant EnvelopeShapePainter oldDelegate,
  ) => fillColor != oldDelegate.fillColor || flapRatio != oldDelegate.flapRatio;
}
