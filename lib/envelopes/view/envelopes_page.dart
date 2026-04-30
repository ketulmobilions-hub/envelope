import 'dart:async';

import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/envelopes/bloc/bloc.dart';
import 'package:envelope/shared/widgets/confirm_delete_dialog.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope/envelopes/view/category_group_form_page.dart';
import 'package:envelope/envelopes/view/envelope_detail_page.dart';
import 'package:envelope/envelopes/view/envelope_form_page.dart';
import 'package:envelope/envelopes/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Page that provides [EnvelopesBloc] and displays the envelopes list.
class EnvelopesPage extends StatelessWidget {
  const EnvelopesPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EnvelopesBloc(
        envelopeRepository: context.read<EnvelopeRepository>(),
        budgetId: budgetId,
      )..add(const EnvelopesStarted()),
      child: EnvelopesView(budgetId: budgetId),
    );
  }
}

class EnvelopesView extends StatefulWidget {
  const EnvelopesView({required this.budgetId, super.key});

  final String budgetId;

  @override
  State<EnvelopesView> createState() => _EnvelopesViewState();
}

/// Owns all navigation and confirmation dialog logic for the envelopes list.
class _EnvelopesViewState extends State<EnvelopesView> {
  bool _isReordering = false;
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<EnvelopesBloc, EnvelopesState>(
      listenWhen: (prev, curr) =>
          curr.status == EnvelopesStatus.error && curr.error != null,
      listener: (context, state) {
        final message = switch (state.error!) {
          EnvelopesError.loadFailed => l10n.envelopesErrorLoadFailed,
          EnvelopesError.updateFailed => l10n.envelopesErrorUpdateFailed,
          EnvelopesError.deleteFailed => l10n.envelopesErrorDeleteFailed,
          EnvelopesError.reorderFailed => l10n.envelopesErrorReorderFailed,
        };
        showAppSnackBar(context, SnackBar(content: Text(message)));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.envelopesTitle),
          actions: [
            IconButton(
              onPressed: () => _showAddMenu(context),
              icon: const Icon(Icons.add),
            ),
            BlocBuilder<EnvelopesBloc, EnvelopesState>(
              buildWhen: (prev, curr) =>
                  prev.status != curr.status ||
                  prev.categoryGroups != curr.categoryGroups ||
                  prev.envelopes != curr.envelopes,
              builder: (context, state) {
                final hasArchived =
                    state.archivedGroups.isNotEmpty ||
                    state.archivedEnvelopes.isNotEmpty;
                if (state.status != EnvelopesStatus.loaded || !hasArchived) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  onPressed: () =>
                      setState(() => _showArchived = !_showArchived),
                  icon: Icon(
                    _showArchived
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  tooltip: _showArchived
                      ? l10n.envelopesHideArchived
                      : l10n.envelopesShowArchived,
                );
              },
            ),
            BlocBuilder<EnvelopesBloc, EnvelopesState>(
              buildWhen: (prev, curr) =>
                  prev.status != curr.status ||
                  prev.categoryGroups != curr.categoryGroups,
              builder: (context, state) {
                if (state.status != EnvelopesStatus.loaded ||
                    state.categoryGroups.isEmpty) {
                  return const SizedBox.shrink();
                }
                return TextButton(
                  onPressed: () =>
                      setState(() => _isReordering = !_isReordering),
                  child: Text(
                    _isReordering
                        ? l10n.envelopesDoneReordering
                        : l10n.envelopesReorder,
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<EnvelopesBloc, EnvelopesState>(
          builder: (context, state) {
            if (state.status == EnvelopesStatus.loading ||
                state.status == EnvelopesStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.categoryGroups.isEmpty) {
              return _EmptyState(onAdd: () => _openAddCategoryGroup(context));
            }

            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<EnvelopesBloc>()
                  ..add(const EnvelopesRefreshRequested());
                // Wait until the bloc transitions out of loading; this
                // completes after the API refresh and stream re-emission.
                await bloc.stream.firstWhere(
                  (s) => s.status != EnvelopesStatus.loading,
                );
              },
              child: _EnvelopesList(
                state: state,
                isReordering: _isReordering,
                showArchived: _showArchived,
                onEditGroup: (g) => _openEditCategoryGroup(context, g),
                onAddEnvelopeToGroup: (g) =>
                    _openAddEnvelope(context, initialGroupId: g.id),
                onArchiveGroup: (g) => _confirmArchiveGroup(context, g),
                onDeleteGroup: (g) => _confirmDeleteGroup(context, g),
                onUnarchiveGroup: (g) => context.read<EnvelopesBloc>().add(
                  CategoryGroupArchiveToggled(g),
                ),
                onEnvelopeTap: (e) => _openEnvelopeDetail(context, e),
                onEditEnvelope: (e) => _openEditEnvelope(context, e),
                onArchiveEnvelope: (e) => _confirmArchiveEnvelope(context, e),
                onDeleteEnvelope: (e) => _confirmDeleteEnvelope(context, e),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Add menu ──────────────────────────────────────────────────────────────

  void _showAddMenu(BuildContext context) {
    final l10n = context.l10n;
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: Text(l10n.envelopesAddCategoryGroup),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    unawaited(_openAddCategoryGroup(context));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.folder_outlined),
                  title: Text(l10n.envelopesAddEnvelope),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    unawaited(_openAddEnvelope(context, initialGroupId: null));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openAddCategoryGroup(BuildContext context) async {
    final bloc = context.read<EnvelopesBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CategoryGroupFormPage(
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: widget.budgetId,
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const EnvelopesRefreshRequested());
    }
  }

  Future<void> _openEditCategoryGroup(
    BuildContext context,
    CategoryGroup group,
  ) async {
    final bloc = context.read<EnvelopesBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CategoryGroupFormPage(
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: widget.budgetId,
          categoryGroup: group,
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const EnvelopesRefreshRequested());
    }
  }

  Future<void> _openAddEnvelope(
    BuildContext context, {
    required String? initialGroupId,
  }) async {
    final bloc = context.read<EnvelopesBloc>();
    final activeGroups = bloc.state.categoryGroups
        .where((g) => !g.isArchived)
        .toList();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => EnvelopeFormCubit(
            envelopeRepository: context.read<EnvelopeRepository>(),
            budgetId: widget.budgetId,
          ),
          child: EnvelopeFormPage(
            categoryGroups: activeGroups,
            initialCategoryGroupId: initialGroupId,
          ),
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const EnvelopesRefreshRequested());
    }
  }

  Future<void> _openEditEnvelope(
    BuildContext context,
    Envelope envelope,
  ) async {
    final bloc = context.read<EnvelopesBloc>();
    final activeGroups = bloc.state.categoryGroups
        .where((g) => !g.isArchived)
        .toList();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => EnvelopeFormCubit(
            envelopeRepository: context.read<EnvelopeRepository>(),
            budgetId: widget.budgetId,
            envelope: envelope,
          ),
          child: EnvelopeFormPage(
            categoryGroups: activeGroups,
            envelope: envelope,
          ),
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const EnvelopesRefreshRequested());
    }
  }

  Future<void> _openEnvelopeDetail(
    BuildContext context,
    Envelope envelope,
  ) async {
    final bloc = context.read<EnvelopesBloc>();
    final activeGroups = bloc.state.categoryGroups
        .where((g) => !g.isArchived)
        .toList();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => EnvelopeDetailCubit(
            envelopeRepository: context.read<EnvelopeRepository>(),
            transactionRepository: context.read<TransactionRepository>(),
            budgetRepository: context.read<BudgetRepository>(),
            envelope: envelope,
          ),
          child: EnvelopeDetailPage(categoryGroups: activeGroups),
        ),
      ),
    );
    if (context.mounted) {
      bloc.add(const EnvelopesRefreshRequested());
    }
  }

  // ── Confirmation dialogs ──────────────────────────────────────────────────

  Future<void> _confirmArchiveGroup(
    BuildContext context,
    CategoryGroup group,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.envelopesArchiveGroupConfirmTitle),
        content: Text(l10n.envelopesArchiveGroupConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.envelopesCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.envelopesArchive),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<EnvelopesBloc>().add(CategoryGroupArchiveToggled(group));
    }
  }

  Future<void> _confirmDeleteGroup(
    BuildContext context,
    CategoryGroup group,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.envelopesDeleteGroupConfirmTitle),
        content: Text(l10n.envelopesDeleteGroupConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.envelopesCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.envelopesDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<EnvelopesBloc>().add(CategoryGroupDeleted(group.id));
    }
  }

  Future<void> _confirmArchiveEnvelope(
    BuildContext context,
    Envelope envelope,
  ) async {
    final l10n = context.l10n;

    if (envelope.isArchived) {
      final bloc = context.read<EnvelopesBloc>();
      bloc.add(EnvelopeArchiveToggled(envelope));
      showUndoSnackBar(
        context,
        message: l10n.envelopesUnarchived,
        onUndo: () => bloc.add(const EnvelopeUndoArchiveRequested()),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.envelopesArchiveEnvelopeConfirmTitle),
        content: Text(l10n.envelopesArchiveEnvelopeConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.envelopesCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.envelopesArchive),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final bloc = context.read<EnvelopesBloc>();
      bloc.add(EnvelopeArchiveToggled(envelope));
      showUndoSnackBar(
        context,
        message: l10n.envelopesEnvelopeArchived,
        onUndo: () => bloc.add(const EnvelopeUndoArchiveRequested()),
      );
    }
  }

  Future<void> _confirmDeleteEnvelope(
    BuildContext context,
    Envelope envelope,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDeleteDialog(
      context,
      title: l10n.envelopesDeleteEnvelopeConfirmTitle,
      message: l10n.envelopesDeleteEnvelopeConfirmMessage,
      cancelLabel: l10n.envelopesCancel,
      confirmLabel: l10n.envelopesDelete,
    );
    if (confirmed == true && context.mounted) {
      final bloc = context.read<EnvelopesBloc>();
      bloc.add(EnvelopeDeleted(envelope.id));
      showUndoSnackBar(
        context,
        message: l10n.envelopesDeleted,
        onUndo: () => bloc.add(const EnvelopeUndoDeleteRequested()),
      );
    }
  }
}

// ── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.envelopesEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              l10n.envelopesEmptySubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(l10n.envelopesAddCategoryGroup),
          ),
        ],
      ),
    );
  }
}

// ── Purely presentational list widget ───────────────────────────────────────

/// Renders the hierarchical list of category groups and envelopes.
///
/// This widget is purely presentational — all navigation and dialog logic
/// is owned by [_EnvelopesViewState] and injected via callbacks.
class _EnvelopesList extends StatelessWidget {
  const _EnvelopesList({
    required this.state,
    required this.isReordering,
    required this.showArchived,
    required this.onEditGroup,
    required this.onAddEnvelopeToGroup,
    required this.onArchiveGroup,
    required this.onDeleteGroup,
    required this.onUnarchiveGroup,
    required this.onEnvelopeTap,
    required this.onEditEnvelope,
    required this.onArchiveEnvelope,
    required this.onDeleteEnvelope,
  });

  final EnvelopesState state;
  final bool isReordering;
  final bool showArchived;
  final void Function(CategoryGroup) onEditGroup;
  final void Function(CategoryGroup) onAddEnvelopeToGroup;
  final void Function(CategoryGroup) onArchiveGroup;
  final void Function(CategoryGroup) onDeleteGroup;
  final void Function(CategoryGroup) onUnarchiveGroup;
  final void Function(Envelope) onEnvelopeTap;
  final void Function(Envelope) onEditEnvelope;
  final void Function(Envelope) onArchiveEnvelope;
  final void Function(Envelope) onDeleteEnvelope;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final activeGroups = state.activeGroupsWithEnvelopes;
    final archivedGroups = state.archivedGroups;

    if (isReordering) {
      return _ReorderGroupsList(activeGroups: activeGroups);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        for (final (group, envelopes) in activeGroups)
          CategoryGroupTile(
            key: ValueKey(group.id),
            categoryGroup: group,
            envelopes: showArchived
                ? [
                    ...envelopes,
                    ...state.envelopes
                        .where(
                          (e) => e.categoryGroupId == group.id && e.isArchived,
                        )
                        .toList()
                      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
                  ]
                : envelopes,
            onEditGroup: () => onEditGroup(group),
            onAddEnvelope: () => onAddEnvelopeToGroup(group),
            onArchiveGroup: () => onArchiveGroup(group),
            onDeleteGroup: () => onDeleteGroup(group),
            onEnvelopeTap: onEnvelopeTap,
            onEditEnvelope: onEditEnvelope,
            onArchiveEnvelope: onArchiveEnvelope,
            onDeleteEnvelope: onDeleteEnvelope,
          ),
        if (showArchived && archivedGroups.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              l10n.envelopesArchived,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          for (final group in archivedGroups)
            CategoryGroupTile(
              key: ValueKey('archived-group-${group.id}'),
              categoryGroup: group,
              envelopes: const [],
              initiallyExpanded: false,
              onEditGroup: () => onEditGroup(group),
              onAddEnvelope: () {},
              onArchiveGroup: () => onUnarchiveGroup(group),
              onDeleteGroup: () => onDeleteGroup(group),
              onEnvelopeTap: (_) {},
              onEditEnvelope: (_) {},
              onArchiveEnvelope: (_) {},
              onDeleteEnvelope: (_) {},
            ),
        ],
      ],
    );
  }
}

// ── Reorder mode ─────────────────────────────────────────────────────────────

class _ReorderGroupsList extends StatelessWidget {
  const _ReorderGroupsList({required this.activeGroups});

  final List<(CategoryGroup, List<Envelope>)> activeGroups;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: activeGroups.length,
      onReorder: (oldIndex, newIndex) {
        final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
        final ids = activeGroups.map((e) => e.$1.id).toList();
        final id = ids.removeAt(oldIndex);
        ids.insert(adjustedIndex, id);
        context.read<EnvelopesBloc>().add(CategoryGroupsReordered(ids));
      },
      itemBuilder: (context, index) {
        final (group, _) = activeGroups[index];
        return ListTile(
          key: ValueKey(group.id),
          leading: const Icon(Icons.drag_handle),
          title: Text(group.name),
        );
      },
    );
  }
}
