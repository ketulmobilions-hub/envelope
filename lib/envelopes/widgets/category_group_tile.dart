import 'package:envelope/envelopes/widgets/envelope_list_tile.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';

/// An expandable tile displaying a category group and its envelopes.
class CategoryGroupTile extends StatelessWidget {
  const CategoryGroupTile({
    required this.categoryGroup,
    required this.envelopes,
    required this.onEditGroup,
    required this.onAddEnvelope,
    required this.onArchiveGroup,
    required this.onDeleteGroup,
    required this.onEnvelopeTap,
    required this.onEditEnvelope,
    required this.onArchiveEnvelope,
    required this.onDeleteEnvelope,
    this.initiallyExpanded = true,
    super.key,
  });

  final CategoryGroup categoryGroup;
  final List<Envelope> envelopes;
  final VoidCallback onEditGroup;
  final VoidCallback onAddEnvelope;
  final VoidCallback onArchiveGroup;
  final VoidCallback onDeleteGroup;
  final void Function(Envelope) onEnvelopeTap;
  final void Function(Envelope) onEditEnvelope;
  final void Function(Envelope) onArchiveEnvelope;
  final void Function(Envelope) onDeleteEnvelope;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        title: Text(
          categoryGroup.name,
          style: theme.textTheme.titleSmall?.copyWith(
            color: categoryGroup.isArchived
                ? theme.colorScheme.outline
                : theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEditGroup();
              case 'add_envelope':
                onAddEnvelope();
              case 'archive':
                onArchiveGroup();
              case 'delete':
                onDeleteGroup();
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'edit',
              child: Text(l10n.envelopesEditCategoryGroup),
            ),
            PopupMenuItem(
              value: 'add_envelope',
              child: Text(l10n.envelopesAddEnvelope),
            ),
            PopupMenuItem(
              value: 'archive',
              child: Text(
                categoryGroup.isArchived
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
        children: [
          if (envelopes.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                l10n.envelopesGroupEmpty,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            )
          else
            for (final envelope in envelopes)
              EnvelopeListTile(
                envelope: envelope,
                onTap: () => onEnvelopeTap(envelope),
                onEdit: () => onEditEnvelope(envelope),
                onArchive: () => onArchiveEnvelope(envelope),
                onDelete: () => onDeleteEnvelope(envelope),
              ),
        ],
      ),
    );
  }
}
