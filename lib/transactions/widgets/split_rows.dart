import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A single split entry: envelope + amount.
class SplitEntry {
  const SplitEntry({this.envelopeId, this.amountText = ''});

  final String? envelopeId;
  final String amountText;

  int get amountCents => parseCents(amountText) ?? 0;

  SplitEntry copyWith({
    Object? envelopeId = _sentinel,
    String? amountText,
  }) {
    return SplitEntry(
      envelopeId: envelopeId == _sentinel
          ? this.envelopeId
          : envelopeId as String?,
      amountText: amountText ?? this.amountText,
    );
  }

  static const Object _sentinel = Object();
}

/// Dynamic rows for splitting a transaction across multiple envelopes.
class SplitRows extends StatelessWidget {
  const SplitRows({
    required this.splits,
    required this.envelopes,
    required this.onChanged,
    required this.totalAmountCents,
    super.key,
  });

  final List<SplitEntry> splits;
  final List<Envelope> envelopes;
  final ValueChanged<List<SplitEntry>> onChanged;
  final int totalAmountCents;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);
    final splitTotal = splits.fold(0, (sum, s) => sum + s.amountCents);
    final remaining = totalAmountCents - splitTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.transactionsSplitLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '${l10n.transactionsRemaining}: ${formatCents(remaining, symbol: symbol)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: remaining == 0
                    ? AppColors.income
                    : Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < splits.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    initialValue: splits[i].envelopeId,
                    decoration: InputDecoration(
                      labelText: l10n.transactionsEnvelopeLabel,
                      isDense: true,
                    ),
                    items: envelopes.map((env) {
                      return DropdownMenuItem(
                        value: env.id,
                        child: Text(
                          env.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final updated = List<SplitEntry>.from(splits);
                      updated[i] = updated[i].copyWith(envelopeId: value);
                      onChanged(updated);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: splits[i].amountText,
                    decoration: InputDecoration(
                      labelText: l10n.transactionsAmountLabel,
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
                    onChanged: (value) {
                      final updated = List<SplitEntry>.from(splits);
                      updated[i] = updated[i].copyWith(amountText: value);
                      onChanged(updated);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: splits.length > 1
                      ? () {
                          final updated = List<SplitEntry>.from(splits)
                            ..removeAt(i);
                          onChanged(updated);
                        }
                      : null,
                ),
              ],
            ),
          ),
        TextButton.icon(
          onPressed: () {
            final updated = List<SplitEntry>.from(splits)
              ..add(const SplitEntry());
            onChanged(updated);
          },
          icon: const Icon(Icons.add),
          label: Text(l10n.transactionsAddSplit),
        ),
      ],
    );
  }
}
