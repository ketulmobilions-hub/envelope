import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/recurring/widgets/frequency_label.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Displays a bill reminder with name, due day, frequency,
/// estimated amount, and "Pay" action.
class BillReminderListTile extends StatelessWidget {
  const BillReminderListTile({
    required this.reminder,
    this.onTap,
    this.onDelete,
    this.onPay,
    super.key,
  });

  final BillReminder reminder;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onPay;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key('bill_reminder_${reminder.id}'),
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
        leading: const Icon(Icons.receipt_outlined),
        title: Text(reminder.name),
        subtitle: Text(
          '${localizedFrequency(reminder.frequency, l10n)} '
          '${l10n.recurringDueDay(reminder.dueDay)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatCents(reminder.estimatedAmount),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: onPay,
              child: Text(l10n.recurringPayNow),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

}
