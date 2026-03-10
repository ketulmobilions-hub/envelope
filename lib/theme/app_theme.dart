import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Provides light and dark [ThemeData] for the Envelope app.
abstract final class AppTheme {
  /// Light theme.
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primarySeed,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
    ),
    cardTheme: const CardThemeData(
      clipBehavior: Clip.antiAlias,
    ),
  );

  /// Dark theme.
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primarySeed,
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
    ),
    cardTheme: const CardThemeData(
      clipBehavior: Clip.antiAlias,
    ),
  );
}
