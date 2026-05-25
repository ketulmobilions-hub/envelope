import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/transactions/bloc/bloc.dart';
import 'package:flutter/material.dart';

/// A horizontal row of [FilterChip]s for transaction filtering.
class TransactionFilterBar extends StatelessWidget {
  const TransactionFilterBar({
    required this.filter,
    required this.onFilterChanged,
    this.accounts = const [],
    super.key,
  });

  final TransactionsFilter filter;
  final ValueChanged<TransactionsFilter> onFilterChanged;

  /// Accounts available to filter by. When empty the account chip is hidden.
  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _TypeChip(
            label: l10n.transactionsTypeIncome,
            isSelected: filter.type == 'income',
            onSelected: (selected) => onFilterChanged(
              filter.copyWith(type: selected ? 'income' : null),
            ),
          ),
          const SizedBox(width: 8),
          _TypeChip(
            label: l10n.transactionsTypeExpense,
            isSelected: filter.type == 'expense',
            onSelected: (selected) => onFilterChanged(
              filter.copyWith(type: selected ? 'expense' : null),
            ),
          ),
          const SizedBox(width: 8),
          _TypeChip(
            label: l10n.transactionsTypeTransfer,
            isSelected: filter.type == 'transfer',
            onSelected: (selected) => onFilterChanged(
              filter.copyWith(type: selected ? 'transfer' : null),
            ),
          ),
          if (accounts.isNotEmpty) ...[
            const SizedBox(width: 8),
            _AccountChip(
              accounts: accounts,
              filter: filter,
              onFilterChanged: onFilterChanged,
            ),
          ],
          if (filter.isActive) ...[
            const SizedBox(width: 8),
            ActionChip(
              label: Text(l10n.transactionsClearFilters),
              onPressed: () => onFilterChanged(const TransactionsFilter()),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(
        label,
        style: isSelected
            ? TextStyle(color: colorScheme.onPrimaryContainer)
            : null,
      ),
      selected: isSelected,
      selectedColor: colorScheme.primaryContainer,
      onSelected: onSelected,
    );
  }
}

/// Chip showing the selected account (or the generic "Account" label). Tapping
/// opens a bottom sheet to pick an account or clear the filter.
class _AccountChip extends StatelessWidget {
  const _AccountChip({
    required this.accounts,
    required this.filter,
    required this.onFilterChanged,
  });

  final List<Account> accounts;
  final TransactionsFilter filter;
  final ValueChanged<TransactionsFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final selectedId = filter.accountId;
    final isSelected = selectedId != null;
    final selectedName = accounts
        .where((a) => a.id == selectedId)
        .map((a) => a.name)
        .firstOrNull;

    // Unselected → generic label. Selected but account missing (deleted) →
    // a distinct label so the highlighted chip isn't mistaken for "no filter".
    final String label;
    if (!isSelected) {
      label = l10n.transactionsAccountLabel;
    } else {
      label = selectedName ?? l10n.transactionsUnknownAccount;
    }

    return FilterChip(
      showCheckmark: false,
      avatar: Icon(
        Icons.account_balance_wallet_outlined,
        size: 18,
        color: isSelected ? colorScheme.onPrimaryContainer : null,
      ),
      label: Text(
        label,
        style: isSelected
            ? TextStyle(color: colorScheme.onPrimaryContainer)
            : null,
      ),
      selected: isSelected,
      selectedColor: colorScheme.primaryContainer,
      onSelected: (_) => unawaited(_openPicker(context)),
    );
  }

  Future<void> _openPicker(BuildContext context) {
    final l10n = context.l10n;
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  l10n.transactionsFilterByAccount,
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: Text(l10n.transactionsAllAccounts),
                      selected: filter.accountId == null,
                      leading: const Icon(Icons.clear_all),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        onFilterChanged(filter.copyWith(accountId: null));
                      },
                    ),
                    for (final account in accounts)
                      ListTile(
                        title: Text(account.name),
                        selected: filter.accountId == account.id,
                        leading: const Icon(
                          Icons.account_balance_wallet_outlined,
                        ),
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          onFilterChanged(
                            filter.copyWith(accountId: account.id),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
