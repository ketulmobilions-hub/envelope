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

/// Builds the app [TextTheme] with Inter for all text styles.
abstract final class AppTextTheme {
  static TextTheme get textTheme {
    final sansStyle = GoogleFonts.inter();

    return TextTheme(
      displayLarge: sansStyle.copyWith(color: AppColors.charcoal),
      displayMedium: sansStyle.copyWith(color: AppColors.charcoal),
      displaySmall: sansStyle.copyWith(color: AppColors.charcoal),
      headlineLarge: sansStyle.copyWith(color: AppColors.charcoal),
      headlineMedium: sansStyle.copyWith(color: AppColors.charcoal),
      headlineSmall: sansStyle.copyWith(color: AppColors.charcoal),
      titleLarge: sansStyle.copyWith(color: AppColors.charcoal),
      titleMedium: sansStyle.copyWith(color: AppColors.charcoal),
      titleSmall: sansStyle.copyWith(color: AppColors.charcoal),
      bodyLarge: sansStyle.copyWith(color: AppColors.charcoal),
      bodyMedium: sansStyle.copyWith(color: AppColors.charcoal),
      bodySmall: sansStyle.copyWith(color: AppColors.secondaryText),
      labelLarge: sansStyle.copyWith(
        color: AppColors.charcoal,
        letterSpacing: AppSpacing.label,
      ),
      labelMedium: sansStyle.copyWith(
        color: AppColors.secondaryText,
        letterSpacing: AppSpacing.label,
      ),
      labelSmall: sansStyle.copyWith(
        color: AppColors.secondaryText,
        letterSpacing: AppSpacing.label,
      ),
    );
  }
}
