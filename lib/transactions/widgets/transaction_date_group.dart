import 'package:account_repository/account_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/transactions/widgets/timeline_date_header.dart';
import 'package:envelope/transactions/widgets/timeline_transaction_tile.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// A date header followed by a group of transactions for that date.
///
/// Uses the timeline layout with vertical line and circle bullets.
class TransactionDateGroup extends StatelessWidget {
  const TransactionDateGroup({
    required this.date,
    required this.transactions,
    this.allTransactions = const [],
    this.accounts = const [],
    this.envelopes = const [],
    this.splitEnvelopeIds = const {},
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
    super.key,
  });

  final DateTime date;
  final List<Transaction> transactions;
  final List<Transaction> allTransactions;
  final List<Account> accounts;
  final List<Envelope> envelopes;
  final Map<String, List<String>> splitEnvelopeIds;
  final ValueChanged<Transaction>? onTap;
  final ValueChanged<Transaction>? onEdit;
  final ValueChanged<Transaction>? onDelete;
  final ValueChanged<Transaction>? onDuplicate;

  @override
  Widget build(BuildContext context) {
    // Select narrowly so the group only rebuilds when base currency changes,
    // not on every AuthBloc emission (token refresh, profile update).
    final baseCurrency = context.select<AuthBloc, String>(
      (b) => b.state.user?.baseCurrency ?? 'USD',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TimelineDateHeader(date: date),
        for (var i = 0; i < transactions.length; i++)
          TimelineTransactionTile(
            transaction: transactions[i],
            baseCurrency: baseCurrency,
            isLast: i == transactions.length - 1,
            transferLabel: _transferLabel(transactions[i]),
            envelopeName: _envelopeName(transactions[i]),
            splitEnvelopeNames: _splitEnvelopeNames(transactions[i]),
            onTap: () => onTap?.call(transactions[i]),
            onEdit: () => onEdit?.call(transactions[i]),
            onDelete: () => onDelete?.call(transactions[i]),
            onDuplicate: () => onDuplicate?.call(transactions[i]),
          ),
      ],
    );
  }

  String? _envelopeName(Transaction txn) {
    if (txn.envelopeId == null) return null;
    return envelopes.where((e) => e.id == txn.envelopeId).firstOrNull?.name;
  }

  List<String>? _splitEnvelopeNames(Transaction txn) {
    final ids = splitEnvelopeIds[txn.id];
    if (ids == null || ids.isEmpty) return null;
    final names = ids
        .map((id) => envelopes.where((e) => e.id == id).firstOrNull?.name)
        .whereType<String>()
        .toList();
    return names.isEmpty ? null : names;
  }

  String? _transferLabel(Transaction txn) {
    if (txn.type != 'transfer' || txn.transferPairId == null) return null;
    final fromName = accounts
        .where((a) => a.id == txn.accountId)
        .firstOrNull
        ?.name;
    final paired = allTransactions
        .where(
          (t) => t.transferPairId == txn.transferPairId && t.id != txn.id,
        )
        .firstOrNull;
    final toName = paired == null
        ? null
        : accounts.where((a) => a.id == paired.accountId).firstOrNull?.name;
    if (fromName == null || toName == null) return null;
    return '$fromName → $toName';
  }
}
