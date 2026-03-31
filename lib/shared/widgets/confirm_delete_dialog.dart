import 'package:envelope/shared/widgets/adaptive_dialog.dart';
import 'package:flutter/material.dart';

/// Shows a platform-adaptive confirmation dialog for destructive actions.
///
/// Returns `true` if the user confirmed, `false` or `null` if cancelled.
Future<bool?> showConfirmDeleteDialog(
  BuildContext context, {
  required String title,
  required String message,
  String cancelLabel = 'Cancel',
  String confirmLabel = 'Delete',
}) {
  return showAdaptiveConfirmDialog(
    context,
    title: title,
    message: message,
    cancelLabel: cancelLabel,
    confirmLabel: confirmLabel,
    isDestructive: true,
  );
}
