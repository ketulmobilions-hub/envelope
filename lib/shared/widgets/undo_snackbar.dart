import 'package:flutter/material.dart';

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
          onPressed: onUndo,
        ),
      ),
    );
}
