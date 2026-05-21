import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:flutter/material.dart';

/// Animates an integer cents value via odometer-style count transition.
///
/// Re-formats with [formatCents] each frame. Initial render does not animate
/// (begin == end); subsequent value changes tween from the previous end to
/// the new value over [duration].
class AnimatedCents extends StatelessWidget {
  const AnimatedCents({
    required this.cents,
    this.symbol = r'$',
    this.style,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
    this.prefix,
    this.textAlign,
    this.maxLines,
    this.overflow,
    super.key,
  });

  final int cents;
  final String symbol;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final String? prefix;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: cents, end: cents),
      duration: duration,
      curve: curve,
      builder: (_, value, _) {
        final formatted = formatCents(value, symbol: symbol);
        return Text(
          prefix == null ? formatted : '$prefix$formatted',
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}
