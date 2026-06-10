import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide letter-spacing constants.
abstract final class AppSpacing {
  /// Letter-spacing for labels and buttons.
  static const double label = 0.5;
}

/// Builds the app [TextTheme].
///
/// Type scale:
///   display / headline → Playfair Display (serif, for large financial figures
///                         and hero headings)
///   title / body / label → Inter (sans-serif, for UI chrome and body copy)
abstract final class AppTextTheme {
  static TextTheme build({
    required Color text,
    required Color muted,
  }) {
    final serif = GoogleFonts.playfairDisplay();
    final sans = GoogleFonts.inter();

    return TextTheme(
      // ── Display (Playfair) ───────────────────────────────────
      displayLarge: serif.copyWith(
        color: text,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: serif.copyWith(
        color: text,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: serif.copyWith(
        color: text,
        fontWeight: FontWeight.w700,
      ),
      // ── Headline (Playfair) ─────────────────────────────────
      headlineLarge: serif.copyWith(
        color: text,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: serif.copyWith(
        color: text,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: serif.copyWith(
        color: text,
        fontWeight: FontWeight.w600,
      ),
      // ── Title (Inter) ───────────────────────────────────────
      titleLarge: sans.copyWith(
        color: text,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: sans.copyWith(
        color: text,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: sans.copyWith(
        color: text,
        fontWeight: FontWeight.w600,
      ),
      // ── Body (Inter) ────────────────────────────────────────
      bodyLarge: sans.copyWith(
        color: text,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: sans.copyWith(
        color: text,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: sans.copyWith(
        color: muted,
        fontWeight: FontWeight.w400,
      ),
      // ── Label (Inter) ───────────────────────────────────────
      labelLarge: sans.copyWith(
        color: text,
        fontWeight: FontWeight.w500,
        letterSpacing: AppSpacing.label,
      ),
      labelMedium: sans.copyWith(
        color: muted,
        fontWeight: FontWeight.w500,
        letterSpacing: AppSpacing.label,
      ),
      labelSmall: sans.copyWith(
        color: muted,
        fontWeight: FontWeight.w500,
        letterSpacing: AppSpacing.label,
      ),
    );
  }

  /// Light theme text.
  static TextTheme get textTheme => build(
        text: AppColors.charcoal,
        muted: AppColors.secondaryText,
      );
}
