import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// Fund source — either Ready to Assign or a specific envelope allocation.
// ---------------------------------------------------------------------------

sealed class _FundSource {}

final class _ReadyToAssignSource extends _FundSource {}

final class _EnvelopeSource extends _FundSource {
  _EnvelopeSource(this.envelope, this.allocation);
  final Envelope envelope;
  final EnvelopeAllocation allocation;
}

// ---------------------------------------------------------------------------
// Public entry point
// ---------------------------------------------------------------------------

/// Shows a dialog to transfer funds from another envelope (or Ready to Assign)
/// to cover overspending.
///
/// Returns `true` if the transfer was successful,
/// `null` or `false` otherwise.
Future<bool?> showCoverOverspendDialog(
  BuildContext context, {
  required BudgetRepository budgetRepository,
  required EnvelopeRepository envelopeRepository,
  required List<EnvelopeAllocation> allocations,
  required List<Envelope> envelopes,
  required EnvelopeAllocation overspentAllocation,
  required String overspentEnvelopeName,
  required int deficitCents,
  int readyToAssign = 0,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => _CoverOverspendDialog(
      budgetRepository: budgetRepository,
      envelopeRepository: envelopeRepository,
      allocations: allocations,
      envelopes: envelopes,
      overspentAllocation: overspentAllocation,
      overspentEnvelopeName: overspentEnvelopeName,
      deficitCents: deficitCents,
      readyToAssign: readyToAssign,
    ),
  );
}

// ---------------------------------------------------------------------------
// Dialog widget
// ---------------------------------------------------------------------------

class _CoverOverspendDialog extends StatefulWidget {
  const _CoverOverspendDialog({
    required this.budgetRepository,
    required this.envelopeRepository,
    required this.allocations,
    required this.envelopes,
    required this.overspentAllocation,
    required this.overspentEnvelopeName,
    required this.deficitCents,
    required this.readyToAssign,
  });

  final BudgetRepository budgetRepository;
  final EnvelopeRepository envelopeRepository;
  final List<EnvelopeAllocation> allocations;
  final List<Envelope> envelopes;
  final EnvelopeAllocation overspentAllocation;
  final String overspentEnvelopeName;
  final int deficitCents;
  final int readyToAssign;

  @override
  State<_CoverOverspendDialog> createState() => _CoverOverspendDialogState();
}

class _CoverOverspendDialogState extends State<_CoverOverspendDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  bool _isSubmitting = false;

  _FundSource? _selectedSource;

  /// All available sources (RTA first, then envelope allocations with funds).
  late final List<_FundSource> _sources;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: (widget.deficitCents / 100).toStringAsFixed(2),
    );

    final envelopeSources = widget.allocations
        .where((a) {
          if (a.id == widget.overspentAllocation.id) return false;
          return EnvelopeRepository.calculateRollover(a) > 0;
        })
        .map((a) {
          final env = widget.envelopes
              .where((e) => e.id == a.envelopeId)
              .firstOrNull;
          return env != null ? _EnvelopeSource(env, a) : null;
        })
        .whereType<_EnvelopeSource>()
        .toList();

    _sources = [
      if (widget.readyToAssign > 0) _ReadyToAssignSource(),
      ...envelopeSources,
    ];
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

    if (_sources.isEmpty) {
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

            // "From" dropdown — RTA or envelopes with positive balance.
            DropdownButtonFormField<_FundSource>(
              decoration: InputDecoration(
                labelText: l10n.overspendCoverFromLabel,
              ),
              initialValue: _selectedSource,
              items: _sources.map((source) {
                return DropdownMenuItem<_FundSource>(
                  value: source,
                  child: switch (source) {
                    _ReadyToAssignSource() => Text(
                      l10n.overspendCoverReadyToAssign(
                        formatCents(widget.readyToAssign, symbol: symbol),
                      ),
                    ),
                    _EnvelopeSource(:final envelope, :final allocation) => Text(
                      '${envelope.name} '
                      '(${formatCents(
                        EnvelopeRepository.calculateRollover(allocation),
                        symbol: symbol,
                      )})',
                    ),
                  },
                );
              }).toList(),
              validator: (v) =>
                  v == null ? l10n.overspendCoverSourceRequired : null,
              onChanged: (v) => setState(() => _selectedSource = v),
            ),
            const SizedBox(height: 12),

            // Amount — defaults to deficit.
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l10n.overspendCoverAmountLabel,
                prefixText: symbol,
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
                final cents = parseCents(v ?? '') ?? 0;
                if (cents <= 0) {
                  return l10n.overspendCoverAmountRequired;
                }
                final source = _selectedSource;
                if (source is _ReadyToAssignSource &&
                    cents > widget.readyToAssign) {
                  return l10n.overspendCoverInsufficientFunds;
                }
                if (source is _EnvelopeSource &&
                    cents >
                        EnvelopeRepository.calculateRollover(
                          source.allocation,
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
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
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
      final source = _selectedSource!;

      if (source is _ReadyToAssignSource) {
        // Increase the overspent envelope's allocation by the cover amount,
        // pulling funds from Ready to Assign.
        await widget.envelopeRepository.updateAllocation(
          widget.overspentAllocation.copyWith(
            allocatedAmount:
                widget.overspentAllocation.allocatedAmount + amount,
          ),
        );
      } else if (source is _EnvelopeSource) {
        await widget.budgetRepository.transferBetweenEnvelopes(
          fromAllocationId: source.allocation.id,
          toAllocationId: widget.overspentAllocation.id,
          amount: amount,
        );
      }

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
