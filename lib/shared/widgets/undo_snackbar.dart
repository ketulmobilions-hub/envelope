import 'package:flutter/material.dart';

/// Shows a [SnackBar], dismissing any currently visible one first.
void showAppSnackBar(BuildContext context, SnackBar snackBar) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

/// Shows a SnackBar with a 5-second undo action.
void showUndoSnackBar(
  BuildContext context, {
  required String message,
  required VoidCallback onUndo,
  String undoLabel = 'Undo',
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: undoLabel,
          textColor: Theme.of(context).colorScheme.onInverseSurface,
          onPressed: onUndo,
        ),
      ),
    );
}
