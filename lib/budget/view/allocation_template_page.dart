import 'dart:async';

import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page for listing, creating, editing, and deleting allocation templates.
///
/// Uses the [BudgetBloc] provided from the parent context (no separate bloc).
class AllocationTemplatePage extends StatelessWidget {
  const AllocationTemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.budgetTemplatesTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => unawaited(_openTemplateForm(context, null)),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        buildWhen: (prev, curr) => prev.templates != curr.templates,
        builder: (context, state) {
          if (state.templates.isEmpty) {
            return Center(
              child: Text(
                l10n.budgetTemplatesEmpty,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: state.templates.length,
            itemBuilder: (context, index) {
              final template = state.templates[index];
              return ListTile(
                title: Text(template.name),
                subtitle: Text(
                  l10n.budgetTemplateItemCount(template.items.length),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () =>
                          unawaited(_openTemplateForm(context, template)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () =>
                          unawaited(_confirmDelete(context, template)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openTemplateForm(
    BuildContext context,
    AllocationTemplate? existing,
  ) async {
    final bloc = context.read<BudgetBloc>();
    final navigator = Navigator.of(context);
    await navigator.push<void>(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: _TemplateFormPage(existing: existing),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AllocationTemplate template,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.budgetTemplateDeleteConfirmTitle),
        content: Text(l10n.budgetTemplateDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.budgetCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.budgetDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context
          .read<BudgetBloc>()
          .add(AllocationTemplateDeleted(template.id));
    }
  }
}

// ── Template form page ───────────────────────────────────────────────────────

class _TemplateFormPage extends StatefulWidget {
  const _TemplateFormPage({this.existing});

  final AllocationTemplate? existing;

  @override
  State<_TemplateFormPage> createState() => _TemplateFormPageState();
}

class _TemplateFormPageState extends State<_TemplateFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  // Each item: [envelopeId, percentage string]
  late final List<_TemplateItemRow> _items;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existing?.name ?? '');
    _items = widget.existing?.items
            .map(
              (item) => _TemplateItemRow(
                envelopeId: item.envelopeId,
                percentageController:
                    TextEditingController(text: item.percentage.toString()),
              ),
            )
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final item in _items) {
      item.percentageController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? l10n.budgetTemplateEditTitle
              : l10n.budgetTemplateNewTitle,
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              isEditing ? l10n.budgetSaveButton : l10n.budgetCreateButton,
            ),
          ),
        ],
      ),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        buildWhen: (prev, curr) => prev.envelopes != curr.envelopes,
        builder: (context, state) {
          final activeEnvelopes =
              state.envelopes.where((e) => !e.isArchived).toList();

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration:
                      InputDecoration(labelText: l10n.budgetTemplateNameLabel),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.budgetTemplateNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.budgetTemplateItems,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text(l10n.budgetTemplateAddItem),
                      onPressed: activeEnvelopes.isNotEmpty
                          ? () {
                              setState(() {
                                _items.add(
                                  _TemplateItemRow(
                                    envelopeId: activeEnvelopes.first.id,
                                    percentageController:
                                        TextEditingController(),
                                  ),
                                );
                              });
                            }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._items.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            value: item.envelopeId,
                            decoration: InputDecoration(
                              labelText: l10n.budgetTemplateEnvelopeLabel,
                              isDense: true,
                            ),
                            items: activeEnvelopes
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(
                                      e.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(
                                  () => _items[idx] =
                                      _items[idx].withEnvelopeId(v),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: item.percentageController,
                            decoration: InputDecoration(
                              labelText: l10n.budgetTemplatePercentageLabel,
                              suffixText: '%',
                              isDense: true,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            validator: (v) {
                              final pct = double.tryParse(v ?? '');
                              if (pct == null || pct <= 0) {
                                return l10n.budgetTemplatePercentageRequired;
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              _items[idx].percentageController.dispose();
                              _items.removeAt(idx);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
                if (_items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      l10n.budgetTemplateNoItems,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_items.isEmpty) return;

    final total = _items.fold<double>(
      0,
      (sum, row) =>
          sum + (double.tryParse(row.percentageController.text) ?? 0),
    );
    if ((total - 100).abs() > 0.01) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.budgetTemplatePercentageSumError),
        ),
      );
      return;
    }

    final items = _items
        .map(
          (row) => AllocationTemplateItem(
            id: '',
            templateId: widget.existing?.id ?? '',
            envelopeId: row.envelopeId,
            percentage: double.tryParse(row.percentageController.text) ?? 0,
          ),
        )
        .toList();

    if (widget.existing != null) {
      context.read<BudgetBloc>().add(
            AllocationTemplateUpdated(
              widget.existing!.copyWith(
                name: _nameController.text.trim(),
                items: items,
              ),
            ),
          );
    } else {
      context.read<BudgetBloc>().add(
            AllocationTemplateCreated(
              name: _nameController.text.trim(),
              items: items,
            ),
          );
    }
    Navigator.of(context).pop();
  }
}

// ── Row data ─────────────────────────────────────────────────────────────────

class _TemplateItemRow {
  const _TemplateItemRow({
    required this.envelopeId,
    required this.percentageController,
  });

  final String envelopeId;
  final TextEditingController percentageController;

  _TemplateItemRow withEnvelopeId(String id) => _TemplateItemRow(
        envelopeId: id,
        percentageController: percentageController,
      );
}
