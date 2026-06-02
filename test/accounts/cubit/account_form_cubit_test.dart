import 'package:account_repository/account_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/cubit/account_form_cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockBudgetRepository extends Mock implements BudgetRepository {}

class _MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class _FakeAccount extends Fake implements Account {}

void main() {
  late _MockAccountRepository accountRepository;
  late _MockBudgetRepository budgetRepository;
  late _MockEnvelopeRepository envelopeRepository;

  final now = DateTime(2026, 6);

  final existingAccount = Account(
    id: 'acc-1',
    budgetId: 'budget-1',
    name: 'Checking',
    type: 'checking',
    currency: 'USD',
    startingBalance: 100000,
    currentBalance: 100000,
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(_FakeAccount());
  });

  setUp(() {
    accountRepository = _MockAccountRepository();
    budgetRepository = _MockBudgetRepository();
    envelopeRepository = _MockEnvelopeRepository();
    when(
      () => accountRepository.updateAccount(any()),
    ).thenAnswer((_) async {});
    when(
      () => accountRepository.createAccount(
        budgetId: any(named: 'budgetId'),
        name: any(named: 'name'),
        type: any(named: 'type'),
        currency: any(named: 'currency'),
        displayFxRate: any(named: 'displayFxRate'),
        startingBalance: any(named: 'startingBalance'),
        isOnBudget: any(named: 'isOnBudget'),
      ),
    ).thenAnswer((_) async => existingAccount);
    when(
      () => budgetRepository.refreshOpeningBalanceForBudget(any()),
    ).thenAnswer((_) async {});
  });

  AccountFormCubit buildEditCubit() => AccountFormCubit(
        accountRepository: accountRepository,
        budgetRepository: budgetRepository,
        envelopeRepository: envelopeRepository,
        budgetId: 'budget-1',
        account: existingAccount,
      );

  AccountFormCubit buildCreateCubit() => AccountFormCubit(
        accountRepository: accountRepository,
        budgetRepository: budgetRepository,
        envelopeRepository: envelopeRepository,
        budgetId: 'budget-1',
      );

  group('AccountFormCubit.submit', () {
    blocTest<AccountFormCubit, AccountFormState>(
      'edit triggers refreshOpeningBalanceForBudget on success (#81)',
      build: buildEditCubit,
      act: (cubit) => cubit.submit(
        name: 'Checking',
        type: 'checking',
        balanceCents: 200000,
        currency: 'USD',
        isOnBudget: true,
      ),
      verify: (_) {
        verify(() => accountRepository.updateAccount(any())).called(1);
        verify(
          () => budgetRepository.refreshOpeningBalanceForBudget('budget-1'),
        ).called(1);
      },
    );

    blocTest<AccountFormCubit, AccountFormState>(
      'create triggers refreshOpeningBalanceForBudget on success (#81)',
      build: buildCreateCubit,
      act: (cubit) => cubit.submit(
        name: 'New',
        type: 'checking',
        balanceCents: 75000,
        currency: 'USD',
        isOnBudget: true,
      ),
      verify: (_) {
        verify(
          () => accountRepository.createAccount(
            budgetId: 'budget-1',
            name: 'New',
            type: 'checking',
            currency: 'USD',
            displayFxRate: any(named: 'displayFxRate'),
            startingBalance: 75000,
            isOnBudget: true,
          ),
        ).called(1);
        verify(
          () => budgetRepository.refreshOpeningBalanceForBudget('budget-1'),
        ).called(1);
      },
    );

    blocTest<AccountFormCubit, AccountFormState>(
      'failed updateAccount short-circuits and does NOT refresh seed cash',
      build: () {
        when(
          () => accountRepository.updateAccount(any()),
        ).thenThrow(const AccountException('failed'));
        return buildEditCubit();
      },
      act: (cubit) => cubit.submit(
        name: 'Checking',
        type: 'checking',
        balanceCents: 200000,
        currency: 'USD',
        isOnBudget: true,
      ),
      verify: (_) {
        verifyNever(
          () => budgetRepository.refreshOpeningBalanceForBudget(any()),
        );
      },
    );
  });
}
