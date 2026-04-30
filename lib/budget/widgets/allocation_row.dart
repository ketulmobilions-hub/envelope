import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A single envelope row in the allocation list.
///
/// Displays the envelope name, an editable amount field, and read-only
/// spent/available figures. Dispatches [AllocationAmountChanged] as the user
/// types so that the ready-to-assign card updates in real time.
class AllocationRow extends StatefulWidget {
  const AllocationRow({
    required this.envelope,
    required this.allocation,
    this.availableOverride,
    super.key,
  });

  final Envelope envelope;
  final EnvelopeAllocation? allocation;

  /// When non-null, overrides the computed available amount. Used for CC
  /// Payment envelopes where available is derived from transaction history.
  final int? availableOverride;

  @override
  State<AllocationRow> createState() => _AllocationRowState();
}

class _AllocationRowState extends State<AllocationRow> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(
      text: _centsToText(widget.allocation?.allocatedAmount ?? 0),
    );
  }

  @override
  void didUpdateWidget(AllocationRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newAmount = widget.allocation?.allocatedAmount ?? 0;
    final oldAmount = oldWidget.allocation?.allocatedAmount ?? 0;
    // Only reset the field when the server value changes, the user isn't
    // currently typing, and there is no pending local edit for this envelope
    // (which would be overwritten by the server push).
    if (newAmount != oldAmount && !_focusNode.hasFocus) {
      final hasLocalEdit = context
          .read<BudgetBloc>()
          .state
          .localAllocations
          .containsKey(widget.envelope.id);
      if (!hasLocalEdit) {
        _controller.text = _centsToText(newAmount);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);
    final allocation = widget.allocation;
    final spent = allocation?.spentAmount ?? 0;
    final available =
        widget.availableOverride ??
        (allocation != null
            ? EnvelopeRepository.calculateRollover(allocation)
            : 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.envelope.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${l10n.budgetSpentLabel}: '
                            '${formatCents(spent, symbol: symbol)}  ',
                      ),
                      TextSpan(
                        text:
                            '${l10n.budgetAvailableLabel}: '
                            '${formatCents(available, symbol: symbol)}',
                        style: available < 0
                            ? TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.w600,
                              )
                            : null,
                      ),
                    ],
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                prefixText: symbol,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              onChanged: (value) {
                final cents = parseCents(value) ?? 0;
                context.read<BudgetBloc>().add(
                  AllocationAmountChanged(
                    envelopeId: widget.envelope.id,
                    amount: cents,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static String _centsToText(int cents) {
    if (cents == 0) return '';
    return (cents / 100).toStringAsFixed(2);
  }
}
