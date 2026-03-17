import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/dashboard.dart';
import 'package:envelope/dashboard/widgets/widgets.dart';
import 'package:envelope/sync/bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

import '../../helpers/helpers.dart';

class _MockSyncBloc extends MockBloc<SyncEvent, SyncBlocState>
    implements SyncBloc {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockTransactionRepository extends Mock
    implements TransactionRepository {}

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockBudgetRepository extends Mock implements BudgetRepository {}

class _MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

void main() {
  late SyncBloc syncBloc;
  late AuthBloc authBloc;
  late TransactionRepository transactionRepository;
  late AccountRepository accountRepository;
  late BudgetRepository budgetRepository;
  late EnvelopeRepository envelopeRepository;

  final now = DateTime(2024);

  setUp(() {
    syncBloc = _MockSyncBloc();
    authBloc = _MockAuthBloc();
    transactionRepository = _MockTransactionRepository();
    accountRepository = _MockAccountRepository();
    budgetRepository = _MockBudgetRepository();
    envelopeRepository = _MockEnvelopeRepository();

    when(() => syncBloc.state).thenReturn(const SyncBlocState());
    when(() => authBloc.state).thenReturn(
      AuthState.authenticated(
        User(
          id: 'user-1',
          email: 'test@test.com',
          displayName: 'Test',
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );

    // Repository stubs for DashboardBloc and RecurringCheckCubit
    when(() => budgetRepository.watchBudgetPeriods(any()))
        .thenAnswer((_) => Stream.value([]));
    when(() => budgetRepository.refreshBudgetPeriods(any()))
        .thenAnswer((_) async {});
    when(() => accountRepository.watchAccounts(any()))
        .thenAnswer((_) => Stream.value([]));
    when(() => accountRepository.refreshAccounts(any()))
        .thenAnswer((_) async {});
    when(() => envelopeRepository.watchEnvelopes(any()))
        .thenAnswer((_) => Stream.value([]));
    when(() => envelopeRepository.watchCategoryGroups(any()))
        .thenAnswer((_) => Stream.value([]));
    when(() => envelopeRepository.refreshEnvelopes(any()))
        .thenAnswer((_) async {});
    when(() => envelopeRepository.refreshCategoryGroups(any()))
        .thenAnswer((_) async {});
    when(() => transactionRepository.watchTransactions(
          budgetId: any(named: 'budgetId'),
        )).thenAnswer((_) => Stream.value([]));
    when(() => transactionRepository.refreshTransactions(any()))
        .thenAnswer((_) async {});
    when(() => transactionRepository.watchRecurringRules(any()))
        .thenAnswer((_) => Stream.value([]));
    when(() => transactionRepository.watchBillReminders(any()))
        .thenAnswer((_) => Stream.value([]));
  });

  Widget buildSubject() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SyncBloc>.value(value: syncBloc),
        BlocProvider<AuthBloc>.value(value: authBloc),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<TransactionRepository>.value(
            value: transactionRepository,
          ),
          RepositoryProvider<AccountRepository>.value(
            value: accountRepository,
          ),
          RepositoryProvider<BudgetRepository>.value(
            value: budgetRepository,
          ),
          RepositoryProvider<EnvelopeRepository>.value(
            value: envelopeRepository,
          ),
        ],
        child: const HomePage(),
      ),
    );
  }

  group('HomePage', () {
    testWidgets('renders home title', (tester) async {
      await tester.pumpApp(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsWidgets);
    });

    testWidgets(
      'shows dashboard cards after streams emit',
      (tester) async {
        when(() => budgetRepository.watchBudgetPeriods(any()))
            .thenAnswer((_) => Stream.value([
                  BudgetPeriod(
                    id: 'p-1',
                    budgetId: 'user-1',
                    startDate: DateTime(2024),
                    endDate: DateTime(2024, 12, 31),
                    createdAt: now,
                  ),
                ]));
        when(() => budgetRepository.calculateReadyToAssign(any()))
            .thenAnswer((_) async => 50000);
        when(() => envelopeRepository.watchAllocations(any()))
            .thenAnswer((_) => Stream.value([]));
        when(() => envelopeRepository.refreshAllocations(any()))
            .thenAnswer((_) async {});

        await tester.pumpApp(buildSubject());
        await tester.pumpAndSettle();

        expect(
          find.byType(DashboardReadyToAssignCard),
          findsOneWidget,
        );
        expect(
          find.byType(DashboardAccountsCard),
          findsOneWidget,
        );
        expect(
          find.byType(EnvelopeSummaryCard),
          findsOneWidget,
        );
        expect(
          find.byType(RecentTransactionsCard),
          findsOneWidget,
        );
        expect(
          find.byType(QuickActionsRow),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows loading indicator initially',
      (tester) async {
        // Use streams that never emit to keep bloc in loading state
        when(() => budgetRepository.watchBudgetPeriods(any()))
            .thenAnswer((_) => const Stream.empty());
        when(() => accountRepository.watchAccounts(any()))
            .thenAnswer((_) => const Stream.empty());
        when(() => envelopeRepository.watchEnvelopes(any()))
            .thenAnswer((_) => const Stream.empty());
        when(() => envelopeRepository.watchCategoryGroups(any()))
            .thenAnswer((_) => const Stream.empty());
        when(() => transactionRepository.watchTransactions(
              budgetId: any(named: 'budgetId'),
            )).thenAnswer((_) => const Stream.empty());

        await tester.pumpApp(buildSubject());
        await tester.pump();

        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
        );
      },
    );
  });
}
