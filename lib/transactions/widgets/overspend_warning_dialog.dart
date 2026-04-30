import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:flutter/material.dart';

/// Shows a warning dialog when a transaction causes an
/// envelope to be overspent.
///
/// Returns `true` if the user wants to cover the overspend,
/// `false` or `null` if dismissed.
Future<bool?> showOverspendWarningDialog(
  BuildContext context, {
  required String envelopeName,
  required int deficitCents,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final l10n = dialogContext.l10n;
      final symbol = currencySymbol(dialogContext);
      final formatted = formatCents(deficitCents.abs(), symbol: symbol);

      return AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(dialogContext).colorScheme.error,
          size: 48,
        ),
        title: Text(l10n.overspendWarningTitle),
        content: Text(
          l10n.overspendWarningMessage(
            envelopeName,
            formatted,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.overspendDismiss),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.overspendCoverButton),
          ),
        ],
      );
    },
  );
}
