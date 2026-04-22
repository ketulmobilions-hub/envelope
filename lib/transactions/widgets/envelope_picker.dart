import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope/envelopes/view/category_group_form_page.dart';
import 'package:envelope/envelopes/view/envelope_form_page.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _kNewGroup = 'new_group';

/// Result type for "new envelope in group" action.
@immutable
class _NewEnvelopeResult {
  const _NewEnvelopeResult(this.groupId);
  final String groupId;
}

/// Card-style trigger that opens a grouped envelope bottom sheet.
///
/// Groups envelopes by their category group and provides inline actions
/// to create a new envelope or category group.
class EnvelopePicker extends StatelessWidget {
  const EnvelopePicker({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Envelope? value;
  final void Function(Envelope) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final selectedLabel = value?.name;

    return InkWell(
      onTap: () => _showPicker(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(Icons.mail_outlined, size: 22, color: colorScheme.outline),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.transactionsEnvelopeLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.outline,
                      letterSpacing: 0.4,
                    ),
                  ),
                  if (selectedLabel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      selectedLabel,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.outline, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final cubit = context.read<TransactionFormCubit>();
    final envelopeRepo = context.read<EnvelopeRepository>();
    final state = cubit.state;

    final result = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => _EnvelopePickerSheet(
        envelopes: state.envelopes,
        categoryGroups: state.categoryGroups,
        selectedValue: value,
      ),
    );

    if (!context.mounted) return;

    if (result is Envelope) {
      onChanged(result);
    } else if (result is _NewEnvelopeResult) {
      await Navigator.of(context, rootNavigator: true).push<bool>(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => EnvelopeFormCubit(
              envelopeRepository: envelopeRepo,
              budgetId: cubit.budgetId,
            ),
            child: EnvelopeFormPage(
              categoryGroups: cubit.state.categoryGroups,
              initialCategoryGroupId: result.groupId,
            ),
          ),
        ),
      );
      if (context.mounted) await cubit.reloadEnvelopes();
    } else if (result == _kNewGroup) {
      await Navigator.of(context, rootNavigator: true).push<bool>(
        MaterialPageRoute(
          builder: (_) => CategoryGroupFormPage(
            envelopeRepository: envelopeRepo,
            budgetId: cubit.budgetId,
          ),
        ),
      );
      if (context.mounted) await cubit.reloadEnvelopes();
    }
  }
}

// ---------------------------------------------------------------------------
// Bottom-sheet content
// ---------------------------------------------------------------------------

class _EnvelopePickerSheet extends StatelessWidget {
  const _EnvelopePickerSheet({
    required this.envelopes,
    required this.categoryGroups,
    required this.selectedValue,
  });

  final List<Envelope> envelopes;
  final List<CategoryGroup> categoryGroups;
  final Envelope? selectedValue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    // Build group → envelopes map preserving group sort order.
    final groupedEnvelopes = <CategoryGroup, List<Envelope>>{};
    for (final group in categoryGroups) {
      groupedEnvelopes[group] = envelopes
          .where((e) => e.categoryGroupId == group.id && !e.isArchived)
          .toList();
    }

    // Guard: envelopes that don't match any known group.
    final knownGroupIds = categoryGroups.map((g) => g.id).toSet();
    final ungrouped = envelopes
        .where(
          (e) =>
              !knownGroupIds.contains(e.categoryGroupId) && !e.isArchived,
        )
        .toList();

    return DraggableScrollableSheet(
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (ctx, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle.
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Sheet title.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                l10n.transactionsEnvelopeLabel,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),

            const Divider(height: 1),

            // Grouped list.
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  for (final entry in groupedEnvelopes.entries) ...[
                    _GroupSection(
                      group: entry.key,
                      envelopes: entry.value,
                      selectedValue: selectedValue,
                    ),
                  ],
                  if (ungrouped.isNotEmpty)
                    _GroupSection(
                      group: null,
                      envelopes: ungrouped,
                      selectedValue: selectedValue,
                    ),

                  const Divider(height: 1),

                  // New Category Group footer action.
                  InkWell(
                    onTap: () => Navigator.of(ctx).pop(_kNewGroup),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.create_new_folder_outlined,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            l10n.envelopesAddCategoryGroup,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GroupSection extends StatelessWidget {
  const _GroupSection({
    required this.group,
    required this.envelopes,
    required this.selectedValue,
  });

  final CategoryGroup? group;
  final List<Envelope> envelopes;
  final Envelope? selectedValue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final groupId = group?.id;
    final groupName = group?.name ?? 'Uncategorized';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section header.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Text(
            groupName.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
        ),

        // Envelope rows.
        for (final envelope in envelopes) ...[
          InkWell(
            onTap: () => Navigator.of(context).pop(envelope),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.mail_outlined,
                    size: 20,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      envelope.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: selectedValue?.id == envelope.id
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (selectedValue?.id == envelope.id)
                    Icon(
                      Icons.check_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, indent: 56),
        ],

        // Add envelope to this group.
        if (groupId != null)
          InkWell(
            onTap: () =>
                Navigator.of(context).pop(_NewEnvelopeResult(groupId)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    l10n.envelopesAddEnvelope,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

        const Divider(height: 1),
      ],
    );
  }
}
