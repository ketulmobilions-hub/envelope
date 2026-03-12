import 'package:account_repository/account_repository.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// A list tile for displaying an account summary.
class AccountListTile extends StatelessWidget {
  const AccountListTile({
    required this.account,
    required this.onTap,
    required this.onArchive,
    required this.onDelete,
    super.key,
  });

  final Account account;
  final VoidCallback onTap;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
        formatCents(account.currentBalance),
        style: TextStyle(
          color: account.currentBalance < 0
              ? Theme.of(context).colorScheme.error
              : null,
        ),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'archive':
              onArchive();
            case 'delete':
              onDelete();
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'archive',
            child: Text(
              account.isArchived
                  ? l10n.accountsUnarchive
                  : l10n.accountsArchive,
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text(
              l10n.accountsDelete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
