import 'package:account_repository/account_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

class _MockTransactionRepository extends Mock
    implements TransactionRepository {}

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class _MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  final now = DateTime(2026, 5);

  late _MockTransactionRepository transactionRepo;
  late _MockAccountRepository accountRepo;
  late _MockEnvelopeRepository envelopeRepo;
  late _MockBudgetRepository budgetRepo;

  Account account(String id, String currency) => Account(
    id: id,
    budgetId: 'budget-1',
    name: 'Account-$id',
    type: 'checking',
    currency: currency,
    createdAt: now,
    updatedAt: now,
  );

  Transaction stubReturn() => Transaction(
    id: 'txn-1',
    budgetId: 'budget-1',
    accountId: 'acc-eur',
    type: 'income',
    amount: 10000,
    currency: 'EUR',
    date: now,
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    transactionRepo = _MockTransactionRepository();
    accountRepo = _MockAccountRepository();
    envelopeRepo = _MockEnvelopeRepository();
    budgetRepo = _MockBudgetRepository();

    when(() => envelopeRepo.beginExternalWrite()).thenAnswer((_) {});
    when(() => envelopeRepo.endExternalWrite()).thenAnswer((_) {});
    when(() => accountRepo.beginExternalWrite()).thenAnswer((_) {});
    when(() => accountRepo.endExternalWrite()).thenAnswer((_) {});
    when(
      () => envelopeRepo.watchEnvelopes(any()),
    ).thenAnswer((_) => Stream.value(<Envelope>[]));
    when(
      () => envelopeRepo.watchCategoryGroups(any()),
    ).thenAnswer((_) => Stream.value(<CategoryGroup>[]));
    when(() => transactionRepo.getTags(any())).thenAnswer((_) async => <Tag>[]);
    when(
      () => transactionRepo.getTransactionTemplates(any()),
    ).thenAnswer((_) async => <TransactionTemplate>[]);
    when(
      () => budgetRepo.addIncomeToPeriod(
        budgetId: any(named: 'budgetId'),
        date: any(named: 'date'),
        amount: any(named: 'amount'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => accountRepo.refreshAccounts(any()),
    ).thenAnswer((_) async {});
    when(
      () => budgetRepo.ensurePeriodForDate(
        budgetId: any(named: 'budgetId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) async => null);
    when(
      () => budgetRepo.recomputeCarryForwardFrom(
        budgetId: any(named: 'budgetId'),
        fromPeriodId: any(named: 'fromPeriodId'),
      ),
    ).thenAnswer((_) async {});
  });

  group('TransactionFormCubit currency derivation', () {
    blocTest<TransactionFormCubit, TransactionFormState>(
      'passes selected account currency (EUR) to createTransaction',
      setUp: () {
        when(() => accountRepo.watchAccounts(any())).thenAnswer(
          (_) => Stream.value([
            account('acc-usd', 'USD'),
            account('acc-eur', 'EUR'),
          ]),
        );
        when(
          () => transactionRepo.createTransaction(
            budgetId: any(named: 'budgetId'),
            accountId: any(named: 'accountId'),
            type: any(named: 'type'),
            amount: any(named: 'amount'),
            currency: any(named: 'currency'),
            date: any(named: 'date'),
            createdBy: any(named: 'createdBy'),
            envelopeId: any(named: 'envelopeId'),
            payee: any(named: 'payee'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => stubReturn());
      },
      build: () => TransactionFormCubit(
        transactionRepository: transactionRepo,
        accountRepository: accountRepo,
        envelopeRepository: envelopeRepo,
        budgetRepository: budgetRepo,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) async {
        // Allow _loadData() to populate state.accounts before submit.
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await cubit.submit(
          type: 'income',
          accountId: 'acc-eur',
          amountCents: 10000,
          date: now,
        );
      },
      verify: (_) {
        verify(
          () => transactionRepo.createTransaction(
            budgetId: 'budget-1',
            accountId: 'acc-eur',
            type: 'income',
            amount: 10000,
            currency: 'EUR',
            date: now,
            createdBy: 'user-1',
          ),
        ).called(1);
      },
    );

    blocTest<TransactionFormCubit, TransactionFormState>(
      'emits failure when accounts list is empty at submit',
      setUp: () {
        when(
          () => accountRepo.watchAccounts(any()),
        ).thenAnswer((_) => Stream.value(<Account>[]));
      },
      build: () => TransactionFormCubit(
        transactionRepository: transactionRepo,
        accountRepository: accountRepo,
        envelopeRepository: envelopeRepo,
        budgetRepository: budgetRepo,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) async {
        // Allow _loadData() to populate state.accounts before submit.
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await cubit.submit(
          type: 'income',
          accountId: 'acc-eur',
          amountCents: 10000,
          date: now,
        );
      },
      verify: (cubit) {
        expect(cubit.state.status, TransactionFormStatus.failure);
        expect(cubit.state.errorMessage, contains('Accounts not loaded'));
        verifyNever(
          () => transactionRepo.createTransaction(
            budgetId: any(named: 'budgetId'),
            accountId: any(named: 'accountId'),
            type: any(named: 'type'),
            amount: any(named: 'amount'),
            currency: any(named: 'currency'),
            date: any(named: 'date'),
            createdBy: any(named: 'createdBy'),
          ),
        );
      },
    );
  });
}
