import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:envelope/transactions/widgets/transaction_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// A date header followed by a group of transactions for that date.
class TransactionDateGroup extends StatelessWidget {
  const TransactionDateGroup({
    required this.date,
    required this.transactions,
    this.onTap,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final DateTime date;
  final List<Transaction> transactions;
  final ValueChanged<Transaction>? onTap;
  final ValueChanged<Transaction>? onEdit;
  final ValueChanged<Transaction>? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            formatDateHeader(date, l10n),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        for (final txn in transactions)
          TransactionListTile(
            transaction: txn,
            onTap: () => onTap?.call(txn),
            onEdit: () => onEdit?.call(txn),
            onDelete: () => onDelete?.call(txn),
          ),
      ],
    );
  }
}
