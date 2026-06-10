import 'dart:async';

import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/budget/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Page that provides [BudgetBloc] and displays the budget allocation screen.
class BudgetPage extends StatelessWidget {
  const BudgetPage({
    required this.budgetId,
    super.key,
  });

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
        now: context.read<AppClock>().now,
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
          BudgetError.periodFailed => l10n.budgetErrorPeriodFailed,
        };
        showAppSnackBar(context, SnackBar(content: Text(message)));
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final hasDirty = context
              .read<BudgetBloc>()
              .state
              .localAllocations
              .isNotEmpty;
          if (!hasDirty) {
            Navigator.of(context).pop();
            return;
          }
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.budgetUnsavedChangesTitle),
              content: Text(l10n.budgetUnsavedChangesMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.settingsCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(l10n.budgetDiscardChanges),
                ),
              ],
            ),
          );
          if (confirmed == true && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<BudgetBloc, BudgetState>(
            buildWhen: (prev, curr) =>
                prev.localAllocations.isEmpty != curr.localAllocations.isEmpty,
            builder: (context, state) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.budgetTitle),
                  if (state.localAllocations.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          actions: [
            BlocBuilder<BudgetBloc, BudgetState>(
              buildWhen: (prev, curr) {
                return prev.localAllocations.isEmpty !=
                    curr.localAllocations.isEmpty;
              },
              builder: (context, state) {
                if (state.localAllocations.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: FilledButton(
                    onPressed: () => context.read<BudgetBloc>().add(
                      const AllocationsSaveRequested(),
                    ),
                    child: Text(l10n.budgetSaveAllocations),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () => unawaited(showBudgetActionsMenu(context)),
              icon: const Icon(Icons.tune_outlined),
              tooltip: l10n.budgetActionsTooltip,
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<BudgetBloc, BudgetState>(
          buildWhen: (prev, curr) =>
              (prev.allocations.length >= 2) != (curr.allocations.length >= 2),
          builder: (context, state) {
            if (state.allocations.length < 2) return const SizedBox.shrink();
            return FloatingActionButton(
              onPressed: () => unawaited(
                showTransferDialog(
                  context,
                  allocations: context.read<BudgetBloc>().state.allocations,
                  envelopes: context.read<BudgetBloc>().state.envelopes,
                ),
              ),
              tooltip: l10n.budgetTransferBetweenEnvelopes,
              child: const Icon(Icons.swap_horiz),
            );
          },
        ),
        body: BlocBuilder<BudgetBloc, BudgetState>(
          builder: (context, state) {
            if (state.status == BudgetStatus.loading ||
                state.status == BudgetStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.periods.isEmpty) {
              return _EmptyState(budgetId: widget.budgetId);
            }

            return Column(
              children: [
                const PeriodSelector(),
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
