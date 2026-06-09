import 'dart:async';

import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/budget/view/allocation_template_page.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows a bottom sheet with budget actions: apply template, manage templates,
/// transfer between envelopes, and duplicate from previous period.
///
/// Uses a live [BlocBuilder] so menu items reflect the current bloc state even
/// if the sheet stays open while the state changes.
Future<void> showBudgetActionsMenu(BuildContext context) {
  final bloc = context.read<BudgetBloc>();
  final l10n = context.l10n;

  return showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: bloc,
        child: BlocBuilder<BudgetBloc, BudgetState>(
          builder: (builderContext, state) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.templates.isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.playlist_play_outlined),
                      title: Text(l10n.budgetApplyTemplate),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        unawaited(
                          _showApplyTemplateDialog(context, bloc, state),
                        );
                      },
                    ),
                  ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: Text(l10n.budgetManageTemplates),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      unawaited(
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => BlocProvider.value(
                              value: bloc,
                              child: const AllocationTemplatePage(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (state.allocations.any((a) => a.allocatedAmount > 0))
                    ListTile(
                      leading: const Icon(Icons.bookmark_add_outlined),
                      title: Text(l10n.budgetSaveAsTemplate),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        unawaited(
                          _showSaveAsTemplateDialog(context, bloc, state),
                        );
                      },
                    ),
                  if (state.hasPreviousPeriod)
                    ListTile(
                      leading: const Icon(Icons.copy_outlined),
                      title: Text(l10n.budgetDuplicateFromPrevious),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        bloc.add(
                          const BudgetDuplicateFromPreviousPeriodRequested(),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

Future<void> _showApplyTemplateDialog(
  BuildContext context,
  BudgetBloc bloc,
  BudgetState state,
) {
  final l10n = context.l10n;
  var selectedTemplateId = state.templates.first.id;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(l10n.budgetApplyTemplate),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedTemplateId,
                  decoration: InputDecoration(
                    labelText: l10n.budgetTemplateNameLabel,
                  ),
                  items: state.templates
                      .map(
                        (t) => DropdownMenuItem(
                          value: t.id,
                          child: Text(t.name),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => selectedTemplateId = v);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.budgetCancel),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  bloc.add(
                    AllocationTemplateApplied(
                      templateId: selectedTemplateId,
                      totalAmount: state.selectedPeriod?.totalIncome ?? 0,
                    ),
                  );
                },
                child: Text(l10n.budgetApplyTemplate),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _showSaveAsTemplateDialog(
  BuildContext context,
  BudgetBloc bloc,
  BudgetState state,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _SaveAsTemplateDialog(
      bloc: bloc,
      budgetState: state,
      messenger: ScaffoldMessenger.of(context),
    ),
  );
}

class _SaveAsTemplateDialog extends StatefulWidget {
  const _SaveAsTemplateDialog({
    required this.bloc,
    required this.budgetState,
    required this.messenger,
  });

  final BudgetBloc bloc;
  final BudgetState budgetState;
  final ScaffoldMessengerState messenger;

  @override
  State<_SaveAsTemplateDialog> createState() => _SaveAsTemplateDialogState();
}

class _SaveAsTemplateDialogState extends State<_SaveAsTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = context.l10n;
    final items = _buildTemplateItemsFromAllocations(widget.budgetState);
    if (items.isEmpty) {
      Navigator.of(context).pop();
      widget.messenger.showSnackBar(
        SnackBar(content: Text(l10n.budgetTemplateNoItems)),
      );
      return;
    }
    widget.bloc.add(
      AllocationTemplateCreated(
        name: _nameController.text.trim(),
        items: items,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.budgetSaveAsTemplate),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.budgetTemplateNameLabel),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.budgetTemplateNameRequired;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.budgetCancel),
        ),
        FilledButton(
          onPressed: _onSave,
          child: Text(l10n.budgetSaveButton),
        ),
      ],
    );
  }
}

/// Converts the period's current allocations into template items by computing
/// each envelope's share as a percentage of the total allocated amount.
///
/// Allocations with zero amounts are preserved as 0% items so the saved
/// template matches the user's full envelope plan, not just the funded subset.
/// Rounding remainder is absorbed by the largest-amount item so percentages
/// sum to 100 without producing a negative on a zero-amount item.
List<AllocationTemplateItem> _buildTemplateItemsFromAllocations(
  BudgetState state,
) {
  final allocations = state.allocations;
  if (allocations.isEmpty) return const [];

  final total = allocations.fold<int>(0, (sum, a) => sum + a.allocatedAmount);
  if (total <= 0) return const [];

  final percentages = allocations
      .map((a) => a.allocatedAmount * 100 / total)
      .toList();

  var maxIdx = 0;
  for (var i = 1; i < allocations.length; i++) {
    if (allocations[i].allocatedAmount > allocations[maxIdx].allocatedAmount) {
      maxIdx = i;
    }
  }

  final sum = percentages.fold<double>(0, (s, p) => s + p);
  percentages[maxIdx] += 100 - sum;

  return [
    for (var i = 0; i < allocations.length; i++)
      AllocationTemplateItem(
        id: '',
        templateId: '',
        envelopeId: allocations[i].envelopeId,
        percentage: percentages[i],
      ),
  ];
}
