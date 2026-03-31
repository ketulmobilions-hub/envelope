import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Shows a platform-adaptive confirmation dialog.
///
/// On iOS, renders as a [CupertinoAlertDialog]. On Android/web, renders
/// as a Material [AlertDialog]. Returns `true` if confirmed, `false` or
/// `null` if cancelled.
Future<bool?> showAdaptiveConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String cancelLabel = 'Cancel',
  String confirmLabel = 'OK',
  bool isDestructive = false,
}) {
  final theme = Theme.of(context);
  final isIOS = theme.platform == TargetPlatform.iOS;

  if (isIOS) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: isDestructive
              ? FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                )
              : null,
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}
