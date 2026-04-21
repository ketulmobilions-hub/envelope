import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/goals/widgets/goal_helpers.dart';
import 'package:envelope/goals/widgets/goal_progress_bar.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:flutter/material.dart';
import 'package:goal_repository/goal_repository.dart';

/// A list tile for displaying a goal summary.
class GoalListTile extends StatelessWidget {
  const GoalListTile({
    required this.goal,
    required this.onTap,
    required this.onEdit,
    required this.onComplete,
    required this.onDelete,
    super.key,
  });

  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);
    final progress = goalProgress(goal);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: goal.isCompleted
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          iconForGoalType(goal.type),
          color: goal.isCompleted
              ? Theme.of(context).colorScheme.outline
              : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        goal.name,
        style: goal.isCompleted
            ? TextStyle(
                color: Theme.of(context).colorScheme.outline,
                decoration: TextDecoration.lineThrough,
              )
            : null,
      ),
      subtitle: goal.targetAmount != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${formatCents(goal.currentAmount, symbol: symbol)} / '
                  '${formatCents(goal.targetAmount!, symbol: symbol)}',
                ),
                const SizedBox(height: 4),
                GoalProgressBar(progress: progress),
              ],
            )
          : goal.monthlyContribution != null
              ? Text(l10n.goalsPerMonth(
                  formatCents(goal.monthlyContribution!, symbol: symbol),
                ))
              : null,
      isThreeLine: goal.targetAmount != null,
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              onEdit();
            case 'complete':
              onComplete();
            case 'delete':
              onDelete();
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'edit',
            child: Text(l10n.goalsEditGoal),
          ),
          PopupMenuItem(
            value: 'complete',
            child: Text(
              goal.isCompleted ? l10n.goalsUncomplete : l10n.goalsComplete,
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text(
              l10n.goalsDelete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
