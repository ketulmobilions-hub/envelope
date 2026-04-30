import 'package:budget_repository/budget_repository.dart';
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
    // Capture repos before async gaps to avoid stale context access.
    final envelopeRepo = context.read<EnvelopeRepository>();
    final budgetRepo = context.read<BudgetRepository>();
    try {
      final ccPaymentEnvelope = await envelopeRepo.getEnvelopeByLinkedAccountId(
        accountId,
        budgetId,
      );
      if (ccPaymentEnvelope == null) return false;

      // Find the current budget period.
      final periods = await budgetRepo.watchBudgetPeriods(budgetId).first;
      if (periods.isEmpty) return false;
      final now = DateTime.now();
      final current = periods.firstWhere(
        (p) =>
            !p.isClosed &&
            !p.startDate.isAfter(now) &&
            !p.endDate.isBefore(now),
        orElse: () =>
            periods.where((p) => !p.isClosed).lastOrNull ?? periods.last,
      );

      final alloc = await envelopeRepo.getEnvelopeAllocationByEnvelopeAndPeriod(
        envelopeId: ccPaymentEnvelope.id,
        budgetPeriodId: current.id,
      );

      final reserved = alloc != null
          ? EnvelopeRepository.calculateRollover(alloc)
          : 0;
      return reserved < accountBalance.abs();
    } on Exception {
      return false;
    }
  }
}
