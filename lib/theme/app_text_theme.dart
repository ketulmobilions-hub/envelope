import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide letter-spacing constants.
abstract final class AppSpacing {
  /// Title letter-spacing for headings.
  static const double title = 6.0;

  /// Label letter-spacing for buttons and labels.
  static const double label = 1.5;
}

/// Builds the app [TextTheme] with Playfair Display for display/headline styles
/// and default sans-serif for body/label styles.
abstract final class AppTextTheme {
  static TextTheme get textTheme {
    final serifStyle = GoogleFonts.playfairDisplay();

    return TextTheme(
      displayLarge: serifStyle.copyWith(color: AppColors.charcoal),
      displayMedium: serifStyle.copyWith(color: AppColors.charcoal),
      displaySmall: serifStyle.copyWith(color: AppColors.charcoal),
      headlineLarge: serifStyle.copyWith(color: AppColors.charcoal),
      headlineMedium: serifStyle.copyWith(color: AppColors.charcoal),
      headlineSmall: serifStyle.copyWith(color: AppColors.charcoal),
      titleLarge: serifStyle.copyWith(color: AppColors.charcoal),
      // Body and label styles use the default sans-serif.
      titleMedium: const TextStyle(color: AppColors.charcoal),
      titleSmall: const TextStyle(color: AppColors.charcoal),
      bodyLarge: const TextStyle(color: AppColors.charcoal),
      bodyMedium: const TextStyle(color: AppColors.charcoal),
      bodySmall: const TextStyle(color: AppColors.secondaryText),
      labelLarge: TextStyle(
        color: AppColors.charcoal,
        letterSpacing: AppSpacing.label,
      ),
      labelMedium: TextStyle(
        color: AppColors.secondaryText,
        letterSpacing: AppSpacing.label,
      ),
      labelSmall: TextStyle(
        color: AppColors.secondaryText,
        letterSpacing: AppSpacing.label,
      ),
    );
  }
}
