import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/recurring/widgets/frequency_label.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Displays a recurring rule with type icon, payee, frequency,
/// next occurrence, amount, and paused badge.
class RecurringRuleListTile extends StatelessWidget {
  const RecurringRuleListTile({
    required this.rule,
    this.onTap,
    this.onDelete,
    this.onPauseToggle,
    super.key,
  });

  final RecurringRule rule;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onPauseToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final typeColor = colorForTransactionType(rule.type, colorScheme);
    final nextDate = DateFormat.MMMd().format(rule.nextOccurrence);

    return Dismissible(
      key: Key('recurring_rule_${rule.id}'),
      background: Container(
        color: colorScheme.primary,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          onDelete?.call();
          return false;
        }
        if (direction == DismissDirection.startToEnd) {
          onTap?.call();
          return false;
        }
        return false;
      },
      child: ListTile(
        leading: Icon(
          iconForTransactionType(rule.type),
          color: typeColor,
        ),
        title: Text(
          rule.payee ?? localizedTransactionType(rule.type, l10n),
        ),
        subtitle: Text(
          '${localizedFrequency(rule.frequency, l10n)} '
          '${l10n.recurringNextOccurrence(nextDate)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatCents(rule.amount),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: typeColor,
                  ),
            ),
            if (onPauseToggle != null) ...[
              const SizedBox(width: 4),
              IconButton(
                tooltip: rule.isPaused
                    ? l10n.recurringResume
                    : l10n.recurringPause,
                icon: Icon(
                  rule.isPaused
                      ? Icons.play_circle_outline
                      : Icons.pause_circle_outline,
                  color: rule.isPaused
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
                onPressed: onPauseToggle,
              ),
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }

}
