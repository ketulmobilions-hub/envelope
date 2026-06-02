import 'dart:async';

import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/budget/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Page that provides [BudgetBloc] and displays the budget allocation screen.
class BudgetPage extends StatelessWidget {
  const BudgetPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BudgetBloc(
        budgetRepository: context.read<BudgetRepository>(),
        envelopeRepository: context.read<EnvelopeRepository>(),
        goalRepository: context.read<GoalRepository>(),
        transactionRepository: context.read<TransactionRepository>(),
        budgetId: budgetId,
      )..add(const BudgetStarted()),
      child: BudgetView(budgetId: budgetId),
    );
  }
}

class BudgetView extends StatefulWidget {
  const BudgetView({required this.budgetId, super.key});

  final String budgetId;

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<BudgetBloc, BudgetState>(
      listenWhen: (prev, curr) =>
          curr.status == BudgetStatus.error && curr.error != null,
      listener: (context, state) {
        final message = switch (state.error!) {
          BudgetError.loadFailed => l10n.budgetErrorLoadFailed,
          BudgetError.allocationFailed => l10n.budgetErrorAllocationFailed,
          BudgetError.transferFailed => l10n.budgetErrorTransferFailed,
          BudgetError.templateFailed => l10n.budgetErrorTemplateFailed,
        };
        showAppSnackBar(context, SnackBar(content: Text(message)));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.budgetTitle),
          actions: [
            BlocBuilder<BudgetBloc, BudgetState>(
              buildWhen: (prev, curr) {
                final wasEmpty = prev.localAllocations.isEmpty;
                final isEmpty = curr.localAllocations.isEmpty;
                return wasEmpty != isEmpty;
              },
              builder: (context, state) {
                if (state.localAllocations.isEmpty) {
                  return const SizedBox.shrink();
                }
                return TextButton(
                  onPressed: () => context.read<BudgetBloc>().add(
                    const AllocationsSaveRequested(),
                  ),
                  child: Text(l10n.budgetSaveAllocations),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => unawaited(showBudgetActionsMenu(context)),
          child: const Icon(Icons.more_vert),
        ),
        body: BlocBuilder<BudgetBloc, BudgetState>(
          builder: (context, state) {
            if (state.status == BudgetStatus.loading ||
                state.status == BudgetStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.envelopes.isEmpty && state.categoryGroups.isEmpty) {
              return _EmptyState(budgetId: widget.budgetId);
            }

            return Column(
              children: [
                const ReadyToAssignCard(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final bloc = context.read<BudgetBloc>()
                        ..add(const BudgetRefreshRequested());
                      await bloc.stream.firstWhere(
                        (s) => s.status != BudgetStatus.loading,
                      );
                    },
                    child: _AllocationList(state: state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.budgetId});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.budgetNoPeriodsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              l10n.budgetNoPeriodsSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Allocation list ──────────────────────────────────────────────────────────

class _AllocationList extends StatelessWidget {
  const _AllocationList({required this.state});

  final BudgetState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final grouped = state.groupedAllocations;

    if (grouped.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.budgetNoAllocations,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.budgetNoAllocationsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: grouped
          .map(
            (pair) => AllocationGroupTile(
              key: ValueKey(pair.$1.id),
              group: pair.$1,
              envelopesWithAllocations: pair.$2,
              ccPaymentAvailable: state.ccPaymentAvailable,
            ),
          )
          .toList(),
    );
  }
}
