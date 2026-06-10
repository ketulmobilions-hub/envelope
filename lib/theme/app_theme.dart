import 'package:envelope/theme/app_colors.dart';
import 'package:envelope/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Provides light and dark [ThemeData] for the Envelope app.
abstract final class AppTheme {
  /// Light theme — warm modern aesthetic.
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.charcoal,
      onSecondary: AppColors.onPrimary,
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
        textStyle: const TextStyle(
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
        textStyle: const TextStyle(
          letterSpacing: AppSpacing.label,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    chipTheme: const ChipThemeData(
      shape: StadiumBorder(),
      selectedColor: AppColors.charcoal,
      backgroundColor: AppColors.surface,
      side: BorderSide(color: AppColors.divider),
      labelStyle: TextStyle(color: AppColors.charcoal),
      secondaryLabelStyle: TextStyle(color: AppColors.onPrimary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      titleTextStyle: GoogleFonts.inter(
        color: AppColors.charcoal,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: AppColors.charcoal),
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
      actionTextColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  /// Dark theme — warm dark aesthetic matching the light theme palette.
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: Color(0xFFD0C8BC),
      onSecondary: Color(0xFF1E1E1E),
      surface: Color(0xFF2A2A2A),
      onSurface: Color(0xFFE8E0D4),
      error: AppColors.expense,
      outline: Color(0xFF8A8478),
    ),
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    textTheme: AppTextTheme.build(
      text: const Color(0xFFE8E0D4),
      muted: const Color(0xFF8A8478),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: UnderlineInputBorder(),
      filled: false,
      labelStyle: TextStyle(color: Color(0xFF8A8478)),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF2A2A2A),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(0xFF3A3A3A).withValues(alpha: 0.5),
        ),
      ),
      shadowColor: Colors.black.withValues(alpha: 0.2),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFFE8E0D4),
        foregroundColor: const Color(0xFF1E1E1E),
        textStyle: const TextStyle(
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
        foregroundColor: const Color(0xFFE8E0D4),
        textStyle: const TextStyle(
          letterSpacing: AppSpacing.label,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    chipTheme: const ChipThemeData(
      shape: StadiumBorder(),
      selectedColor: Color(0xFFE8E0D4),
      backgroundColor: Color(0xFF2A2A2A),
      side: BorderSide(color: Color(0xFF3A3A3A)),
      labelStyle: TextStyle(color: Color(0xFFE8E0D4)),
      secondaryLabelStyle: TextStyle(color: Color(0xFF1E1E1E)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: GoogleFonts.inter(
        color: const Color(0xFFE8E0D4),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Color(0xFFE8E0D4)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3A3A3A),
      thickness: 1,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFE8E0D4),
      foregroundColor: Color(0xFF1E1E1E),
      elevation: 2,
      shape: CircleBorder(),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF252525),
      indicatorColor: AppColors.primary.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: Color(0xFFE8E0D4),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: Color(0xFF8A8478),
          fontSize: 12,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: Color(0xFFE8E0D4));
        }
        return const IconThemeData(color: Color(0xFF8A8478));
      }),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFFE8E0D4),
      contentTextStyle: const TextStyle(color: Color(0xFF1E1E1E)),
      actionTextColor: AppColors.primaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

}
