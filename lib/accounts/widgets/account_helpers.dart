import 'package:account_repository/account_repository.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Currency lookup helpers on a list of [Account].
extension AccountListCurrency on List<Account> {
  /// Returns the currency of the account whose id matches [accountId],
  /// falling back to [fallback] (default `'USD'`) if no match is found.
  ///
  /// Callers that have a budget context should validate the list is non-empty
  /// before relying on the fallback — an empty accounts list at submit time
  /// usually indicates a load race that should be surfaced as a form error.
  String currencyForAccountId(String? accountId, {String fallback = 'USD'}) {
    if (accountId == null) return fallback;
    return where((a) => a.id == accountId).firstOrNull?.currency ?? fallback;
  }
}

/// Returns the localized display name for an account type.
String localizedAccountType(String type, AppLocalizations l10n) {
  return switch (type) {
    'checking' => l10n.accountsTypeChecking,
    'savings' => l10n.accountsTypeSavings,
    'credit_card' => l10n.accountsTypeCreditCard,
    'cash' => l10n.accountsTypeCash,
    'investment' => l10n.accountsTypeInvestment,
    _ => l10n.accountsTypeOther,
  };
}

/// Returns whether the given account type is a credit card.
///
/// Handles both camelCase (`'creditCard'`) and snake_case (`'credit_card'`).
bool isCreditCard(String type) => type == 'credit_card' || type == 'creditCard';

/// Returns whether the given account type should default to on-budget.
///
/// Credit cards and investments are off-budget by default.
/// Handles both camelCase (`'creditCard'`) and snake_case (`'credit_card'`).
bool defaultIsOnBudget(String type) =>
    !isCreditCard(type) && type != 'investment';

/// Returns the icon for the given account type.
IconData iconForAccountType(String type) {
  return switch (type) {
    'checking' => Icons.account_balance_outlined,
    'savings' => Icons.savings_outlined,
    'credit_card' => Icons.credit_card_outlined,
    'cash' => Icons.money_outlined,
    'investment' => Icons.trending_up_outlined,
    _ => Icons.account_balance_wallet_outlined,
  };
}
