import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formats cents as a currency string using locale-aware formatting.
///
/// Uses `NumberFormat.simpleCurrency` for proper symbol and formatting.
String formatCents(int cents) {
  final formatter = NumberFormat.simpleCurrency();
  return formatter.format(cents / 100);
}

/// Shared category colors for donut chart and category list.
const List<Color> reportCategoryColors = [
  AppColors.primary,
  AppColors.income,
  AppColors.expense,
  AppColors.warning,
  AppColors.primaryDark,
  AppColors.secondaryText,
  AppColors.charcoal,
];

/// Month abbreviations for chart labels.
const List<String> monthAbbreviations = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
