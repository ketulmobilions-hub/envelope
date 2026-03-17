import 'package:envelope/transactions/widgets/timeline_date_header.dart';
import 'package:envelope/transactions/widgets/timeline_transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// A date header followed by a group of transactions for that date.
///
/// Uses the timeline layout with vertical line and circle bullets.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TimelineDateHeader(date: date),
        for (var i = 0; i < transactions.length; i++)
          TimelineTransactionTile(
            transaction: transactions[i],
            isLast: i == transactions.length - 1,
            onTap: () => onTap?.call(transactions[i]),
            onEdit: () => onEdit?.call(transactions[i]),
            onDelete: () => onDelete?.call(transactions[i]),
          ),
      ],
    );
  }
}
