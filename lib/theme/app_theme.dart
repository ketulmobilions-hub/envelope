import 'package:envelope/theme/app_colors.dart';
import 'package:envelope/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

/// Provides light and dark [ThemeData] for the Envelope app.
abstract final class AppTheme {
  /// Light theme — warm modern aesthetic.
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.charcoal,
      onSecondary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.charcoal,
      error: AppColors.expense,
      outline: AppColors.secondaryText,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: AppTextTheme.textTheme,
    inputDecorationTheme: const InputDecorationTheme(
      border: UnderlineInputBorder(),
      filled: false,
      labelStyle: TextStyle(color: AppColors.secondaryText),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      clipBehavior: Clip.antiAlias,
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      shadowColor: AppColors.charcoal.withValues(alpha: 0.08),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.charcoal,
        foregroundColor: AppColors.onPrimary,
        textStyle: TextStyle(
          letterSpacing: AppSpacing.label,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.charcoal,
        textStyle: TextStyle(
          letterSpacing: AppSpacing.label,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      selectedColor: AppColors.charcoal,
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.divider),
      labelStyle: const TextStyle(color: AppColors.charcoal),
      secondaryLabelStyle: const TextStyle(color: AppColors.onPrimary),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.charcoal,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: AppColors.charcoal),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.charcoal,
      foregroundColor: AppColors.onPrimary,
      elevation: 2,
      shape: CircleBorder(),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navBackground,
      indicatorColor: AppColors.primary.withValues(alpha: 0.15),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.charcoal,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: AppColors.secondaryText,
          fontSize: 12,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.charcoal);
        }
        return const IconThemeData(color: AppColors.secondaryText);
      }),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.charcoal,
      contentTextStyle: const TextStyle(color: AppColors.onPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  /// Dark theme — TODO: implement dark variant.
  static final ThemeData dark = light;
}
