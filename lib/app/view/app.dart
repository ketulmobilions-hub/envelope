import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart';
import 'package:envelope/app/routes/routes.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/notifications/services/fcm_service.dart';
import 'package:envelope/sync/sync.dart';
import 'package:envelope/theme/theme.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    required this.apiClient,
    required this.localDatabase,
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
  final EnvelopeApiClient apiClient;
  final AppDatabase localDatabase;

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
        RepositoryProvider.value(value: apiClient),
        RepositoryProvider.value(value: localDatabase),
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
        child: Builder(
          builder: (context) {
            final notifier = RouterRefreshNotifier(context.read<AuthBloc>());
            return _FcmAuthListener(
              notificationRepository: notificationRepository,
              routerNotifier: notifier,
              child: AppView(
                sharedPreferences: sharedPreferences,
                routerNotifier: notifier,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Listens to auth state changes and manages FCM token lifecycle.
class _FcmAuthListener extends StatefulWidget {
  const _FcmAuthListener({
    required this.notificationRepository,
    required this.routerNotifier,
    required this.child,
  });

  final NotificationRepository notificationRepository;
  final RouterRefreshNotifier routerNotifier;
  final Widget child;

  @override
  State<_FcmAuthListener> createState() => _FcmAuthListenerState();
}

class _FcmAuthListenerState extends State<_FcmAuthListener> {
  final FcmService _fcmService = FcmService();

  // Cached references to avoid context.read after async gaps.
  late final SharedPreferences _prefs;
  late final EnvelopeApiClient _apiClient;
  late final AppDatabase _db;
  late final AuthBloc _authBloc;
  RouterRefreshNotifier get _routerNotifier => widget.routerNotifier;

  @override
  void initState() {
    super.initState();
    _prefs = context.read<SharedPreferences>();
    _apiClient = context.read<EnvelopeApiClient>();
    _db = context.read<AppDatabase>();
    _authBloc = context.read<AuthBloc>();
  }

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

  /// Sequenced so that clear always finishes before restore starts.
  Future<void>? _sessionTask;

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.authenticated && state.user != null) {
      unawaited(
        _fcmService.initialize(
          userId: state.user!.id,
          repository: widget.notificationRepository,
          platform: _currentPlatform(),
        ),
      );
      // Chain after any pending clear so restore never races with it.
      _sessionTask = (_sessionTask ?? Future.value()).then(
        (_) => _restoreSessionForUser(state.user!.id),
      );
    } else if (state.status == AuthStatus.unauthenticated) {
      unawaited(
        _fcmService.unregisterCurrentToken(
          repository: widget.notificationRepository,
        ),
      );
      _sessionTask = _clearLocalData();
    }
  }

  /// On sign-in, fetches budgets from the server to determine if the
  /// user has onboarded. Sets `active_budget_id` if a budget exists,
  /// then marks `session_resolved` and refreshes the router.
  Future<void> _restoreSessionForUser(String userId) async {
    try {
      // Hold the router on splash while we restore by clearing session_resolved.
      // active_budget_id is intentionally NOT removed here — SharedPreferences
      // updates its in-memory cache immediately on remove(), so clearing it
      // before the API call completes causes HomePage.build() to read an empty
      // budgetId and create DashboardBloc with no budget.  The setString call
      // below overwrites it once the correct value is known.
      await _prefs.remove('session_resolved');

      final budgets = await _apiClient.budgets.getBudgetsByOwner(userId);

      if (budgets.isNotEmpty) {
        await _prefs.setString('active_budget_id', budgets.first.id);
      } else {
        // No budgets found — clear so the router sends the user to onboarding.
        await _prefs.remove('active_budget_id');
      }
    } on Exception {
      // On failure, keep the existing active_budget_id so the user stays on
      // the dashboard rather than being bounced to onboarding.
    }

    // Always mark resolved so the router stops holding on splash.
    await _prefs.setBool('session_resolved', true);
    _routerNotifier.refresh();
  }

  Future<void> _clearLocalData() async {
    try {
      await _prefs.remove('active_budget_id');
      await _prefs.remove('session_resolved');
      await _db.clearAllTables();
    } on Exception {
      // Best-effort cleanup.
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
  const AppView({
    required this.sharedPreferences,
    required this.routerNotifier,
    super.key,
  });

  final SharedPreferences sharedPreferences;
  final RouterRefreshNotifier routerNotifier;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Enable edge-to-edge rendering on Android.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    final authBloc = context.read<AuthBloc>();
    _router = createRouter(
      authBloc: authBloc,
      sharedPreferences: widget.sharedPreferences,
      refreshNotifier: widget.routerNotifier,
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
