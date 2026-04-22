import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/bloc/bloc.dart';
import 'package:envelope/accounts/cubit/cubit.dart';
import 'package:envelope/accounts/view/account_detail_page.dart';
import 'package:envelope/accounts/view/account_form_page.dart';
import 'package:envelope/accounts/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/transactions/bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Page that provides [AccountsBloc] and displays the accounts list.
class AccountsPage extends StatelessWidget {
  const AccountsPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountsBloc(
        accountRepository: context.read<AccountRepository>(),
        budgetRepository: context.read<BudgetRepository>(),
        envelopeRepository: context.read<EnvelopeRepository>(),
        budgetId: budgetId,
      )..add(const AccountsStarted()),
      child: AccountsView(budgetId: budgetId),
    );
  }
}

class AccountsView extends StatelessWidget {
  const AccountsView({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<AccountsBloc, AccountsState>(
      listenWhen: (prev, curr) =>
          curr.status == AccountsStatus.error && curr.error != null,
      listener: (context, state) {
        final message = switch (state.error!) {
          AccountsError.loadFailed => l10n.accountsErrorLoadFailed,
          AccountsError.updateFailed => l10n.accountsErrorUpdateFailed,
          AccountsError.deleteFailed => l10n.accountsErrorDeleteFailed,
        };
        showAppSnackBar(context, SnackBar(content: Text(message)));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.accountsTitle),
          actions: [
            IconButton(
              onPressed: () => _openAddAccount(context),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: BlocBuilder<AccountsBloc, AccountsState>(
          builder: (context, state) {
            if (state.status == AccountsStatus.loading ||
                state.status == AccountsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.accounts.isEmpty) {
              return _EmptyState(onAdd: () => _openAddAccount(context));
            }

            return RefreshIndicator(
              onRefresh: () {
                final completer = Completer<void>();
                context.read<AccountsBloc>().add(
                      AccountsRefreshRequested(
                        onComplete: completer.complete,
                      ),
                    );
                return completer.future;
              },
              child: _AccountsList(
                state: state,
                budgetId: budgetId,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openAddAccount(BuildContext context) async {
    final bloc = context.read<AccountsBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => AccountFormCubit(
            accountRepository: context.read<AccountRepository>(),
            budgetRepository: context.read<BudgetRepository>(),
            envelopeRepository: context.read<EnvelopeRepository>(),
            budgetId: budgetId,
          ),
          child: const AccountFormPage(),
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const AccountsRefreshRequested());
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.accountsEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.accountsEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(l10n.accountsAddAccount),
          ),
        ],
      ),
    );
  }
}

class _AccountsList extends StatelessWidget {
  const _AccountsList({required this.state, required this.budgetId});

  final AccountsState state;
  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final grouped = state.activeAccountsByType;
    final archived = state.archivedAccounts;
    final typeOrder = grouped.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        AccountsTotalCard(totalBalance: state.totalBalance),
        for (final type in typeOrder) ...[
          _TypeHeader(type: type, l10n: l10n),
          for (final account in grouped[type]!) ...[
            AccountListTile(
              account: account,
              onTap: () => _openDetail(context, account),
              onArchive: () => _confirmArchive(context, account),
              onDelete: () => _confirmDelete(context, account),
            ),
            if (isCreditCard(account.type) && account.currentBalance < 0)
              CreditCardFloatWarning(
                accountId: account.id,
                budgetId: budgetId,
                accountBalance: account.currentBalance,
              ),
          ],
        ],
        if (archived.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              l10n.accountsArchived,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          for (final account in archived)
            AccountListTile(
              account: account,
              onTap: () => _openDetail(context, account),
              onArchive: () => context
                  .read<AccountsBloc>()
                  .add(AccountArchiveToggled(account)),
              onDelete: () => _confirmDelete(context, account),
            ),
        ],
      ],
    );
  }

  Future<void> _openDetail(
    BuildContext context,
    Account account,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AccountDetailCubit(
                accountRepository: context.read<AccountRepository>(),
                account: account,
              ),
            ),
            BlocProvider(
              create: (_) => TransactionsBloc(
                transactionRepository: context.read<TransactionRepository>(),
                accountRepository: context.read<AccountRepository>(),
                envelopeRepository: context.read<EnvelopeRepository>(),
                budgetId: account.budgetId,
              )
                ..add(const TransactionsStarted())
                ..add(
                  TransactionsFilterChanged(
                    TransactionsFilter(accountId: account.id),
                  ),
                ),
            ),
          ],
          child: const AccountDetailPage(),
        ),
      ),
    );
    if (context.mounted) {
      context.read<AccountsBloc>().add(const AccountsRefreshRequested());
    }
  }

  Future<void> _confirmArchive(
    BuildContext context,
    Account account,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.accountsArchiveConfirmTitle),
        content: Text(l10n.accountsArchiveConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.accountsReconcileCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.accountsArchive),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AccountsBloc>().add(AccountArchiveToggled(account));
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Account account,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.accountsDeleteConfirmTitle),
        content: Text(l10n.accountsDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.accountsReconcileCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor:
                  Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.accountsDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AccountsBloc>().add(AccountDeleted(account.id));
    }
  }
}

class _TypeHeader extends StatelessWidget {
  const _TypeHeader({required this.type, required this.l10n});

  final String type;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        localizedAccountType(type, l10n),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
