import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shows a dialog to transfer funds from another envelope
/// to cover overspending.
///
/// Returns `true` if the transfer was successful,
/// `null` or `false` otherwise.
Future<bool?> showCoverOverspendDialog(
  BuildContext context, {
  required BudgetRepository budgetRepository,
  required List<EnvelopeAllocation> allocations,
  required List<Envelope> envelopes,
  required EnvelopeAllocation overspentAllocation,
  required String overspentEnvelopeName,
  required int deficitCents,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => _CoverOverspendDialog(
      budgetRepository: budgetRepository,
      allocations: allocations,
      envelopes: envelopes,
      overspentAllocation: overspentAllocation,
      overspentEnvelopeName: overspentEnvelopeName,
      deficitCents: deficitCents,
    ),
  );
}

class _CoverOverspendDialog extends StatefulWidget {
  const _CoverOverspendDialog({
    required this.budgetRepository,
    required this.allocations,
    required this.envelopes,
    required this.overspentAllocation,
    required this.overspentEnvelopeName,
    required this.deficitCents,
  });

  final BudgetRepository budgetRepository;
  final List<EnvelopeAllocation> allocations;
  final List<Envelope> envelopes;
  final EnvelopeAllocation overspentAllocation;
  final String overspentEnvelopeName;
  final int deficitCents;

  @override
  State<_CoverOverspendDialog> createState() =>
      _CoverOverspendDialogState();
}

class _CoverOverspendDialogState
    extends State<_CoverOverspendDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  bool _isSubmitting = false;

  EnvelopeAllocation? _fromAllocation;

  /// Source envelopes with positive available balance.
  late final List<(Envelope, EnvelopeAllocation)>
      _sourceEnvelopes;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: (widget.deficitCents / 100).toStringAsFixed(2),
    );

    _sourceEnvelopes = widget.allocations
        .where((a) {
          if (a.id == widget.overspentAllocation.id) return false;
          return EnvelopeRepository.calculateRollover(a) > 0;
        })
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

    if (_sourceEnvelopes.isEmpty) {
      return AlertDialog(
        title: Text(l10n.overspendCoverTitle),
        content: Text(l10n.overspendCoverNoSource),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.overspendDismiss),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(l10n.overspendCoverTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Locked "To" field showing the overspent envelope.
            TextFormField(
              initialValue: widget.overspentEnvelopeName,
              decoration: InputDecoration(
                labelText: l10n.overspendCoverToLabel,
              ),
              enabled: false,
            ),
            const SizedBox(height: 12),

            // "From" dropdown — only envelopes with positive
            // available balance.
            DropdownButtonFormField<EnvelopeAllocation>(
              decoration: InputDecoration(
                labelText: l10n.overspendCoverFromLabel,
              ),
              initialValue: _fromAllocation,
              items: _sourceEnvelopes
                  .map(
                    (pair) => DropdownMenuItem(
                      value: pair.$2,
                      child: Text(
                        '${pair.$1.name} '
                        '(${formatCents(
                          EnvelopeRepository.calculateRollover(
                            pair.$2,
                          ),
                        )})',
                      ),
                    ),
                  )
                  .toList(),
              validator: (v) => v == null
                  ? l10n.overspendCoverSourceRequired
                  : null,
              onChanged: (v) =>
                  setState(() => _fromAllocation = v),
            ),
            const SizedBox(height: 12),

            // Amount — defaults to deficit.
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l10n.overspendCoverAmountLabel,
                prefixText: r'$',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,2}'),
                ),
              ],
              validator: (v) {
                final cents = parseCents(v ?? '') ?? 0;
                if (cents <= 0) {
                  return l10n.overspendCoverAmountRequired;
                }
                final from = _fromAllocation;
                if (from != null &&
                    cents >
                        EnvelopeRepository.calculateRollover(
                          from,
                        )) {
                  return l10n.overspendCoverInsufficientFunds;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(),
          child: Text(l10n.overspendDismiss),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text(l10n.overspendCoverConfirm),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final amount = parseCents(_amountController.text) ?? 0;
      await widget.budgetRepository.transferBetweenEnvelopes(
        fromAllocationId: _fromAllocation!.id,
        toAllocationId: widget.overspentAllocation.id,
        amount: amount,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on Exception {
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    }
  }
}
