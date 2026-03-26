import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

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

/// Returns whether the given account type should default to on-budget.
///
/// Credit cards and investments are off-budget by default.
/// Handles both camelCase (`'creditCard'`) and snake_case (`'credit_card'`).
bool defaultIsOnBudget(String type) =>
    type != 'credit_card' &&
    type != 'creditCard' &&
    type != 'investment';

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
