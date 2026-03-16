import 'package:account_repository/account_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/transactions/bloc/bloc.dart';
import 'package:envelope/transactions/view/transaction_form_page.dart';
import 'package:envelope/transactions/view/transaction_search_page.dart';
import 'package:envelope/transactions/widgets/widgets.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Page that provides [TransactionsBloc] and displays the transactions list.
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionsBloc(
        transactionRepository: context.read<TransactionRepository>(),
        budgetId: budgetId,
      )..add(const TransactionsStarted()),
      child: TransactionsView(budgetId: budgetId),
    );
  }
}

class TransactionsView extends StatelessWidget {
  const TransactionsView({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<TransactionsBloc, TransactionsState>(
      listenWhen: (prev, curr) =>
          curr.status == TransactionsStatus.error && curr.error != null,
      listener: (context, state) {
        final message = switch (state.error!) {
          TransactionsError.loadFailed =>
            l10n.transactionsErrorLoadFailed,
          TransactionsError.deleteFailed =>
            l10n.transactionsErrorDeleteFailed,
          TransactionsError.undoFailed =>
            l10n.transactionsErrorUndoFailed,
        };
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.transactionsTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _openSearch(context),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openAddTransaction(context),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<TransactionsBloc, TransactionsState>(
          builder: (context, state) {
            if (state.status == TransactionsStatus.loading ||
                state.status == TransactionsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                TransactionFilterBar(
                  filter: state.filter,
                  onFilterChanged: (filter) => context
                      .read<TransactionsBloc>()
                      .add(TransactionsFilterChanged(filter)),
                ),
                Expanded(
                  child: state.filteredTransactions.isEmpty
                      ? _EmptyState(
                          onAdd: () => _openAddTransaction(context),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            final bloc = context.read<TransactionsBloc>()
                              ..add(const TransactionsRefreshRequested());
                            await bloc.stream.firstWhere(
                              (s) =>
                                  s.status == TransactionsStatus.loaded,
                            );
                          },
                          child: _TransactionsList(
                            state: state,
                            budgetId: budgetId,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openAddTransaction(BuildContext context) async {
    final bloc = context.read<TransactionsBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => TransactionFormPage(
          transactionRepository: context.read<TransactionRepository>(),
          accountRepository: context.read<AccountRepository>(),
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: budgetId,
          userId: context.read<AuthBloc>().state.user?.id ?? '',
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const TransactionsRefreshRequested());
    }
  }

  Future<void> _openSearch(BuildContext context) async {
    final bloc = context.read<TransactionsBloc>();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: TransactionSearchPage(budgetId: budgetId),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.transactionsEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.transactionsEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(l10n.transactionsAddTransaction),
          ),
        ],
      ),
    );
  }
}

class _TransactionsList extends StatelessWidget {
  const _TransactionsList({required this.state, required this.budgetId});

  final TransactionsState state;
  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final grouped = state.transactionsByDate;
    final sortedDates = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        for (final date in sortedDates)
          TransactionDateGroup(
            date: date,
            transactions: grouped[date]!,
            onTap: (txn) => _openEditTransaction(context, txn),
            onEdit: (txn) => _openEditTransaction(context, txn),
            onDelete: (txn) => _onDelete(context, txn),
          ),
      ],
    );
  }

  Future<void> _openEditTransaction(
    BuildContext context,
    Transaction transaction,
  ) async {
    final bloc = context.read<TransactionsBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => TransactionFormPage(
          transactionRepository: context.read<TransactionRepository>(),
          accountRepository: context.read<AccountRepository>(),
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: budgetId,
          userId: transaction.createdBy,
          transaction: transaction,
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const TransactionsRefreshRequested());
    }
  }

  Future<void> _onDelete(
    BuildContext context,
    Transaction transaction,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.transactionsDeleteConfirmTitle),
        content: Text(l10n.transactionsDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.transactionsCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor:
                  Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.transactionsDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final bloc = context.read<TransactionsBloc>()
      ..add(TransactionDeleted(transaction.id));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.transactionsDeleted),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: l10n.transactionsUndo,
            onPressed: () =>
                bloc.add(const TransactionUndoDeleteRequested()),
          ),
        ),
      );
  }
}
