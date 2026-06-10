import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// A dismissible list tile for a single transaction.
///
/// Swipe right to edit, swipe left to delete.
class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    required this.transaction,
    this.onTap,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final baseCurrency =
        context.watch<AuthBloc>().state.user?.baseCurrency ?? 'USD';
    final txSymbol = currencySymbolFromCode(transaction.currency);
    final baseSymbol = currencySymbolFromCode(baseCurrency);
    final isForeign = transaction.currency != baseCurrency;
    final typeColor = colorForTransactionType(transaction.type, colorScheme);

    return Dismissible(
      key: ValueKey(transaction.id),
      background: Container(
        color: colorScheme.primaryContainer,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: Icon(Icons.edit, color: colorScheme.onPrimaryContainer),
      ),
      secondaryBackground: Container(
        color: colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: colorScheme.onErrorContainer),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
          return false;
        }
        return true;
      },
      onDismissed: (_) => onDelete?.call(),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: typeColor.withValues(alpha: 0.1),
          child: Icon(
            iconForTransactionType(transaction.type),
            color: typeColor,
            size: 20,
          ),
        ),
        title: Text(
          transaction.payee?.isNotEmpty == true
              ? transaction.payee!
              : localizedTransactionType(transaction.type, l10n),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: transaction.notes?.isNotEmpty == true
            ? Text(
                transaction.notes!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formattedAmount(txSymbol),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: typeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isForeign)
              Text(
                '≈ ${formatCents(
                  effectiveBaseCurrencyAmount(transaction),
                  symbol: baseSymbol,
                )}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formattedAmount(String symbol) {
    final prefix = switch (transaction.type) {
      'income' => '+',
      'expense' => '−',
      _ => '',
    };
    return '$prefix${formatCents(transaction.amount, symbol: symbol)}';
  }
}
