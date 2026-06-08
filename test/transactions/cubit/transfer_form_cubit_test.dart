import 'package:account_repository/account_repository.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

class _MockTransactionRepository extends Mock
    implements TransactionRepository {}

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

void main() {
  late _MockTransactionRepository txRepo;
  late _MockAccountRepository accountRepo;
  late _MockEnvelopeRepository envelopeRepo;

  final now = DateTime(2024);
  const budgetId = 'b1';

  Account account(String id, {required bool onBudget}) => Account(
    id: id,
    budgetId: budgetId,
    name: id,
    type: onBudget ? 'checking' : 'investment',
    currency: 'USD',
    isOnBudget: onBudget,
    createdAt: now,
    updatedAt: now,
  );

  final checking = account('checking', onBudget: true);
  final fd = account('fd', onBudget: false);
  final savings = account('savings', onBudget: true);

  final envelope = Envelope(
    id: 'env-1',
    categoryGroupId: 'g',
    budgetId: budgetId,
    name: 'Investments',
    createdAt: now,
  );

  // Records every createTransaction invocation's named args for assertions.
  late List<Map<String, dynamic>> txCalls;

  setUp(() {
    txRepo = _MockTransactionRepository();
    accountRepo = _MockAccountRepository();
    envelopeRepo = _MockEnvelopeRepository();
    txCalls = [];

    when(
      () => accountRepo.watchAccounts(any()),
    ).thenAnswer((_) => Stream.value([checking, fd, savings]));
    when(
      () => envelopeRepo.watchEnvelopes(any()),
    ).thenAnswer((_) => Stream.value([envelope]));
    when(
      () => accountRepo.refreshAccounts(any()),
    ).thenAnswer((_) async {});
    when(
      () => envelopeRepo.refreshAllocations(any()),
    ).thenAnswer((_) async {});
    when(
      () => txRepo.createTransaction(
        budgetId: any(named: 'budgetId'),
        accountId: any(named: 'accountId'),
        type: any(named: 'type'),
        amount: any(named: 'amount'),
        currency: any(named: 'currency'),
        exchangeRate: any(named: 'exchangeRate'),
        date: any(named: 'date'),
        createdBy: any(named: 'createdBy'),
        transferPairId: any(named: 'transferPairId'),
        envelopeId: any(named: 'envelopeId'),
      ),
    ).thenAnswer((inv) async {
      txCalls.add({
        'accountId': inv.namedArguments[#accountId],
        'amount': inv.namedArguments[#amount],
        'envelopeId': inv.namedArguments[#envelopeId],
      });
      return Transaction(
        id: 't-${txCalls.length}',
        budgetId: budgetId,
        accountId: inv.namedArguments[#accountId] as String,
        type: 'transfer',
        amount: inv.namedArguments[#amount] as int,
        currency: 'USD',
        date: now,
        createdBy: 'u1',
        createdAt: now,
        updatedAt: now,
      );
    });
  });

  TransferFormCubit build() => TransferFormCubit(
    transactionRepository: txRepo,
    accountRepository: accountRepo,
    envelopeRepository: envelopeRepo,
    budgetId: budgetId,
    userId: 'u1',
    budgetPeriodId: 'period-1',
  );

  Future<TransferFormCubit> loaded() async {
    final cubit = build();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return cubit;
  }

  Map<String, dynamic> legFor(String accountId) =>
      txCalls.firstWhere((c) => c['accountId'] == accountId);

  group('TransferFormCubit categorization', () {
    test('on->off transfer tags the outgoing leg with the envelope', () async {
      final cubit = await loaded();
      await cubit.submit(
        fromAccountId: 'checking',
        toAccountId: 'fd',
        amountCents: 100000,
        date: now,
        envelopeId: 'env-1',
      );

      expect(cubit.state.status, TransferFormStatus.success);
      // Outgoing (negative) leg carries the funding envelope.
      expect(legFor('checking')['amount'], -100000);
      expect(legFor('checking')['envelopeId'], 'env-1');
      // Incoming leg (off-budget account) carries no envelope.
      expect(legFor('fd')['amount'], 100000);
      expect(legFor('fd')['envelopeId'], isNull);
      verify(() => envelopeRepo.refreshAllocations('period-1')).called(1);
      await cubit.close();
    });

    test('on->off transfer without an envelope still succeeds', () async {
      final cubit = await loaded();
      await cubit.submit(
        fromAccountId: 'checking',
        toAccountId: 'fd',
        amountCents: 100000,
        date: now,
      );

      expect(cubit.state.status, TransferFormStatus.success);
      expect(legFor('checking')['envelopeId'], isNull);
      expect(legFor('fd')['envelopeId'], isNull);
      // No envelope was passed → no allocation refresh.
      verifyNever(() => envelopeRepo.refreshAllocations(any()));
      await cubit.close();
    });

    test('on->on transfer never tags an envelope', () async {
      final cubit = await loaded();
      await cubit.submit(
        fromAccountId: 'checking',
        toAccountId: 'savings',
        amountCents: 5000,
        date: now,
        // Even if an envelope is passed, an on->on transfer must ignore it.
        envelopeId: 'env-1',
      );

      expect(cubit.state.status, TransferFormStatus.success);
      expect(legFor('checking')['envelopeId'], isNull);
      expect(legFor('savings')['envelopeId'], isNull);
      await cubit.close();
    });
  });
}
