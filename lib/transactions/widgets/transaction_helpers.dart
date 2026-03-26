import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Re-export formatCents/parseCents so callers can import from one place.
export 'package:envelope/accounts/widgets/format_cents.dart';

/// Returns a localized label for a transaction type.
String localizedTransactionType(String type, AppLocalizations l10n) {
  return switch (type) {
    'income' => l10n.transactionsTypeIncome,
    'expense' => l10n.transactionsTypeExpense,
    'transfer' => l10n.transactionsTypeTransfer,
    _ => type,
  };
}

/// Returns an icon for a transaction type.
IconData iconForTransactionType(String type) {
  return switch (type) {
    'income' => Icons.arrow_downward_outlined,
    'expense' => Icons.arrow_upward_outlined,
    'transfer' => Icons.swap_horiz_outlined,
    _ => Icons.receipt_long_outlined,
  };
}

/// Returns a color for a transaction type.
Color colorForTransactionType(String type, ColorScheme colorScheme) {
  return switch (type) {
    'income' => AppColors.income,
    'expense' => colorScheme.error,
    'transfer' => colorScheme.tertiary,
    _ => colorScheme.onSurface,
  };
}

/// Formats a date for display in date group headers.
String formatDateHeader(DateTime date, AppLocalizations l10n) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateOnly = DateTime(date.year, date.month, date.day);

  if (dateOnly == today) return l10n.transactionsToday;
  if (dateOnly == yesterday) return l10n.transactionsYesterday;
  if (date.year == now.year) return DateFormat.MMMd().format(date);
  return DateFormat.yMMMd().format(date);
}

/// Formats a date for display in transaction tiles.
String formatTransactionDate(DateTime date) {
  return DateFormat.MMMd().format(date);
}
