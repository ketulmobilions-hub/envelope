import 'package:envelope/l10n/l10n.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows a float warning when the CC Payment envelope does not fully cover
/// the credit card account's outstanding balance.
class CreditCardFloatWarning extends StatelessWidget {
  const CreditCardFloatWarning({
    required this.accountId,
    required this.budgetId,
    // CC account balance — expected to be negative (debt) when riding float.
    required this.accountBalance,
    super.key,
  });

  final String accountId;
  final String budgetId;
  final int accountBalance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isRidingFloat(context),
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(72, 0, 16, 8),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 14,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  context.l10n.ccFloatWarning,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _isRidingFloat(BuildContext context) async {
    if (accountBalance >= 0) return false; // No debt — no float.
    final envelopeRepo = context.read<EnvelopeRepository>();
    try {
      final ccPaymentEnvelope = await envelopeRepo.getEnvelopeByLinkedAccountId(
        accountId,
        budgetId,
      );
      if (ccPaymentEnvelope == null) return false;

      final alloc = await envelopeRepo.getEnvelopeAllocation(
        ccPaymentEnvelope.id,
      );
      final allocated = alloc?.allocatedAmount ?? 0;
      final spent = await envelopeRepo.sumSpentForEnvelope(ccPaymentEnvelope.id);
      final reserved = allocated - spent;
      return reserved < accountBalance.abs();
    } on Exception {
      return false;
    }
  }
}
