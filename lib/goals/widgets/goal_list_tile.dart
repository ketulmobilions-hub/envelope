import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/goals/widgets/goal_helpers.dart';
import 'package:envelope/goals/widgets/goal_progress_bar.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/services/funding_status_service.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/funding_status_badge.dart';
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
    this.computedAmount,
    super.key,
  });

  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  /// Derived current amount for linked goals; falls back to
  /// [Goal.currentAmount] when null.
  final int? computedAmount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);
    final effectiveAmount = computedAmount ?? goal.currentAmount;
    final progress = goalProgress(
      goal,
      overrideCurrentAmount: effectiveAmount,
    );
    final neededCents = goal.isCompleted
        ? 0
        : monthlyContributionNeeded(
            goal,
            overrideCurrentAmount: effectiveAmount,
          );
    final fundingStatus = _statusForGoal(goal, neededCents: neededCents);

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
      title: Row(
        children: [
          Flexible(
            child: Text(
              goal.name,
              overflow: TextOverflow.ellipsis,
              style: goal.isCompleted
                  ? TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      decoration: TextDecoration.lineThrough,
                    )
                  : null,
            ),
          ),
          if (fundingStatus != FundingStatus.noTarget) ...[
            const SizedBox(width: 8),
            FundingStatusBadge(
              status: fundingStatus,
              amountCents: neededCents,
              symbol: symbol,
            ),
          ],
        ],
      ),
      subtitle: goal.targetAmount != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${formatCents(effectiveAmount, symbol: symbol)} / '
                  '${formatCents(goal.targetAmount!, symbol: symbol)}',
                ),
                const SizedBox(height: 4),
                GoalProgressBar(progress: progress),
              ],
            )
          : goal.monthlyContribution != null
          ? Text(
              l10n.goalsPerMonth(
                formatCents(goal.monthlyContribution!, symbol: symbol),
              ),
            )
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

  /// Maps a goal's monthly shortfall to a [FundingStatus].
  ///
  /// Completed goals and goals without an active monthly target render no
  /// badge. Underfunded goals show the shortfall amount; goals whose monthly
  /// target is already met render as fully funded.
  static FundingStatus _statusForGoal(Goal goal, {required int neededCents}) {
    if (goal.isCompleted) return FundingStatus.noTarget;
    if (neededCents > 0) return FundingStatus.underfunded;
    // No shortfall: either there is no monthly target at all (e.g. unbounded
    // savings goal without a date) or the goal is already fully funded for
    // the period. Distinguish the two using the underlying monthly amount.
    final monthly = monthlyContributionNeeded(goal);
    return monthly > 0 ? FundingStatus.fullyFunded : FundingStatus.noTarget;
  }
}
