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

  // Cached references to avoid context.read after async gaps.
  late final SharedPreferences _prefs;
  late final EnvelopeApiClient _apiClient;
  late final AppDatabase _db;
  late final AuthBloc _authBloc;

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
      _sessionTask = (_sessionTask ?? Future.value())
          .then((_) => _restoreSessionForUser(state.user!.id));
    } else if (state.status == AuthStatus.unauthenticated) {
      unawaited(
        _fcmService.unregisterCurrentToken(
          repository: widget.notificationRepository,
        ),
      );
      _sessionTask = _clearLocalData();
    }
  }

  /// On sign-in, checks the server for budgets, sets the correct flags,
  /// and re-triggers the router.
  Future<void> _restoreSessionForUser(String userId) async {
    try {
      // Always start fresh — clear any leftover flags from a prior user.
      await _prefs.remove('onboarding_complete');
      await _prefs.remove('active_budget_id');
      await _prefs.remove('session_checked');

      debugPrint('[Session] Fetching budgets for $userId...');
      final budgets = await _apiClient.budgets.getBudgetsByOwner(userId);
      debugPrint('[Session] Found ${budgets.length} budgets');

      if (budgets.isNotEmpty) {
        await _prefs.setBool('onboarding_complete', true);
        await _prefs.setString('active_budget_id', budgets.first.id);
        debugPrint('[Session] Restored: onboarding_complete=true, '
            'budget=${budgets.first.id}');
      } else {
        debugPrint('[Session] New user — no budgets found');
      }

      // Mark session check as done so the router stops holding on splash.
      await _prefs.setBool('session_checked', true);
    } on Exception catch (e) {
      debugPrint('[Session] Error during restore: $e');
      // On failure, still mark session_checked so user isn't stuck.
      await _prefs.setBool('session_checked', true);
    }

    // Re-trigger router to act on updated flags.
    final user = _authBloc.state.user;
    if (user != null) {
      _authBloc.add(AuthUserChanged(user));
    }
  }

  Future<void> _clearLocalData() async {
    try {
      await _prefs.remove('onboarding_complete');
      await _prefs.remove('active_budget_id');
      await _prefs.remove('session_checked');
      await _db.clearAllTables();
      debugPrint('[Session] Local data cleared');
    } on Exception catch (e) {
      debugPrint('[Session] Error clearing local data: $e');
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
    // Enable edge-to-edge rendering on Android.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
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
