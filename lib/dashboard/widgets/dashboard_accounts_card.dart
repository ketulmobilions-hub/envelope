import 'package:account_repository/account_repository.dart';
import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:flutter/material.dart';

/// Displays total balance and top accounts on the dashboard.
class DashboardAccountsCard extends StatelessWidget {
  const DashboardAccountsCard({
    required this.accounts,
    required this.totalBalance,
    this.onTap,
    super.key,
  });

  final List<Account> accounts;
  final int totalBalance;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final symbol = currencySymbol(context);
    final allActive = accounts.where((a) => !a.isArchived).toList();
    final activeAccounts = allActive.take(3).toList();
    final hiddenCount = allActive.length - activeAccounts.length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.dashboardTotalBalance,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (onTap != null)
                    Text(
                      hiddenCount > 0
                          ? l10n.dashboardViewAllCount(allActive.length)
                          : l10n.dashboardViewAll,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                formatCents(totalBalance, symbol: symbol),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: totalBalance < 0 ? theme.colorScheme.error : null,
                ),
              ),
              if (activeAccounts.isNotEmpty) ...[
                const Divider(height: 24),
                ...activeAccounts.map(
                  (account) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            account.name,
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          formatCents(account.currentBalance, symbol: symbol),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: account.currentBalance < 0
                                ? theme.colorScheme.error
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
