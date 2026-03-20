import 'package:envelope/goals/bloc/bloc.dart';
import 'package:envelope/goals/cubit/cubit.dart';
import 'package:envelope/goals/view/goal_detail_page.dart';
import 'package:envelope/goals/view/goal_form_page.dart';
import 'package:envelope/goals/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_repository/goal_repository.dart';

/// Page that provides [GoalsBloc] and displays the goals list.
class GoalsPage extends StatelessWidget {
  const GoalsPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoalsBloc(
        goalRepository: context.read<GoalRepository>(),
        budgetId: budgetId,
      )..add(const GoalsStarted()),
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

    return BlocListener<GoalsBloc, GoalsState>(
      listenWhen: (prev, curr) =>
          curr.status == GoalsStatus.error && curr.error != null,
      listener: (context, state) {
        final message = switch (state.error!) {
          GoalsError.loadFailed => l10n.goalsErrorLoadFailed,
          GoalsError.updateFailed => l10n.goalsErrorUpdateFailed,
          GoalsError.deleteFailed => l10n.goalsErrorDeleteFailed,
        };
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.goalsTitle),
          actions: [
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
                  (s) => s.status == GoalsStatus.loaded,
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

  Future<void> _openAddGoal(BuildContext context) async {
    final bloc = context.read<GoalsBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => GoalFormPage(
          goalRepository: context.read<GoalRepository>(),
          budgetId: budgetId,
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

    // Group active goals by type using state's computed property.
    final grouped = <String, List<Goal>>{};
    for (final goal in active) {
      grouped.putIfAbsent(goal.type, () => []).add(goal);
    }
    final typeOrder = grouped.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        for (final type in typeOrder) ...[
          _TypeHeader(type: type, l10n: l10n),
          for (final goal in grouped[type]!)
            GoalListTile(
              goal: goal,
              onTap: () => _openDetail(context, goal),
              onEdit: () => _openEdit(context, goal),
              onComplete: () => context
                  .read<GoalsBloc>()
                  .add(GoalCompleteToggled(goal)),
              onDelete: () => _confirmDelete(context, goal),
            ),
        ],
        if (completed.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              l10n.goalsCompleted,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          for (final goal in completed)
            GoalListTile(
              goal: goal,
              onTap: () => _openDetail(context, goal),
              onEdit: () => _openEdit(context, goal),
              onComplete: () => context
                  .read<GoalsBloc>()
                  .add(GoalCompleteToggled(goal)),
              onDelete: () => _confirmDelete(context, goal),
            ),
        ],
      ],
    );
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
        builder: (_) => GoalFormPage(
          goalRepository: context.read<GoalRepository>(),
          budgetId: budgetId,
          goal: goal,
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
              backgroundColor:
                  Theme.of(dialogContext).colorScheme.error,
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

class _TypeHeader extends StatelessWidget {
  const _TypeHeader({required this.type, required this.l10n});

  final String type;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        localizedGoalType(type, l10n),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
