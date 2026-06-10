import 'package:flutter/material.dart';

/// App color constants for Envelope — warm modern palette.
abstract final class AppColors {
  /// Warm cream background.
  static const Color background = Color(0xFFF5F0E8);

  /// White card surfaces.
  static const Color surface = Color(0xFFFFFFFF);

  /// Terracotta primary accent.
  static const Color primary = Color(0xFFD4896A);

  /// White text on primary.
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Charcoal — buttons, primary text.
  static const Color charcoal = Color(0xFF3A3A3A);

  /// Red for expense amounts.
  static const Color expense = Color(0xFFC0392B);

  /// Olive green for income amounts.
  static const Color income = Color(0xFF6B7F4A);

  /// Tan navigation background.
  static const Color navBackground = Color(0xFFEDE6DA);

  /// Warm divider color.
  static const Color divider = Color(0xFFE0D8CC);

  /// Secondary text / muted labels. #736E64 gives ~4.52:1 vs cream background (WCAG AA).
  static const Color secondaryText = Color(0xFF736E64);

  /// Warning amber.
  static const Color warning = Color(0xFFD4A24E);

  /// Dark brown on terracotta — icons & accents on primary.
  static const Color primaryDark = Color(0xFF5C2E1A);

  /// Parses a "#RRGGBB" hex string to a [Color]. Returns `null` if invalid.
  static Color? fromHex(String? hex) {
    if (hex == null || hex.length != 7 || !hex.startsWith('#')) return null;
    final value = int.tryParse(hex.substring(1), radix: 16);
    if (value == null) return null;
    return Color(0xFF000000 | value);
  }
}
