import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/transactions/bloc/bloc.dart';
import 'package:envelope/transactions/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Global search page for transactions.
///
/// Filters all transactions by payee, notes, or amount match.
class TransactionSearchPage extends StatefulWidget {
  const TransactionSearchPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  State<TransactionSearchPage> createState() => _TransactionSearchPageState();
}

class _TransactionSearchPageState extends State<TransactionSearchPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.transactionsSearchHint,
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _query = value.trim()),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (_query.isEmpty) {
            return Center(
              child: Text(
                l10n.transactionsSearchEmpty,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            );
          }

          final results = _filterByQuery(
            state.filteredTransactions,
            _query,
            currencySymbol(context),
          );

          if (results.isEmpty) {
            return Center(
              child: Text(
                l10n.transactionsSearchNoResults,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            );
          }

          // Group by date.
          final grouped = <DateTime, List<Transaction>>{};
          for (final txn in results) {
            final dateOnly = DateTime(
              txn.date.year,
              txn.date.month,
              txn.date.day,
            );
            grouped.putIfAbsent(dateOnly, () => []).add(txn);
          }
          final sortedDates = grouped.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              for (final date in sortedDates)
                TransactionDateGroup(
                  date: date,
                  transactions: grouped[date]!,
                  onTap: (_) => Navigator.of(context).pop(),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Transaction> _filterByQuery(
    List<Transaction> transactions,
    String query,
    String symbol,
  ) {
    final lower = query.toLowerCase();
    return transactions.where((txn) {
      final payeeMatch = txn.payee?.toLowerCase().contains(lower) ?? false;
      final notesMatch = txn.notes?.toLowerCase().contains(lower) ?? false;
      final amountMatch = formatCents(
        txn.amount,
        symbol: symbol,
      ).contains(lower);
      return payeeMatch || notesMatch || amountMatch;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }
}
