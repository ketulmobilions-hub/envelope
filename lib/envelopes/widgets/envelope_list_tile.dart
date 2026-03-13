import 'package:envelope/l10n/l10n.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';

/// A list tile for displaying an envelope summary.
class EnvelopeListTile extends StatelessWidget {
  const EnvelopeListTile({
    required this.envelope,
    required this.onTap,
    required this.onEdit,
    required this.onArchive,
    required this.onDelete,
    super.key,
  });

  final Envelope envelope;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: envelope.isArchived
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Theme.of(context).colorScheme.secondaryContainer,
        child: Icon(
          Icons.folder_outlined,
          color: envelope.isArchived
              ? Theme.of(context).colorScheme.outline
              : Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(
        envelope.name,
        style: envelope.isArchived
            ? TextStyle(color: Theme.of(context).colorScheme.outline)
            : null,
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              onEdit();
            case 'archive':
              onArchive();
            case 'delete':
              onDelete();
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'edit',
            child: Text(l10n.envelopesEditEnvelope),
          ),
          PopupMenuItem(
            value: 'archive',
            child: Text(
              envelope.isArchived
                  ? l10n.envelopesUnarchive
                  : l10n.envelopesArchive,
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text(
              l10n.envelopesDelete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
