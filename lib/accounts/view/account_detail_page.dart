import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/cubit/cubit.dart';
import 'package:envelope/accounts/view/account_form_page.dart';
import 'package:envelope/accounts/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Detail page for a single account showing balance info and reconciliation.
///
/// Expects an [AccountDetailCubit] to be provided above this widget.
class AccountDetailPage extends StatelessWidget {
  const AccountDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<AccountDetailCubit, AccountDetailState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.status == AccountDetailStatus.reconciled) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.accountsReconciled)),
            );
        } else if (state.status == AccountDetailStatus.failure) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                state.errorMessage ?? l10n.accountsErrorReconcileFailed,
              ),
              ),
            );
        }
      },
      builder: (context, state) {
        final account = state.account;

        return Scaffold(
          appBar: AppBar(
            title: Text(account.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: l10n.accountsEditAccount,
                onPressed: () => _openEdit(context, account),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Balance card.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        l10n.accountsCurrentBalance,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatCents(account.currentBalance),
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _BalanceDetail(
                            label: l10n.accountsStartingBalance,
                            amount: account.startingBalance,
                          ),
                          _BalanceDetail(
                            label: l10n.accountsRunningBalance,
                            amount: account.currentBalance,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Account info card.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(
                        label: l10n.accountsTypeLabel,
                        value: localizedAccountType(account.type, l10n),
                      ),
                      const Divider(),
                      _InfoRow(
                        label: l10n.accountsCurrencyLabel,
                        value: account.currency,
                      ),
                      if (account.isArchived) ...[
                        const Divider(),
                        _InfoRow(
                          label: l10n.accountsStatusLabel,
                          value: l10n.accountsArchived,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Reconcile button.
              OutlinedButton.icon(
                onPressed: state.status == AccountDetailStatus.submitting
                    ? null
                    : () => _showReconcileDialog(context, account),
                icon: const Icon(Icons.balance_outlined),
                label: Text(l10n.accountsReconcile),
              ),
              const SizedBox(height: 24),
              // Transactions placeholder.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.accountsTransactionsPlaceholder,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openEdit(BuildContext context, Account account) async {
    final cubit = context.read<AccountDetailCubit>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => AccountFormPage(
          accountRepository: context.read<AccountRepository>(),
          budgetRepository: context.read<BudgetRepository>(),
          budgetId: account.budgetId,
          account: account,
        ),
      ),
    );
    if (result == true && context.mounted) {
      await cubit.refresh();
    }
  }

  Future<void> _showReconcileDialog(
    BuildContext context,
    Account account,
  ) async {
    final l10n = context.l10n;
    final cubit = context.read<AccountDetailCubit>();
    final controller = TextEditingController();

    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.accountsReconcileTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.accountsReconcileDescription),
              const SizedBox(height: 8),
              Text(
                '${l10n.accountsCurrentBalance}: '
                '${formatCents(account.currentBalance)}',
                style: Theme.of(dialogContext).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: l10n.accountsReconcileActualBalance,
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\-?\d*\.?\d{0,2}'),
                  ),
                ],
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.accountsReconcileCancel),
            ),
            FilledButton(
              onPressed: () {
                final cents = parseCents(controller.text);
                if (cents == null) return;
                Navigator.of(dialogContext).pop(cents);
              },
              child: Text(l10n.accountsReconcileConfirm),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result != null && context.mounted) {
      await cubit.reconcile(result);
    }
  }
}

class _BalanceDetail extends StatelessWidget {
  const _BalanceDetail({required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          formatCents(amount),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
