import 'dart:async';

import 'package:envelope/accounts/accounts.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/budget/budget.dart';
import 'package:envelope/dashboard/dashboard.dart';
import 'package:envelope/envelopes/envelopes.dart';
import 'package:envelope/onboarding/onboarding.dart';
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
}

/// Creates the application [GoRouter] with auth-based redirects.
GoRouter createRouter({
  required AuthBloc authBloc,
  required SharedPreferences sharedPreferences,
}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _AuthBlocListenable(authBloc),
    redirect: (context, state) {
      final authStatus = authBloc.state.status;
      final currentPath = state.matchedLocation;

      // While auth status is unknown, stay on splash.
      if (authStatus == AuthStatus.unknown) {
        return currentPath == AppRoutes.splash
            ? null
            : AppRoutes.splash;
      }

      // If unauthenticated, allow login, signUp, and forgotPassword.
      if (authStatus == AuthStatus.unauthenticated) {
        const publicRoutes = [
          AppRoutes.login,
          AppRoutes.signUp,
          AppRoutes.forgotPassword,
        ];
        return publicRoutes.contains(currentPath)
            ? null
            : AppRoutes.login;
      }

      // Authenticated: read onboarding status live from prefs.
      final onboarded = sharedPreferences
              .getBool('onboarding_complete') ??
          false;

      if (!onboarded) {
        // Allow staying on onboarding page.
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
        name: AppRoutes.home,
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: AppRoutes.accounts,
        path: AppRoutes.accounts,
        redirect: (context, state) {
          final budgetId = state.uri.queryParameters['budgetId'];
          if (budgetId == null || budgetId.isEmpty) {
            return AppRoutes.home;
          }
          return null;
        },
        builder: (context, state) {
          final budgetId = state.uri.queryParameters['budgetId']!;
          return AccountsPage(budgetId: budgetId);
        },
      ),
      GoRoute(
        name: AppRoutes.envelopes,
        path: AppRoutes.envelopes,
        redirect: (context, state) {
          final budgetId = state.uri.queryParameters['budgetId'];
          if (budgetId == null || budgetId.isEmpty) {
            return AppRoutes.home;
          }
          return null;
        },
        builder: (context, state) {
          final budgetId = state.uri.queryParameters['budgetId']!;
          return EnvelopesPage(budgetId: budgetId);
        },
      ),
      GoRoute(
        name: AppRoutes.budget,
        path: AppRoutes.budget,
        redirect: (context, state) {
          final budgetId = state.uri.queryParameters['budgetId'];
          if (budgetId == null || budgetId.isEmpty) {
            return AppRoutes.home;
          }
          return null;
        },
        builder: (context, state) {
          final budgetId = state.uri.queryParameters['budgetId']!;
          return BudgetPage(budgetId: budgetId);
        },
      ),
      GoRoute(
        name: AppRoutes.transactions,
        path: AppRoutes.transactions,
        redirect: (context, state) {
          final budgetId = state.uri.queryParameters['budgetId'];
          if (budgetId == null || budgetId.isEmpty) {
            return AppRoutes.home;
          }
          return null;
        },
        builder: (context, state) {
          final budgetId = state.uri.queryParameters['budgetId']!;
          return TransactionsPage(budgetId: budgetId);
        },
      ),
    ],
  );
}

/// Adapts [AuthBloc] stream to a [ChangeNotifier] for GoRouter's
/// `refreshListenable`.
class _AuthBlocListenable extends ChangeNotifier {
  _AuthBlocListenable(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
