import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/app/app.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sharing_repository/sharing_repository.dart';
import 'package:subscription_repository/subscription_repository.dart';
import 'package:sync_repository/sync_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class MockTransactionRepository extends Mock
    implements TransactionRepository {}

class MockGoalRepository extends Mock implements GoalRepository {}

class MockReportRepository extends Mock implements ReportRepository {}

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

class MockSharingRepository extends Mock implements SharingRepository {}

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

class MockSyncRepository extends Mock implements SyncRepository {}

void main() {
  group('App', () {
    late MockAuthRepository authRepository;
    late MockSyncRepository syncRepository;

    setUp(() {
      authRepository = MockAuthRepository();
      syncRepository = MockSyncRepository();
      when(() => authRepository.user).thenAnswer(
        (_) => const Stream<User>.empty(),
      );
      when(() => authRepository.currentUser).thenReturn(User.empty);
      when(() => syncRepository.syncStatus).thenAnswer(
        (_) => const Stream<SyncStatus>.empty(),
      );
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          authRepository: authRepository,
          accountRepository: MockAccountRepository(),
          budgetRepository: MockBudgetRepository(),
          envelopeRepository: MockEnvelopeRepository(),
          transactionRepository: MockTransactionRepository(),
          goalRepository: MockGoalRepository(),
          reportRepository: MockReportRepository(),
          notificationRepository: MockNotificationRepository(),
          sharingRepository: MockSharingRepository(),
          subscriptionRepository: MockSubscriptionRepository(),
          syncRepository: syncRepository,
        ),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
