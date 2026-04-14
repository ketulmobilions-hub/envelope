import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/transactions/bloc/bloc.dart';
import 'package:flutter/material.dart';

/// A horizontal row of [FilterChip]s for transaction filtering.
class TransactionFilterBar extends StatelessWidget {
  const TransactionFilterBar({
    required this.filter,
    required this.onFilterChanged,
    super.key,
  });

  final TransactionsFilter filter;
  final ValueChanged<TransactionsFilter> onFilterChanged;

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
          if (filter.isActive) ...[
            const SizedBox(width: 8),
            ActionChip(
              label: Text(l10n.transactionsClearFilters),
              onPressed: () =>
                  onFilterChanged(const TransactionsFilter()),
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
