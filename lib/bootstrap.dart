import 'dart:async';
import 'dart:developer';

import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/app/app.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:report_repository/report_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_repository/sharing_repository.dart';
import 'package:subscription_repository/subscription_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sync_repository/sync_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap({
  required String supabaseUrl,
  required String supabaseAnonKey,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  final apiClient = EnvelopeApiClient(
    supabaseClient: Supabase.instance.client,
  );
  final localDatabase = AppDatabase();

  // Generate or retrieve a persistent device ID for sync tracking.
  final prefs = await SharedPreferences.getInstance();
  var deviceId = prefs.getString('device_id');
  if (deviceId == null) {
    deviceId = const Uuid().v4();
    await prefs.setString('device_id', deviceId);
  }

  final authRepository = AuthRepository(apiClient: apiClient);
  final accountRepository = AccountRepository(
    apiClient: apiClient,
    localDatabase: localDatabase,
  );
  final budgetRepository = BudgetRepository(
    apiClient: apiClient,
    localDatabase: localDatabase,
  );
  final envelopeRepository = EnvelopeRepository(
    apiClient: apiClient,
    localDatabase: localDatabase,
  );
  final transactionRepository = TransactionRepository(
    apiClient: apiClient,
    localDatabase: localDatabase,
  );
  final goalRepository = GoalRepository(
    apiClient: apiClient,
    localDatabase: localDatabase,
  );
  final reportRepository = ReportRepository(
    apiClient: apiClient,
    localDatabase: localDatabase,
  );
  final notificationRepository = NotificationRepository(
    apiClient: apiClient,
    localDatabase: localDatabase,
  );
  final sharingRepository = SharingRepository(
    apiClient: apiClient,
    localDatabase: localDatabase,
  );
  final subscriptionRepository = SubscriptionRepository(
    apiClient: apiClient,
  );
  final syncRepository = SyncRepository(
    localDatabase: localDatabase,
    deviceId: deviceId,
  );

  runApp(
    App(
      authRepository: authRepository,
      accountRepository: accountRepository,
      budgetRepository: budgetRepository,
      envelopeRepository: envelopeRepository,
      transactionRepository: transactionRepository,
      goalRepository: goalRepository,
      reportRepository: reportRepository,
      notificationRepository: notificationRepository,
      sharingRepository: sharingRepository,
      subscriptionRepository: subscriptionRepository,
      syncRepository: syncRepository,
    ),
  );
}
