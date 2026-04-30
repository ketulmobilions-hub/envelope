import 'package:account_repository/account_repository.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:flutter/material.dart';

/// A list tile for displaying an account summary.
class AccountListTile extends StatelessWidget {
  const AccountListTile({
    required this.account,
    required this.onTap,
    super.key,
  });

  final Account account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: account.isArchived
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          iconForAccountType(account.type),
          color: account.isArchived
              ? Theme.of(context).colorScheme.outline
              : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        account.name,
        style: account.isArchived
            ? TextStyle(color: Theme.of(context).colorScheme.outline)
            : null,
      ),
      subtitle: Text(
        account.isOnBudget
            ? formatCents(account.currentBalance, symbol: symbol)
            : '${formatCents(account.currentBalance, symbol: symbol)}'
                  ' · ${l10n.accountsOffBudgetIndicator}',
        style: TextStyle(
          color: account.currentBalance < 0
              ? Theme.of(context).colorScheme.error
              : null,
        ),
      ),
      onTap: onTap,
    );
  }
}
