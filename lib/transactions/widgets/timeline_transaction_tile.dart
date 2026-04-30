import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// A timeline-styled transaction tile with vertical line and circle bullet.
///
/// Keeps swipe-to-dismiss behavior from [TransactionListTile].
class TimelineTransactionTile extends StatelessWidget {
  const TimelineTransactionTile({
    required this.transaction,
    this.isLast = false,
    this.transferLabel,
    this.envelopeName,
    this.splitEnvelopeNames,
    this.onTap,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final Transaction transaction;
  final bool isLast;
  final String? transferLabel;
  final String? envelopeName;
  final List<String>? splitEnvelopeNames;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final symbol = currencySymbol(context);
    final typeColor = colorForTransactionType(transaction.type, colorScheme);
    final l10n = context.l10n;

    return Dismissible(
      key: ValueKey(transaction.id),
      background: Container(
        color: colorScheme.primaryContainer,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: Icon(Icons.edit, color: colorScheme.onPrimaryContainer),
      ),
      secondaryBackground: Container(
        color: colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: colorScheme.onErrorContainer),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
          return false;
        }
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.transactionsDeleteConfirmTitle),
            content: Text(l10n.transactionsDeleteConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.transactionsCancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.error,
                ),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.transactionsDelete),
              ),
            ],
          ),
        ).then((v) => v ?? false);
      },
      onDismissed: (_) => onDelete?.call(),
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline column: line + dot.
              SizedBox(
                width: 48,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 2,
                        color: AppColors.divider,
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: typeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: isLast ? 0 : 2,
                        color: isLast ? Colors.transparent : AppColors.divider,
                      ),
                    ),
                  ],
                ),
              ),
              // Content.
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              splitEnvelopeNames != null
                                  ? (transaction.payee?.isNotEmpty == true
                                        ? transaction.payee!
                                        : localizedTransactionType(
                                            transaction.type,
                                            l10n,
                                          ))
                                  : (envelopeName ??
                                        (transaction.payee?.isNotEmpty == true
                                            ? transaction.payee!
                                            : localizedTransactionType(
                                                transaction.type,
                                                l10n,
                                              ))),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (transferLabel != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.swap_horiz,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 2),
                                  Flexible(
                                    child: Text(
                                      transferLabel!,
                                      style: theme.textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else if (splitEnvelopeNames != null)
                              Text(
                                splitEnvelopeNames!.join(' · '),
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            else if (transaction.payee?.isNotEmpty == true)
                              Text(
                                transaction.payee!,
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            else if (transaction.notes?.isNotEmpty == true)
                              Text(
                                transaction.notes!,
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formattedAmount(symbol),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: typeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  String _formattedAmount(String symbol) {
    final prefix = transaction.type == 'income' ? '+' : '';
    return '$prefix${formatCents(transaction.amount, symbol: symbol)}';
  }
}
