import 'dart:async';

import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/budget/view/allocation_template_page.dart';
import 'package:envelope/budget/widgets/transfer_dialog.dart';
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
                        unawaited(_showApplyTemplateDialog(context, bloc, state));
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
                  if (state.allocations.length >= 2)
                    ListTile(
                      leading: const Icon(Icons.swap_horiz),
                      title: Text(l10n.budgetTransferBetweenEnvelopes),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        unawaited(
                          showTransferDialog(
                            context,
                            allocations: state.allocations,
                            envelopes: state.envelopes,
                          ),
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
                  decoration:
                      InputDecoration(labelText: l10n.budgetTemplateNameLabel),
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
                          totalAmount:
                              state.selectedPeriod?.totalIncome ?? 0,
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
