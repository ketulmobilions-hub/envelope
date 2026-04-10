import 'dart:async';

import 'package:envelope/accounts/accounts.dart';
import 'package:envelope/app/view/app_shell.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/budget/budget.dart';
import 'package:envelope/dashboard/dashboard.dart';
import 'package:envelope/envelopes/envelopes.dart';
import 'package:envelope/goals/goals.dart';
import 'package:envelope/onboarding/onboarding.dart';
import 'package:envelope/recurring/recurring.dart';
import 'package:envelope/reports/reports.dart';
import 'package:envelope/settings/settings.dart';
import 'package:envelope/shared_budget/shared_budget.dart';
import 'package:envelope/shared_budget/view/redeem_invite_page.dart';
import 'package:envelope/splash/splash.dart';
import 'package:envelope/transactions/transactions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Route path constants.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
  static const String onboarding = '/onboarding';
  static const String accounts = '/accounts';
  static const String envelopes = '/envelopes';
  static const String budget = '/budget';
  static const String transactions = '/transactions';
  static const String goals = '/goals';
  static const String recurring = '/recurring';
  static const String reports = '/reports';
  static const String sharedBudget = '/sharedBudget';
  static const String settings = '/settings';
  static const String redeemInvite = '/invite';
}

/// Creates the application [GoRouter] with auth-based redirects.
GoRouter createRouter({
  required AuthBloc authBloc,
  required SharedPreferences sharedPreferences,
  required RouterRefreshNotifier refreshNotifier,
}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authStatus = authBloc.state.status;
      final currentPath = state.matchedLocation;

      // While auth status is unknown, stay on splash.
      if (authStatus == AuthStatus.unknown) {
        return currentPath == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // If unauthenticated, allow login, signUp, and forgotPassword.
      if (authStatus == AuthStatus.unauthenticated) {
        const publicRoutes = [
          AppRoutes.login,
          AppRoutes.signUp,
          AppRoutes.forgotPassword,
        ];
        return publicRoutes.contains(currentPath) ? null : AppRoutes.login;
      }

      // Wait for session restore to complete before routing.
      final sessionResolved =
          sharedPreferences.getBool('session_resolved') ?? false;
      if (!sessionResolved) {
        return currentPath == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // If no active budget, user needs onboarding.
      final activeBudgetId = sharedPreferences.getString('active_budget_id');
      if (activeBudgetId == null || activeBudgetId.isEmpty) {
        if (currentPath == AppRoutes.onboarding) return null;
        return AppRoutes.onboarding;
      }

      // Authenticated + onboarded: redirect away from
      // auth/splash/onboarding.
      const redirectToHome = [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.signUp,
        AppRoutes.onboarding,
      ];
      if (redirectToHome.contains(currentPath)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: AppRoutes.splash,
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: AppRoutes.login,
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: AppRoutes.signUp,
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        name: AppRoutes.forgotPassword,
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        name: AppRoutes.onboarding,
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '${AppRoutes.redeemInvite}/:inviteId',
        builder: (context, state) {
          final inviteId = state.pathParameters['inviteId']!;
          return RedeemInvitePage(inviteId: inviteId);
        },
      ),
      // Shell route wraps tabs with persistent bottom nav.
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            name: AppRoutes.home,
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            name: AppRoutes.envelopes,
            path: AppRoutes.envelopes,
            redirect: _requireBudgetId,
            builder: (context, state) {
              final budgetId = state.uri.queryParameters['budgetId']!;
              return EnvelopesPage(budgetId: budgetId);
            },
          ),
          GoRoute(
            name: AppRoutes.transactions,
            path: AppRoutes.transactions,
            redirect: _requireBudgetId,
            builder: (context, state) {
              final budgetId = state.uri.queryParameters['budgetId']!;
              return TransactionsPage(budgetId: budgetId);
            },
          ),
          GoRoute(
            name: AppRoutes.accounts,
            path: AppRoutes.accounts,
            redirect: _requireBudgetId,
            builder: (context, state) {
              final budgetId = state.uri.queryParameters['budgetId']!;
              return AccountsPage(budgetId: budgetId);
            },
          ),
          GoRoute(
            name: AppRoutes.goals,
            path: AppRoutes.goals,
            redirect: _requireBudgetId,
            builder: (context, state) {
              final budgetId = state.uri.queryParameters['budgetId']!;
              return GoalsPage(budgetId: budgetId);
            },
          ),
          GoRoute(
            name: AppRoutes.budget,
            path: AppRoutes.budget,
            redirect: _requireBudgetId,
            builder: (context, state) {
              final budgetId = state.uri.queryParameters['budgetId']!;
              return BudgetPage(budgetId: budgetId);
            },
          ),
          GoRoute(
            name: AppRoutes.recurring,
            path: AppRoutes.recurring,
            redirect: _requireBudgetId,
            builder: (context, state) {
              final budgetId = state.uri.queryParameters['budgetId']!;
              return RecurringPage(budgetId: budgetId);
            },
          ),
          GoRoute(
            name: AppRoutes.reports,
            path: AppRoutes.reports,
            redirect: _requireBudgetId,
            builder: (context, state) {
              final budgetId = state.uri.queryParameters['budgetId']!;
              return ReportsPage(budgetId: budgetId);
            },
          ),
          GoRoute(
            name: AppRoutes.sharedBudget,
            path: AppRoutes.sharedBudget,
            redirect: _requireBudgetId,
            builder: (context, state) {
              final budgetId = state.uri.queryParameters['budgetId']!;
              return SharedBudgetPage(budgetId: budgetId);
            },
          ),
          GoRoute(
            name: AppRoutes.settings,
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}

/// Shared redirect that ensures budgetId is present.
String? _requireBudgetId(BuildContext context, GoRouterState state) {
  final budgetId = state.uri.queryParameters['budgetId'];
  if (budgetId == null || budgetId.isEmpty) {
    return AppRoutes.home;
  }
  return null;
}

/// Adapts [AuthBloc] stream to a [ChangeNotifier] for GoRouter's
/// `refreshListenable`. Also exposes [refresh] for manual triggers
/// (e.g. after session restore updates SharedPreferences).
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  /// Manually trigger a router re-evaluation.
  void refresh() => notifyListeners();

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
