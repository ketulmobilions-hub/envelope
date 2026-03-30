import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/app/routes/routes.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/notifications/services/fcm_service.dart';
import 'package:envelope/sync/sync.dart';
import 'package:envelope/theme/theme.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:report_repository/report_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_repository/sharing_repository.dart';
import 'package:subscription_repository/subscription_repository.dart';
import 'package:sync_repository/sync_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

class App extends StatelessWidget {
  const App({
    required this.authRepository,
    required this.accountRepository,
    required this.budgetRepository,
    required this.envelopeRepository,
    required this.transactionRepository,
    required this.goalRepository,
    required this.reportRepository,
    required this.notificationRepository,
    required this.sharingRepository,
    required this.subscriptionRepository,
    required this.syncRepository,
    required this.sharedPreferences,
    super.key,
  });

  final AuthRepository authRepository;
  final AccountRepository accountRepository;
  final BudgetRepository budgetRepository;
  final EnvelopeRepository envelopeRepository;
  final TransactionRepository transactionRepository;
  final GoalRepository goalRepository;
  final ReportRepository reportRepository;
  final NotificationRepository notificationRepository;
  final SharingRepository sharingRepository;
  final SubscriptionRepository subscriptionRepository;
  final SyncRepository syncRepository;
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: accountRepository),
        RepositoryProvider.value(value: budgetRepository),
        RepositoryProvider.value(value: envelopeRepository),
        RepositoryProvider.value(value: transactionRepository),
        RepositoryProvider.value(value: goalRepository),
        RepositoryProvider.value(value: reportRepository),
        RepositoryProvider.value(value: notificationRepository),
        RepositoryProvider.value(value: sharingRepository),
        RepositoryProvider.value(value: subscriptionRepository),
        RepositoryProvider.value(value: syncRepository),
        RepositoryProvider<SharedPreferences>.value(value: sharedPreferences),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authRepository: authRepository),
          ),
          BlocProvider(
            create: (_) =>
                SyncBloc(syncRepository: syncRepository)
                  ..add(const SyncStarted()),
          ),
        ],
        child: _FcmAuthListener(
          notificationRepository: notificationRepository,
          child: AppView(sharedPreferences: sharedPreferences),
        ),
      ),
    );
  }
}

/// Listens to auth state changes and manages FCM token lifecycle.
class _FcmAuthListener extends StatefulWidget {
  const _FcmAuthListener({
    required this.notificationRepository,
    required this.child,
  });

  final NotificationRepository notificationRepository;
  final Widget child;

  @override
  State<_FcmAuthListener> createState() => _FcmAuthListenerState();
}

class _FcmAuthListenerState extends State<_FcmAuthListener> {
  final FcmService _fcmService = FcmService();

  String _currentPlatform() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return defaultTargetPlatform.name;
    }
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.authenticated && state.user != null) {
      unawaited(
        _fcmService.initialize(
          userId: state.user!.id,
          repository: widget.notificationRepository,
          platform: _currentPlatform(),
        ),
      );
    } else if (state.status == AuthStatus.unauthenticated) {
      unawaited(
        _fcmService.unregisterCurrentToken(
          repository: widget.notificationRepository,
        ),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_fcmService.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _onAuthStateChanged,
      child: widget.child,
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({required this.sharedPreferences, super.key});

  final SharedPreferences sharedPreferences;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    _router = createRouter(
      authBloc: authBloc,
      sharedPreferences: widget.sharedPreferences,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, curr) => prev.user?.themeMode != curr.user?.themeMode,
      builder: (context, authState) {
        return MaterialApp.router(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: _themeModeFromString(
            authState.user?.themeMode ?? 'system',
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
        );
      },
    );
  }
}

ThemeMode _themeModeFromString(String mode) {
  switch (mode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}
