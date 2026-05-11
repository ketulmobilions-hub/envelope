import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/goals/bloc/bloc.dart';
import 'package:envelope/goals/cubit/cubit.dart';
import 'package:envelope/goals/view/goal_detail_page.dart';
import 'package:envelope/goals/view/goal_form_page.dart';
import 'package:envelope/goals/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/adaptive_dialog.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Page that provides [GoalsBloc] + [AutoAssignCubit] and displays the
/// goals list.
class GoalsPage extends StatelessWidget {
  const GoalsPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GoalsBloc(
            goalRepository: context.read<GoalRepository>(),
            envelopeRepository: context.read<EnvelopeRepository>(),
            transactionRepository: context.read<TransactionRepository>(),
            budgetId: budgetId,
          )..add(const GoalsStarted()),
        ),
        BlocProvider(
          create: (_) => AutoAssignCubit(
            budgetRepository: context.read<BudgetRepository>(),
            envelopeRepository: context.read<EnvelopeRepository>(),
            goalRepository: context.read<GoalRepository>(),
            budgetId: budgetId,
          ),
        ),
      ],
      child: GoalsView(budgetId: budgetId),
    );
  }
}

class GoalsView extends StatelessWidget {
  const GoalsView({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<GoalsBloc, GoalsState>(
          listenWhen: (prev, curr) =>
              curr.status == GoalsStatus.error && curr.error != null,
          listener: (context, state) {
            final message = switch (state.error!) {
              GoalsError.loadFailed => l10n.goalsErrorLoadFailed,
              GoalsError.updateFailed => l10n.goalsErrorUpdateFailed,
              GoalsError.deleteFailed => l10n.goalsErrorDeleteFailed,
            };
            showAppSnackBar(context, SnackBar(content: Text(message)));
          },
        ),
        BlocListener<AutoAssignCubit, AutoAssignState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: _handleAutoAssignTransition,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.goalsTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.auto_awesome),
              tooltip: l10n.autoAssignButton,
              onPressed: () => context.read<AutoAssignCubit>().plan(),
            ),
            IconButton(
              onPressed: () => _openAddGoal(context),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: BlocBuilder<GoalsBloc, GoalsState>(
          builder: (context, state) {
            if (state.status == GoalsStatus.loading ||
                state.status == GoalsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.goals.isEmpty) {
              return _EmptyState(onAdd: () => _openAddGoal(context));
            }

            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<GoalsBloc>()
                  ..add(const GoalsRefreshRequested());
                await bloc.stream.firstWhere(
                  (s) => s.status != GoalsStatus.refreshing,
                );
              },
              child: _GoalsList(
                state: state,
                budgetId: budgetId,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleAutoAssignTransition(
    BuildContext context,
    AutoAssignState state,
  ) async {
    final l10n = context.l10n;
    final cubit = context.read<AutoAssignCubit>();
    switch (state.status) {
      case AutoAssignStatus.preview:
        final symbol = currencySymbol(context);
        final confirmed = await showAdaptiveConfirmDialog(
          context,
          title: l10n.autoAssignPreviewTitle,
          message: l10n.autoAssignPreviewBody(
            state.actions.length,
            formatCents(state.totalAllocatedCents, symbol: symbol),
          ),
          confirmLabel: l10n.autoAssignConfirm,
        );
        if (confirmed == true) {
          await cubit.apply();
        } else {
          cubit.reset();
        }
      case AutoAssignStatus.success:
        showAppSnackBar(
          context,
          SnackBar(content: Text(l10n.autoAssignSuccess)),
        );
        cubit.reset();
      case AutoAssignStatus.noTargets:
        showAppSnackBar(
          context,
          SnackBar(content: Text(l10n.autoAssignNoTargets)),
        );
        cubit.reset();
      case AutoAssignStatus.insufficientRta:
        showAppSnackBar(
          context,
          SnackBar(content: Text(l10n.autoAssignInsufficientRta)),
        );
        cubit.reset();
      case AutoAssignStatus.failure:
        showAppSnackBar(
          context,
          SnackBar(
            content: Text(state.errorMessage ?? l10n.autoAssignFailure),
          ),
        );
        cubit.reset();
      case AutoAssignStatus.initial:
      case AutoAssignStatus.planning:
      case AutoAssignStatus.applying:
        break;
    }
  }

  Future<void> _openAddGoal(BuildContext context) async {
    final bloc = context.read<GoalsBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => GoalFormCubit(
            goalRepository: context.read<GoalRepository>(),
            envelopeRepository: context.read<EnvelopeRepository>(),
            budgetId: budgetId,
          ),
          child: const GoalFormPage(),
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const GoalsRefreshRequested());
    }
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
            Icons.flag_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.goalsEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.goalsEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(l10n.goalsAddGoal),
          ),
        ],
      ),
    );
  }
}

class _GoalsList extends StatelessWidget {
  const _GoalsList({required this.state, required this.budgetId});

  final GoalsState state;
  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final active = state.activeGoals;
    final completed = state.completedGoals;

    return CustomScrollView(
      slivers: [
        if (active.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                l10n.goalsReorderHint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ),
        if (active.isNotEmpty)
          SliverReorderableList(
            itemCount: active.length,
            onReorder: (oldIndex, newIndex) =>
                _onReorder(context, active, oldIndex, newIndex),
            itemBuilder: (context, index) {
              final goal = active[index];
              return ReorderableDelayedDragStartListener(
                key: ValueKey(goal.id),
                index: index,
                child: GoalListTile(
                  goal: goal,
                  computedAmount: state.computedAmounts[goal.id],
                  onTap: () => _openDetail(context, goal),
                  onEdit: () => _openEdit(context, goal),
                  onComplete: () => context.read<GoalsBloc>().add(
                    GoalCompleteToggled(goal),
                  ),
                  onDelete: () => _confirmDelete(context, goal),
                ),
              );
            },
          ),
        if (completed.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                l10n.goalsCompleted,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: completed.length,
            itemBuilder: (context, index) {
              final goal = completed[index];
              return GoalListTile(
                goal: goal,
                computedAmount: state.computedAmounts[goal.id],
                onTap: () => _openDetail(context, goal),
                onEdit: () => _openEdit(context, goal),
                onComplete: () =>
                    context.read<GoalsBloc>().add(GoalCompleteToggled(goal)),
                onDelete: () => _confirmDelete(context, goal),
              );
            },
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Future<void> _onReorder(
    BuildContext context,
    List<Goal> active,
    int oldIndex,
    int newIndex,
  ) async {
    var newIdx = newIndex;
    if (newIdx > oldIndex) newIdx -= 1;
    final reordered = [...active];
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIdx, moved);
    final l10n = context.l10n;
    try {
      await context.read<GoalRepository>().reorderGoals(
        reordered.map((g) => g.id).toList(),
      );
    } on GoalException {
      if (!context.mounted) return;
      showAppSnackBar(
        context,
        SnackBar(content: Text(l10n.goalsErrorUpdateFailed)),
      );
    }
  }

  Future<void> _openDetail(
    BuildContext context,
    Goal goal,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => GoalDetailCubit(
            goalRepository: context.read<GoalRepository>(),
            envelopeRepository: context.read<EnvelopeRepository>(),
            transactionRepository: context.read<TransactionRepository>(),
            goal: goal,
          ),
          child: GoalDetailPage(budgetId: budgetId),
        ),
      ),
    );
    if (context.mounted) {
      context.read<GoalsBloc>().add(const GoalsRefreshRequested());
    }
  }

  Future<void> _openEdit(
    BuildContext context,
    Goal goal,
  ) async {
    final bloc = context.read<GoalsBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => GoalFormCubit(
            goalRepository: context.read<GoalRepository>(),
            envelopeRepository: context.read<EnvelopeRepository>(),
            budgetId: budgetId,
            goal: goal,
          ),
          child: GoalFormPage(goal: goal),
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const GoalsRefreshRequested());
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Goal goal,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.goalsDeleteConfirmTitle),
        content: Text(l10n.goalsDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.goalsCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.goalsDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<GoalsBloc>().add(GoalDeleted(goal.id));
    }
  }
}

