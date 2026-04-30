import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/app/routes/app_router.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/onboarding_cubit.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/widgets/debug_clock_banner.dart';
import 'package:flutter/foundation.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope/transactions/view/transaction_form_page.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Breakpoint for switching between bottom nav and side rail.
const double _wideBreakpoint = 900;

/// Shell widget providing persistent navigation.
///
/// - Narrow (<900px): bottom [NavigationBar] (mobile/phone)
/// - Wide (>=900px): side [NavigationRail] (tablet/web/desktop)
///
/// Tabs: Home, Transactions, Add Transaction, Accounts, Goals.
class AppShell extends StatefulWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  /// Tab index 2 is the "add transaction" action, not a route.
  static const int _addTransactionIndex = 2;

  static const List<String?> _tabs = [
    '/home',
    '/transactions',
    null, // placeholder for add transaction button
    '/accounts',
    '/goals',
  ];

  late final AnimationController _controller;
  late final CurvedAnimation _curvedAnimation;
  late final Tween<Offset> _slideTween;
  late final Animation<Offset> _slideAnimation;

  bool _shouldAnimate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideTween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
    _slideAnimation = _slideTween.animate(_curvedAnimation);
  }

  @override
  void dispose() {
    _curvedAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldAnimate && oldWidget.child != widget.child) {
      _shouldAnimate = false;
      _controller.reset();
      unawaited(_controller.forward());
    }
  }

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabs.length; i++) {
      final tab = _tabs[i];
      if (tab != null && location.startsWith(tab)) return i;
    }
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == _addTransactionIndex) {
      unawaited(_openAddTransaction(context));
      return;
    }
    final route = _tabs[index];
    if (route == null) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    final isForward = index > _selectedIndex(context);
    _slideTween.begin = isForward ? const Offset(1, 0) : const Offset(-1, 0);
    _shouldAnimate = true;

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

    final appClock = context.read<AppClock>();
    final periodId = await _getCurrentPeriodId(
      context.read<BudgetRepository>(),
      budgetId,
      now: appClock.now(),
    );

    if (!context.mounted) return;

    unawaited(
      Navigator.of(context).push<bool>(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
            create: (_) => TransactionFormCubit(
              transactionRepository: context.read<TransactionRepository>(),
              accountRepository: context.read<AccountRepository>(),
              envelopeRepository: context.read<EnvelopeRepository>(),
              budgetRepository: context.read<BudgetRepository>(),
              budgetId: budgetId,
              budgetPeriodId: periodId,
              userId: user.id,
              now: appClock.now,
            ),
            child: const TransactionFormPage(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedIndex = _selectedIndex(context);

    final clipped = ClipRect(
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
    final animatedChild = kDebugMode
        ? Column(
            children: [
              DebugClockBanner(appClock: context.read<AppClock>()),
              Expanded(child: clipped),
            ],
          )
        : clipped;

    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
            const _AddTransactionIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyN):
            const _AddTransactionIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.comma):
            const _OpenSettingsIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.comma):
            const _OpenSettingsIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit1):
            const _NavigateTabIntent(0),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit2):
            const _NavigateTabIntent(1),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit3):
            const _NavigateTabIntent(3),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit4):
            const _NavigateTabIntent(4),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.digit1):
            const _NavigateTabIntent(0),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.digit2):
            const _NavigateTabIntent(1),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.digit3):
            const _NavigateTabIntent(3),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.digit4):
            const _NavigateTabIntent(4),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _AddTransactionIntent: CallbackAction<_AddTransactionIntent>(
            onInvoke: (_) {
              unawaited(_openAddTransaction(context));
              return null;
            },
          ),
          _OpenSettingsIntent: CallbackAction<_OpenSettingsIntent>(
            onInvoke: (_) {
              context.go(AppRoutes.settings);
              return null;
            },
          ),
          _NavigateTabIntent: CallbackAction<_NavigateTabIntent>(
            onInvoke: (intent) {
              _onDestinationSelected(context, intent.tabIndex);
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= _wideBreakpoint;

              if (isWide) {
                return _WideLayout(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (i) =>
                      _onDestinationSelected(context, i),
                  onAddTransaction: () => _openAddTransaction(context),
                  l10n: l10n,
                  child: animatedChild,
                );
              }

              return Scaffold(
                body: animatedChild,
                bottomNavigationBar: NavigationBar(
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      _onDestinationSelected(context, index),
                  destinations: _buildDestinations(l10n),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static List<NavigationDestination> _buildDestinations(AppLocalizations l10n) {
    return [
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
    ];
  }
}

/// Wide layout with [NavigationRail] on the left.
class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onAddTransaction,
    required this.l10n,
    required this.child,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onAddTransaction;
  final AppLocalizations l10n;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Map the 5-item tab list (with null at index 2) to NavigationRail
    // destinations, skipping the add-transaction placeholder.
    final railIndex = selectedIndex > 2 ? selectedIndex - 1 : selectedIndex;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: railIndex,
            onDestinationSelected: (index) {
              // Map rail index back to tab index (skip index 2).
              final tabIndex = index >= 2 ? index + 1 : index;
              onDestinationSelected(tabIndex);
            },
            labelType: NavigationRailLabelType.all,
            leading: FloatingActionButton(
              onPressed: onAddTransaction,
              child: const Icon(Icons.add),
            ),
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: Text(l10n.homeTitle),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.receipt_long_outlined),
                selectedIcon: const Icon(Icons.receipt_long),
                label: Text(l10n.transactionsTitle),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.account_balance_outlined),
                selectedIcon: const Icon(Icons.account_balance),
                label: Text(l10n.accountsTitle),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.flag_outlined),
                selectedIcon: const Icon(Icons.flag),
                label: Text(l10n.goalsTitle),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Keyboard shortcut intents
// ---------------------------------------------------------------------------

class _AddTransactionIntent extends Intent {
  const _AddTransactionIntent();
}

class _OpenSettingsIntent extends Intent {
  const _OpenSettingsIntent();
}

class _NavigateTabIntent extends Intent {
  const _NavigateTabIntent(this.tabIndex);

  final int tabIndex;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Resolves the current (open) budget period ID.
Future<String?> _getCurrentPeriodId(
  BudgetRepository budgetRepository,
  String budgetId, {
  DateTime? now,
}) async {
  try {
    final periods = await budgetRepository.watchBudgetPeriods(budgetId).first;
    if (periods.isEmpty) return null;
    final effectiveNow = now ?? DateTime.now();
    final current = periods.firstWhere(
      (p) =>
          !p.isClosed &&
          !p.startDate.isAfter(effectiveNow) &&
          !p.endDate.isBefore(effectiveNow),
      orElse: () =>
          periods.where((p) => !p.isClosed).lastOrNull ?? periods.last,
    );
    return current.id;
  } on Exception {
    return null;
  }
}
