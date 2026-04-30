import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:flutter/material.dart';

/// Displays the total balance across all active accounts.
class AccountsTotalCard extends StatelessWidget {
  const AccountsTotalCard({required this.totalBalance, super.key});

  final int totalBalance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              l10n.accountsTotalBalance,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatCents(totalBalance, symbol: symbol),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: totalBalance < 0
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
