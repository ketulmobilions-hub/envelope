import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/goals/cubit/cubit.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/goals/view/goal_form_page.dart';
import 'package:envelope/goals/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_repository/goal_repository.dart';

/// Detail page for a single goal showing progress and info.
///
/// Expects a [GoalDetailCubit] to be provided above this widget.
class GoalDetailPage extends StatelessWidget {
  const GoalDetailPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<GoalDetailCubit, GoalDetailState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == GoalDetailStatus.completed) {
          showAppSnackBar(
            context,
            SnackBar(
              content: Text(
                state.goal.isCompleted
                    ? l10n.goalsMarkedComplete
                    : l10n.goalsMarkedIncomplete,
              ),
            ),
          );
        } else if (state.status == GoalDetailStatus.deleted) {
          Navigator.of(context).pop();
        } else if (state.status == GoalDetailStatus.failure) {
          showAppSnackBar(
            context,
            SnackBar(
              content: Text(
                state.errorMessage ?? l10n.goalsErrorUpdateFailed,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final goal = state.goal;
        final progress = goalProgress(goal);
        final monthly = monthlyContributionNeeded(goal);
        final symbol = currencySymbol(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(goal.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: l10n.goalsEditGoal,
                onPressed: () => _openEdit(context, goal),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Progress card.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        l10n.goalsProgress,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GoalProgressBar(progress: progress),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _AmountDetail(
                            label: l10n.goalsCurrentAmount,
                            amount: goal.currentAmount,
                          ),
                          if (goal.targetAmount != null)
                            _AmountDetail(
                              label: l10n.goalsTargetAmount,
                              amount: goal.targetAmount!,
                            ),
                        ],
                      ),
                      if (monthly > 0 && !goal.isCompleted) ...[
                        const SizedBox(height: 12),
                        Text(
                          '${l10n.goalsMonthlyNeeded}: ${formatCents(monthly, symbol: symbol)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Info card.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(
                        label: l10n.goalsTypeLabel,
                        value: localizedGoalType(goal.type, l10n),
                      ),
                      if (goal.targetDate != null) ...[
                        const Divider(),
                        _InfoRow(
                          label: l10n.goalsTargetDateLabel,
                          value:
                              '${goal.targetDate!.month.toString().padLeft(2, '0')}/'
                              '${goal.targetDate!.day.toString().padLeft(2, '0')}/'
                              '${goal.targetDate!.year}',
                        ),
                      ],
                      if (goal.monthlyContribution != null) ...[
                        const Divider(),
                        _InfoRow(
                          label: l10n.goalsMonthlyContributionLabel,
                          value: formatCents(
                            goal.monthlyContribution!,
                            symbol: symbol,
                          ),
                        ),
                      ],
                      if (goal.isCompleted) ...[
                        const Divider(),
                        _InfoRow(
                          label: l10n.goalsStatusLabel,
                          value: l10n.goalsCompleted,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Contributions history card.
              _ContributionsCard(
                contributions: state.contributions,
                onDelete: (c) => _confirmDeleteContribution(context, c),
              ),
              const SizedBox(height: 16),
              // Add Contribution button.
              FilledButton.icon(
                onPressed:
                    state.status == GoalDetailStatus.submitting ||
                        goal.isCompleted
                    ? null
                    : () => _showAddContribution(context),
                icon: const Icon(Icons.add),
                label: Text(l10n.goalsAddContribution),
              ),
              const SizedBox(height: 8),
              // Complete/Uncomplete button.
              OutlinedButton.icon(
                onPressed: state.status == GoalDetailStatus.submitting
                    ? null
                    : () => context.read<GoalDetailCubit>().toggleComplete(),
                icon: Icon(
                  goal.isCompleted
                      ? Icons.undo_outlined
                      : Icons.check_circle_outline,
                ),
                label: Text(
                  goal.isCompleted ? l10n.goalsUncomplete : l10n.goalsComplete,
                ),
              ),
              const SizedBox(height: 8),
              // Delete button.
              OutlinedButton.icon(
                onPressed: state.status == GoalDetailStatus.submitting
                    ? null
                    : () => _confirmDelete(context, goal),
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                label: Text(
                  l10n.goalsDelete,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteContribution(
    BuildContext context,
    GoalContribution contribution,
  ) async {
    final l10n = context.l10n;
    final cubit = context.read<GoalDetailCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.goalsDeleteContributionTitle),
        content: Text(l10n.goalsDeleteContributionMessage),
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
      await cubit.deleteContribution(contribution);
    }
  }

  Future<void> _showAddContribution(BuildContext context) async {
    final l10n = context.l10n;
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    final cubit = context.read<GoalDetailCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.goalsAddContribution),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: l10n.goalsContributionAmountLabel,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            autofocus: true,
            validator: (value) {
              final cents = parseCents(value ?? '');
              if (cents == null || cents <= 0) {
                return l10n.goalsContributionAmountRequired;
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.goalsCancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(dialogContext).pop(true);
              }
            },
            child: Text(l10n.goalsAdd),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await cubit.addContribution(parseCents(controller.text)!);
    }
    controller.dispose();
  }

  Future<void> _openEdit(BuildContext context, Goal goal) async {
    final cubit = context.read<GoalDetailCubit>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => GoalFormCubit(
            goalRepository: context.read<GoalRepository>(),
            budgetId: budgetId,
            goal: goal,
          ),
          child: GoalFormPage(goal: goal),
        ),
      ),
    );
    if (result == true && context.mounted) {
      await cubit.refresh();
    }
  }

  Future<void> _confirmDelete(BuildContext context, Goal goal) async {
    final l10n = context.l10n;
    final cubit = context.read<GoalDetailCubit>();
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
      await cubit.delete();
    }
  }
}

class _AmountDetail extends StatelessWidget {
  const _AmountDetail({required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final symbol = currencySymbol(context);
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatCents(amount, symbol: symbol),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _ContributionsCard extends StatelessWidget {
  const _ContributionsCard({
    required this.contributions,
    required this.onDelete,
  });

  final List<GoalContribution> contributions;
  final void Function(GoalContribution) onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.goalsContributionsTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            if (contributions.isEmpty) ...[
              const SizedBox(height: 12),
              Text(
                l10n.goalsNoContributions,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ] else
              for (final c in contributions) ...[
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '+${formatCents(c.amountCents, symbol: symbol)}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (c.note != null && c.note!.isNotEmpty)
                            Text(
                              c.note!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      _formatDate(c.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      onPressed: () => onDelete(c),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
