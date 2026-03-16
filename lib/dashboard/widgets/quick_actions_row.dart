import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Horizontal row of quick-action buttons for the dashboard.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    this.onAddTransaction,
    this.onViewBudget,
    this.onViewAccounts,
    super.key,
  });

  final VoidCallback? onAddTransaction;
  final VoidCallback? onViewBudget;
  final VoidCallback? onViewAccounts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _ActionChip(
              icon: Icons.add,
              label: l10n.dashboardQuickAdd,
              onTap: onAddTransaction,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionChip(
              icon: Icons.pie_chart_outline,
              label: l10n.dashboardViewBudget,
              onTap: onViewBudget,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionChip(
              icon: Icons.account_balance_outlined,
              label: l10n.dashboardViewAccounts,
              onTap: onViewAccounts,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
