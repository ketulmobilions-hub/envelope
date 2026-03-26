import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/onboarding_cubit.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope/transactions/view/transaction_form_page.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Shell widget providing persistent bottom navigation bar.
///
/// Tabs: Home, Transactions, Add Transaction, Accounts, Goals.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  /// Tab index 2 is the "add transaction" action, not a route.
  static const int _addTransactionIndex = 2;

  static const List<String?> _tabs = [
    '/home',
    '/transactions',
    null, // placeholder for add transaction button
    '/accounts',
    '/goals',
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabs.length; i++) {
      final tab = _tabs[i];
      if (tab != null && location.startsWith(tab)) return i;
    }
    // Default to home tab for unmatched routes.
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == _addTransactionIndex) {
      unawaited(_openAddTransaction(context));
      return;
    }
    final route = _tabs[index];
    if (route == null) return;
    final budgetId =
        context.read<SharedPreferences>().getString(activeBudgetIdKey) ?? '';
    context.go('$route?budgetId=$budgetId');
  }

  Future<void> _openAddTransaction(BuildContext context) async {
    final authState = context.read<AuthBloc>().state;
    final user = authState.user;
    if (user == null) return;

    final budgetId =
        context.read<SharedPreferences>().getString(activeBudgetIdKey) ?? '';

    final periodId = await _getCurrentPeriodId(
      context.read<BudgetRepository>(),
      budgetId,
    );

    if (!context.mounted) return;

    unawaited(
      Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => TransactionFormCubit(
              transactionRepository: context.read<TransactionRepository>(),
              accountRepository: context.read<AccountRepository>(),
              envelopeRepository: context.read<EnvelopeRepository>(),
              budgetId: budgetId,
              budgetPeriodId: periodId,
              userId: user.id,
            ),
            child: const TransactionFormPage(),
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
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.homeTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.transactionsTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline, size: 32),
            selectedIcon: const Icon(Icons.add_circle, size: 32),
            label: l10n.transactionsAddTransaction,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_outlined),
            selectedIcon: const Icon(Icons.account_balance),
            label: l10n.accountsTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.flag_outlined),
            selectedIcon: const Icon(Icons.flag),
            label: l10n.goalsTitle,
          ),
        ],
      ),
    );
  }
}

/// Resolves the current (open) budget period ID.
Future<String?> _getCurrentPeriodId(
  BudgetRepository budgetRepository,
  String budgetId,
) async {
  try {
    final periods =
        await budgetRepository.watchBudgetPeriods(budgetId).first;
    if (periods.isEmpty) return null;
    final now = DateTime.now();
    final current = periods.firstWhere(
      (p) =>
          !p.isClosed &&
          !p.startDate.isAfter(now) &&
          !p.endDate.isBefore(now),
      orElse: () =>
          periods.where((p) => !p.isClosed).lastOrNull ?? periods.last,
    );
    return current.id;
  } on Exception {
    return null;
  }
}
