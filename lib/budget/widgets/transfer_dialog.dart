import 'dart:async';

import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows a dialog to transfer funds between two envelope allocations.
///
/// Only envelopes that already have an allocation in the current period can be
/// selected, since the transfer requires existing allocation IDs on both sides.
Future<void> showTransferDialog(
  BuildContext context, {
  required List<EnvelopeAllocation> allocations,
  required List<Envelope> envelopes,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _TransferDialog(
      allocations: allocations,
      envelopes: envelopes,
      budgetBloc: context.read<BudgetBloc>(),
    ),
  );
}

class _TransferDialog extends StatefulWidget {
  const _TransferDialog({
    required this.allocations,
    required this.envelopes,
    required this.budgetBloc,
  });

  final List<EnvelopeAllocation> allocations;
  final List<Envelope> envelopes;
  final BudgetBloc budgetBloc;

  @override
  State<_TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<_TransferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  EnvelopeAllocation? _fromAllocation;
  EnvelopeAllocation? _toAllocation;

  /// Envelopes that have an allocation — required for both from and to.
  late final List<(Envelope, EnvelopeAllocation)> _allocatedEnvelopes;

  @override
  void initState() {
    super.initState();
    _allocatedEnvelopes = widget.allocations
        .map((a) {
          final env = widget.envelopes
              .where((e) => e.id == a.envelopeId)
              .firstOrNull;
          return env != null ? (env, a) : null;
        })
        .whereType<(Envelope, EnvelopeAllocation)>()
        .toList();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);

    return AlertDialog(
      title: Text(l10n.budgetTransferTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<EnvelopeAllocation>(
              decoration: InputDecoration(labelText: l10n.budgetTransferFrom),
              value: _fromAllocation,
              items: _allocatedEnvelopes
                  .map(
                    (pair) => DropdownMenuItem(
                      value: pair.$2,
                      child: Text(pair.$1.name),
                    ),
                  )
                  .toList(),
              validator: (v) => v == null ? l10n.budgetTransferRequired : null,
              onChanged: (v) => setState(() => _fromAllocation = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<EnvelopeAllocation>(
              decoration: InputDecoration(labelText: l10n.budgetTransferTo),
              value: _toAllocation,
              items: _allocatedEnvelopes
                  .where((pair) => pair.$2 != _fromAllocation)
                  .map(
                    (pair) => DropdownMenuItem(
                      value: pair.$2,
                      child: Text(pair.$1.name),
                    ),
                  )
                  .toList(),
              validator: (v) => v == null ? l10n.budgetTransferRequired : null,
              onChanged: (v) => setState(() => _toAllocation = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l10n.budgetTransferAmount,
                prefixText: symbol,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              validator: (v) {
                final cents = _parseCents(v ?? '');
                if (cents <= 0) return l10n.budgetTransferAmountRequired;
                final from = _fromAllocation;
                final spent = from == null
                    ? 0
                    : (context.read<BudgetBloc>().state.spentByEnvelope[from
                              .envelopeId] ??
                          0);
                final availableCents = from == null
                    ? 0
                    : from.allocatedAmount - spent;
                if (cents > availableCents) {
                  return l10n.budgetTransferInsufficientFunds;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.budgetCancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.budgetTransferConfirm),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = _parseCents(_amountController.text);
    widget.budgetBloc.add(
      EnvelopeTransferRequested(
        fromAllocationId: _fromAllocation!.id,
        toAllocationId: _toAllocation!.id,
        amount: amount,
      ),
    );
    Navigator.of(context).pop();
  }

  static int _parseCents(String text) {
    final value = double.tryParse(text) ?? 0;
    return (value * 100).round();
  }
}
