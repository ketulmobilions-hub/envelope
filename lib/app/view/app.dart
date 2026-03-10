import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/app/routes/routes.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/theme.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:report_repository/report_repository.dart';
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
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter();
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
