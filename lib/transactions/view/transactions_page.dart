import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/transactions/bloc/bloc.dart';
import 'package:envelope/transactions/view/quick_add_transaction_sheet.dart';
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
        accountRepository: context.read<AccountRepository>(),
        envelopeRepository: context.read<EnvelopeRepository>(),
        budgetRepository: context.read<BudgetRepository>(),
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
          TransactionsError.loadFailed => l10n.transactionsErrorLoadFailed,
          TransactionsError.deleteFailed => l10n.transactionsErrorDeleteFailed,
          TransactionsError.undoFailed => l10n.transactionsErrorUndoFailed,
        };
        showAppSnackBar(context, SnackBar(content: Text(message)));
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
                              (s) => s.status == TransactionsStatus.loaded,
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
    final budgetRepository = context.read<BudgetRepository>();
    final appClock = context.read<AppClock>();
    final periodId = await _getCurrentPeriodId(
      budgetRepository,
      budgetId,
      now: appClock.now(),
    );
    if (!context.mounted) return;
    final result = await showTransactionFormSheet(
      context,
      budgetId: budgetId,
      budgetPeriodId: periodId,
      userId: context.read<AuthBloc>().state.user?.id ?? '',
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
            textAlign: TextAlign.center,
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
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        for (final date in sortedDates)
          TransactionDateGroup(
            date: date,
            transactions: grouped[date]!,
            allTransactions: state.transactions,
            accounts: state.accounts,
            envelopes: state.envelopes,
            splitEnvelopeIds: state.splitEnvelopeIds,
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
    final budgetRepository = context.read<BudgetRepository>();
    final appClock = context.read<AppClock>();
    final periodId = await _getCurrentPeriodId(
      budgetRepository,
      budgetId,
      now: appClock.now(),
    );
    if (!context.mounted) return;
    final result = await showTransactionFormSheet(
      context,
      budgetId: budgetId,
      budgetPeriodId: periodId,
      userId: transaction.createdBy,
      transaction: transaction,
    );
    if (result == true && context.mounted) {
      bloc.add(const TransactionsRefreshRequested());
    }
  }

  void _onDelete(BuildContext context, Transaction transaction) {
    final l10n = context.l10n;
    final bloc = context.read<TransactionsBloc>()
      ..add(TransactionDeleted(transaction.id));

    showUndoSnackBar(
      context,
      message: l10n.transactionsDeleted,
      undoLabel: l10n.transactionsUndo,
      onUndo: () => bloc.add(const TransactionUndoDeleteRequested()),
    );
  }
}

/// Resolves the current (open) budget period ID.
Future<String?> _getCurrentPeriodId(
  BudgetRepository budgetRepository,
  String budgetId, {
  DateTime? now,
}) async {
  try {
    final periods = await budgetRepository.watchBudgetPeriods(budgetId).first;
    if (periods.isEmpty) return null;
    final effectiveNow = now ?? DateTime.now();
    final current = periods.firstWhere(
      (p) =>
          !p.isClosed &&
          !p.startDate.isAfter(effectiveNow) &&
          !p.endDate.isBefore(effectiveNow),
      orElse: () =>
          periods.where((p) => !p.isClosed).lastOrNull ?? periods.last,
    );
    return current.id;
  } on Exception {
    return null;
  }
}
