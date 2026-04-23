import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/cubit/cubit.dart';
import 'package:envelope/accounts/view/account_form_page.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope/accounts/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/transactions/bloc/bloc.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope/transactions/view/transaction_form_page.dart';
import 'package:envelope/transactions/widgets/widgets.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

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
        if (state.status == AccountDetailStatus.reconciled) {
          showAppSnackBar(
            context,
            SnackBar(content: Text(l10n.accountsReconciled)),
          );
        } else if (state.status == AccountDetailStatus.failure) {
          showAppSnackBar(
            context,
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
        final symbol = currencySymbol(context);
        final creditLimit = state.debtAccount?.creditLimit;
        final isCC = isCreditCard(account.type);

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
                        formatCents(account.currentBalance, symbol: symbol),
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
                      if (isCC && creditLimit != null) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _BalanceDetail(
                              label: l10n.accountsCreditLimitLabel,
                              amount: creditLimit,
                            ),
                            _BalanceDetail(
                              label: l10n.accountsAvailableCreditLabel,
                              amount: creditLimit + account.currentBalance,
                              errorWhenNegative: true,
                            ),
                          ],
                        ),
                      ],
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
              _AccountTransactionsList(
                account: account,
                budgetId: account.budgetId,
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
        builder: (_) => BlocProvider(
          create: (_) => AccountFormCubit(
            accountRepository: context.read<AccountRepository>(),
            budgetRepository: context.read<BudgetRepository>(),
            budgetId: account.budgetId,
            account: account,
          ),
          child: AccountFormPage(account: account),
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
    final symbol = currencySymbol(context);
    final cubit = context.read<AccountDetailCubit>();
    final controller = TextEditingController();

    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            String? balanceError;
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
                    '${formatCents(account.currentBalance, symbol: symbol)}',
                    style: Theme.of(dialogContext).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: isCreditCard(account.type)
                          ? l10n.accountsAmountOwedLabel
                          : l10n.accountsReconcileActualBalance,
                      prefixText: symbol,
                      errorText: balanceError,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        isCreditCard(account.type)
                            ? RegExp(r'^\d*\.?\d{0,2}')
                            : RegExp(r'^\-?\d*\.?\d{0,2}'),
                      ),
                    ],
                    onChanged: (_) {
                      if (balanceError != null) {
                        setDialogState(() => balanceError = null);
                      }
                    },
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
                    final raw =
                        double.tryParse(controller.text.trim());
                    if (raw != null && raw.abs() > maxDollarAmount) {
                      setDialogState(
                        () => balanceError = l10n.accountsBalanceTooLarge,
                      );
                      return;
                    }
                    var cents = parseCents(controller.text);
                    if (cents == null) return;
                    if (isCreditCard(account.type) && cents > 0) {
                      cents = -cents;
                    }
                    Navigator.of(dialogContext).pop(cents);
                  },
                  child: Text(l10n.accountsReconcileConfirm),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();

    if (result != null && context.mounted) {
      await cubit.reconcile(result);
    }
  }
}

class _AccountTransactionsList extends StatelessWidget {
  const _AccountTransactionsList({
    required this.account,
    required this.budgetId,
  });

  final Account account;
  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<TransactionsBloc, TransactionsState>(
      listenWhen: (prev, curr) =>
          curr.status == TransactionsStatus.error && curr.error != null,
      listener: (context, state) {
        final message = switch (state.error!) {
          TransactionsError.loadFailed => l10n.transactionsErrorLoadFailed,
          TransactionsError.deleteFailed => l10n.transactionsErrorDeleteFailed,
          TransactionsError.undoFailed => l10n.transactionsErrorUndoFailed,
        };
        showAppSnackBar(context, SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        if (state.status == TransactionsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final grouped = state.transactionsByDate;

        if (grouped.isEmpty) {
          return Card(
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        final sortedDates = grouped.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final date in sortedDates)
              TransactionDateGroup(
                date: date,
                transactions: grouped[date]!,
                allTransactions: state.transactions,
                accounts: state.accounts,
                envelopes: state.envelopes,
                splitEnvelopeIds: state.splitEnvelopeIds,
                onTap: (txn) => _openEdit(context, txn),
                onEdit: (txn) => _openEdit(context, txn),
                onDelete: (txn) => _onDelete(context, txn),
              ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Future<void> _openEdit(BuildContext context, Transaction transaction) async {
    final bloc = context.read<TransactionsBloc>();
    final budgetRepository = context.read<BudgetRepository>();
    final periods =
        await budgetRepository.watchBudgetPeriods(budgetId).first;
    String? periodId;
    if (periods.isNotEmpty) {
      final now = DateTime.now();
      final current = periods.firstWhere(
        (p) =>
            !p.isClosed &&
            !p.startDate.isAfter(now) &&
            !p.endDate.isBefore(now),
        orElse: () =>
            periods.where((p) => !p.isClosed).lastOrNull ?? periods.last,
      );
      periodId = current.id;
    }
    if (!context.mounted) return;
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => TransactionFormCubit(
            transactionRepository: context.read<TransactionRepository>(),
            accountRepository: context.read<AccountRepository>(),
            envelopeRepository: context.read<EnvelopeRepository>(),
            budgetRepository: context.read<BudgetRepository>(),
            budgetId: budgetId,
            userId: transaction.createdBy,
            budgetPeriodId: periodId,
            transaction: transaction,
          ),
          child: TransactionFormPage(transaction: transaction),
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const TransactionsRefreshRequested());
    }
  }

  void _onDelete(BuildContext context, Transaction transaction) {
    final l10n = context.l10n;
    final bloc = context.read<TransactionsBloc>()
      ..add(TransactionDeleted(transaction.id));
    showUndoSnackBar(
      context,
      message: l10n.transactionsDeleted,
      undoLabel: l10n.transactionsUndo,
      onUndo: () => bloc.add(const TransactionUndoDeleteRequested()),
    );
  }
}

class _BalanceDetail extends StatelessWidget {
  const _BalanceDetail({
    required this.label,
    required this.amount,
    this.errorWhenNegative = false,
  });

  final String label;
  final int amount;
  final bool errorWhenNegative;

  @override
  Widget build(BuildContext context) {
    final symbol = currencySymbol(context);
    final isOverLimit = errorWhenNegative && amount < 0;
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
          formatCents(amount, symbol: symbol),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isOverLimit
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
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
