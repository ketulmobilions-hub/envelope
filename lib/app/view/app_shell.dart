import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/transactions/view/transaction_form_page.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Shell widget providing persistent bottom navigation bar with 3 tabs
/// and a centered FAB for adding transactions.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const _tabs = [
    '/envelopes',
    '/transactions',
    '/accounts',
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) return i;
    }
    // Default to envelopes tab for /home and other routes.
    return 0;
  }

  void _onTabTap(BuildContext context, int index) {
    final authState = context.read<AuthBloc>().state;
    final budgetId = authState.user?.id ?? '';
    context.go('${_tabs[index]}?budgetId=$budgetId');
  }

  Future<void> _openAddTransaction(BuildContext context) async {
    final authState = context.read<AuthBloc>().state;
    final user = authState.user;
    if (user == null) return;

    final budgetId = user.id;

    unawaited(
      Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => TransactionFormPage(
            transactionRepository: context.read<TransactionRepository>(),
            accountRepository: context.read<AccountRepository>(),
            envelopeRepository: context.read<EnvelopeRepository>(),
            budgetRepository: context.read<BudgetRepository>(),
            budgetId: budgetId,
            userId: user.id,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedIndex = _selectedIndex(context);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTransaction(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onTabTap(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.mail_outline),
            selectedIcon: const Icon(Icons.mail),
            label: l10n.envelopesTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.transactionsTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_outlined),
            selectedIcon: const Icon(Icons.account_balance),
            label: l10n.accountsTitle,
          ),
        ],
      ),
    );
  }
}
