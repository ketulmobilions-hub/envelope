import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction_repository/transaction_repository.dart';

// Re-export formatCents/parseCents so callers can import from one place.
export 'package:envelope/accounts/widgets/format_cents.dart';

/// Returns the transaction's amount in the budget's base currency cents.
///
/// Prefers the persisted `baseCurrencyAmount` (set server-side by the
/// BEFORE-INSERT trigger from migration 00029). Falls back to client-side
/// conversion `(amount * exchangeRate).round()` for legacy rows where the
/// column might still be `0`. Same rounding (round-half-away-from-zero)
/// is used by the SQL trigger so client/server stay byte-identical.
int effectiveBaseCurrencyAmount(Transaction t) {
  if (t.baseCurrencyAmount != 0) return t.baseCurrencyAmount;
  return (t.amount * t.exchangeRate).round();
}

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
///
/// [now] overrides "today" so QA can verify Today/Yesterday labels under a
/// simulated clock. Defaults to the real wall clock.
String formatDateHeader(DateTime date, AppLocalizations l10n, {DateTime? now}) {
  final effectiveNow = now ?? DateTime.now();
  final today = DateTime(
    effectiveNow.year,
    effectiveNow.month,
    effectiveNow.day,
  );
  final yesterday = today.subtract(const Duration(days: 1));
  final dateOnly = DateTime(date.year, date.month, date.day);

  if (dateOnly == today) return l10n.transactionsToday;
  if (dateOnly == yesterday) return l10n.transactionsYesterday;
  if (date.year == effectiveNow.year) return DateFormat.MMMd().format(date);
  return DateFormat.yMMMd().format(date);
}

/// Formats a date for display in transaction tiles.
String formatTransactionDate(DateTime date) {
  return DateFormat.MMMd().format(date);
}
