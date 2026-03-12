import 'package:account_repository/account_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/accounts/cubit/cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockAccountRepository accountRepository;

  final now = DateTime(2024);
  final testAccount = Account(
    id: 'acc-1',
    budgetId: 'budget-1',
    name: 'Checking',
    type: 'checking',
    currency: 'USD',
    startingBalance: 10000,
    currentBalance: 15000,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    accountRepository = MockAccountRepository();
  });

  group('AccountDetailCubit', () {
    test('initial state has the provided account', () {
      final cubit = AccountDetailCubit(
        accountRepository: accountRepository,
        account: testAccount,
      );
      expect(cubit.state.account, equals(testAccount));
      expect(cubit.state.status, equals(AccountDetailStatus.idle));
    });

    blocTest<AccountDetailCubit, AccountDetailState>(
      'refresh updates account from repository',
      build: () {
        when(() => accountRepository.getAccount('acc-1')).thenAnswer(
          (_) async => testAccount.copyWith(currentBalance: 20000),
        );
        return AccountDetailCubit(
          accountRepository: accountRepository,
          account: testAccount,
        );
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [
        AccountDetailState(
          account: testAccount.copyWith(currentBalance: 20000),
        ),
      ],
    );

    blocTest<AccountDetailCubit, AccountDetailState>(
      'refresh keeps current data on failure',
      build: () {
        when(() => accountRepository.getAccount('acc-1'))
            .thenThrow(const AccountException('Not found'));
        return AccountDetailCubit(
          accountRepository: accountRepository,
          account: testAccount,
        );
      },
      act: (cubit) => cubit.refresh(),
      expect: () => <AccountDetailState>[],
    );

    blocTest<AccountDetailCubit, AccountDetailState>(
      'reconcile emits submitting, reconciled, then idle',
      build: () {
        when(() => accountRepository.reconcileAccount('acc-1', 20000))
            .thenAnswer((_) async {});
        when(() => accountRepository.getAccount('acc-1')).thenAnswer(
          (_) async => testAccount.copyWith(currentBalance: 20000),
        );
        return AccountDetailCubit(
          accountRepository: accountRepository,
          account: testAccount,
        );
      },
      act: (cubit) => cubit.reconcile(20000),
      expect: () => [
        AccountDetailState(
          account: testAccount,
          status: AccountDetailStatus.submitting,
        ),
        AccountDetailState(
          account: testAccount.copyWith(currentBalance: 20000),
          status: AccountDetailStatus.reconciled,
        ),
        AccountDetailState(
          account: testAccount.copyWith(currentBalance: 20000),
        ),
      ],
    );

    blocTest<AccountDetailCubit, AccountDetailState>(
      'reconcile emits failure on error',
      build: () {
        when(() => accountRepository.reconcileAccount('acc-1', 20000))
            .thenThrow(const AccountException('Reconcile failed'));
        return AccountDetailCubit(
          accountRepository: accountRepository,
          account: testAccount,
        );
      },
      act: (cubit) => cubit.reconcile(20000),
      expect: () => [
        AccountDetailState(
          account: testAccount,
          status: AccountDetailStatus.submitting,
        ),
        AccountDetailState(
          account: testAccount,
          status: AccountDetailStatus.failure,
          errorMessage: 'Reconcile failed',
        ),
        AccountDetailState(
          account: testAccount,
        ),
      ],
    );
  });
}
