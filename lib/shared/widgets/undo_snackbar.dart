import 'package:flutter/material.dart';

/// Shows a [SnackBar], clearing any visible or queued snackbars first.
void showAppSnackBar(BuildContext context, SnackBar snackBar) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(snackBar);
}

/// Shows a SnackBar with a 5-second undo action.
///
/// The controller's [close] is called explicitly after the duration as a
/// fallback — on Flutter web the internal dismiss timer can silently fail
/// after animation edge cases.
void showUndoSnackBar(
  BuildContext context, {
  required String message,
  required VoidCallback onUndo,
  String undoLabel = 'Undo',
}) {
  const duration = Duration(seconds: 5);
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  final controller = messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
        label: undoLabel,
        textColor: Theme.of(context).colorScheme.onInverseSurface,
        onPressed: onUndo,
      ),
    ),
  );
  Future.delayed(duration, () {
    try {
      controller.close();
    } catch (_) {
      // Snackbar was already dismissed by Flutter's own timer.
    }
  });
}
