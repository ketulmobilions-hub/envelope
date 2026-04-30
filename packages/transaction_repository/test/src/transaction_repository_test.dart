import 'package:drift/drift.dart' show InsertMode;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:transaction_repository/transaction_repository.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockEnvelopeApiClient extends Mock implements EnvelopeApiClient {}

class MockTransactionsApiClient extends Mock implements TransactionsApiClient {}

class MockRecurringApiClient extends Mock implements RecurringApiClient {}

class MockAppDatabase extends Mock implements storage.AppDatabase {}

class MockTransactionsDao extends Mock implements storage.TransactionsDao {}

class MockRecurringDao extends Mock implements storage.RecurringDao {}

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakeTransactionDto extends Fake implements TransactionDto {}

class FakeTransactionSplitDto extends Fake implements TransactionSplitDto {}

class FakeRecurringRuleDto extends Fake implements RecurringRuleDto {}

class FakeBillReminderDto extends Fake implements BillReminderDto {}

class FakeTagDto extends Fake implements TagDto {}

class FakeTransactionsCompanion extends Fake
    implements storage.TransactionsCompanion {}

class FakeTransactionSplitsCompanion extends Fake
    implements storage.TransactionSplitsCompanion {}

class FakeRecurringRulesCompanion extends Fake
    implements storage.RecurringRulesCompanion {}

class FakeBillRemindersCompanion extends Fake
    implements storage.BillRemindersCompanion {}

class FakeTagsCompanion extends Fake implements storage.TagsCompanion {}

class FakeTransactionTagsCompanion extends Fake
    implements storage.TransactionTagsCompanion {}

void main() {
  late TransactionRepository repository;
  late MockEnvelopeApiClient apiClient;
  late MockTransactionsApiClient transactionsApiClient;
  late MockRecurringApiClient recurringApiClient;
  late MockAppDatabase localDatabase;
  late MockTransactionsDao transactionsDao;
  late MockRecurringDao recurringDao;

  final now = DateTime(2024);

  // ---------------------------------------------------------------------------
  // Fixtures
  // ---------------------------------------------------------------------------

  final testTransactionDto = TransactionDto(
    id: 'tx-1',
    budgetId: 'budget-1',
    accountId: 'account-1',
    type: 'expense',
    amount: 5000,
    currency: 'USD',
    date: now,
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
    payee: 'Grocery Store',
  );

  final testTransaction = Transaction(
    id: 'tx-1',
    budgetId: 'budget-1',
    accountId: 'account-1',
    type: 'expense',
    amount: 5000,
    currency: 'USD',
    date: now,
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
    payee: 'Grocery Store',
  );

  final testLocalTransaction = storage.Transaction(
    id: 'tx-1',
    budgetId: 'budget-1',
    accountId: 'account-1',
    type: 'expense',
    amount: 5000,
    currency: 'USD',
    date: now,
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
    exchangeRate: 1.0,
    isReconciled: false,
    payee: 'Grocery Store',
  );

  final testRecurringRuleDto = RecurringRuleDto(
    id: 'rule-1',
    budgetId: 'budget-1',
    accountId: 'account-1',
    type: 'expense',
    amount: 10000,
    currency: 'USD',
    frequency: 'monthly',
    startDate: now,
    nextOccurrence: now,
    createdAt: now,
  );

  final testRecurringRule = RecurringRule(
    id: 'rule-1',
    budgetId: 'budget-1',
    accountId: 'account-1',
    type: 'expense',
    amount: 10000,
    currency: 'USD',
    frequency: 'monthly',
    startDate: now,
    nextOccurrence: now,
    createdAt: now,
  );

  final testLocalRecurringRule = storage.RecurringRule(
    id: 'rule-1',
    budgetId: 'budget-1',
    accountId: 'account-1',
    type: 'expense',
    amount: 10000,
    currency: 'USD',
    frequency: 'monthly',
    startDate: now,
    nextOccurrence: now,
    createdAt: now,
    autoPost: false,
    isPaused: false,
  );

  final testBillReminderDto = BillReminderDto(
    id: 'reminder-1',
    budgetId: 'budget-1',
    name: 'Rent',
    estimatedAmount: 150000,
    dueDay: 1,
    frequency: 'monthly',
    createdAt: now,
  );

  final testBillReminder = BillReminder(
    id: 'reminder-1',
    budgetId: 'budget-1',
    name: 'Rent',
    estimatedAmount: 150000,
    dueDay: 1,
    frequency: 'monthly',
    createdAt: now,
  );

  final testLocalBillReminder = storage.BillReminder(
    id: 'reminder-1',
    budgetId: 'budget-1',
    name: 'Rent',
    estimatedAmount: 150000,
    dueDay: 1,
    frequency: 'monthly',
    createdAt: now,
    reminderDaysBefore: 3,
  );

  final testTagDto = TagDto(id: 'tag-1', budgetId: 'budget-1', name: 'Food');

  final testTag = Tag(id: 'tag-1', budgetId: 'budget-1', name: 'Food');

  final testLocalTag = storage.Tag(
    id: 'tag-1',
    budgetId: 'budget-1',
    name: 'Food',
  );

  // ---------------------------------------------------------------------------
  // Setup
  // ---------------------------------------------------------------------------

  setUpAll(() {
    registerFallbackValue(InsertMode.insert);
    registerFallbackValue(FakeTransactionDto());
    registerFallbackValue(FakeTransactionSplitDto());
    registerFallbackValue(FakeRecurringRuleDto());
    registerFallbackValue(FakeBillReminderDto());
    registerFallbackValue(FakeTagDto());
    registerFallbackValue(FakeTransactionsCompanion());
    registerFallbackValue(FakeTransactionSplitsCompanion());
    registerFallbackValue(FakeRecurringRulesCompanion());
    registerFallbackValue(FakeBillRemindersCompanion());
    registerFallbackValue(FakeTagsCompanion());
    registerFallbackValue(FakeTransactionTagsCompanion());
  });

  setUp(() {
    apiClient = MockEnvelopeApiClient();
    transactionsApiClient = MockTransactionsApiClient();
    recurringApiClient = MockRecurringApiClient();
    localDatabase = MockAppDatabase();
    transactionsDao = MockTransactionsDao();
    recurringDao = MockRecurringDao();

    when(() => apiClient.transactions).thenReturn(transactionsApiClient);
    when(() => apiClient.recurring).thenReturn(recurringApiClient);
    when(() => localDatabase.transactionsDao).thenReturn(transactionsDao);
    when(() => localDatabase.recurringDao).thenReturn(recurringDao);

    repository = TransactionRepository(
      apiClient: apiClient,
      localDatabase: localDatabase,
    );
  });

  // ---------------------------------------------------------------------------
  // Transactions
  // ---------------------------------------------------------------------------

  group('TransactionRepository', () {
    group('createTransaction', () {
      test('returns Transaction on success', () async {
        when(
          () => transactionsApiClient.createTransaction(any()),
        ).thenAnswer((_) async => testTransactionDto);
        when(
          () => transactionsDao.insertTransaction(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createTransaction(
          budgetId: 'budget-1',
          accountId: 'account-1',
          type: 'expense',
          amount: 5000,
          currency: 'USD',
          date: now,
          createdBy: 'user-1',
          payee: 'Grocery Store',
        );

        expect(result, testTransaction);
      });

      test('throws TransactionException on API failure', () async {
        when(
          () => transactionsApiClient.createTransaction(any()),
        ).thenThrow(const EnvelopeApiException('error'));

        await expectLater(
          () => repository.createTransaction(
            budgetId: 'budget-1',
            accountId: 'account-1',
            type: 'expense',
            amount: 5000,
            currency: 'USD',
            date: now,
            createdBy: 'user-1',
          ),
          throwsA(isA<TransactionException>()),
        );
      });
    });

    group('getTransaction', () {
      test('returns from local cache when available', () async {
        when(
          () => transactionsDao.getTransaction('tx-1'),
        ).thenAnswer((_) async => testLocalTransaction);

        final result = await repository.getTransaction('tx-1');

        expect(result, testTransaction);
        verifyNever(() => transactionsApiClient.getTransaction(any()));
      });

      test('falls back to API when not in cache', () async {
        when(
          () => transactionsDao.getTransaction('tx-1'),
        ).thenAnswer((_) async => null);
        when(
          () => transactionsApiClient.getTransaction('tx-1'),
        ).thenAnswer((_) async => testTransactionDto);
        when(
          () => transactionsDao.insertTransaction(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.getTransaction('tx-1');

        expect(result, testTransaction);
      });

      test('throws TransactionException on API failure', () async {
        when(
          () => transactionsDao.getTransaction('tx-1'),
        ).thenAnswer((_) async => null);
        when(
          () => transactionsApiClient.getTransaction('tx-1'),
        ).thenThrow(const EnvelopeApiException('error'));

        await expectLater(
          () => repository.getTransaction('tx-1'),
          throwsA(isA<TransactionException>()),
        );
      });
    });

    group('watchTransactions', () {
      test('returns stream filtered by accountId', () {
        when(
          () => transactionsDao.watchTransactionsByBudgetId('budget-1'),
        ).thenAnswer(
          (_) => Stream.value([testLocalTransaction]),
        );

        final stream = repository.watchTransactions(
          budgetId: 'budget-1',
          accountId: 'account-1',
        );

        expect(stream, emits([testTransaction]));
      });

      test('returns unfiltered stream when no filters', () {
        when(
          () => transactionsDao.watchTransactionsByBudgetId('budget-1'),
        ).thenAnswer((_) => Stream.value([testLocalTransaction]));

        final stream = repository.watchTransactions(budgetId: 'budget-1');

        expect(stream, emits([testTransaction]));
      });
    });

    group('updateTransaction', () {
      test('calls API and caches updated transaction', () async {
        when(
          () => transactionsApiClient.updateTransaction(any()),
        ).thenAnswer((_) async => testTransactionDto);
        when(
          () => transactionsDao.insertTransaction(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.updateTransaction(testTransaction);

        verify(() => transactionsApiClient.updateTransaction(any())).called(1);
        verify(
          () => transactionsDao.insertTransaction(
            any(),
            mode: any(named: 'mode'),
          ),
        ).called(1);
      });

      test('throws TransactionException on API failure', () async {
        when(
          () => transactionsApiClient.updateTransaction(any()),
        ).thenThrow(const EnvelopeApiException('error'));

        await expectLater(
          () => repository.updateTransaction(testTransaction),
          throwsA(isA<TransactionException>()),
        );
      });
    });

    group('deleteTransaction', () {
      test('calls API and removes from local cache', () async {
        when(
          () => transactionsApiClient.deleteTransaction('tx-1'),
        ).thenAnswer((_) async {});
        when(
          () => transactionsDao.deleteTransaction('tx-1'),
        ).thenAnswer((_) async => 1);

        await repository.deleteTransaction('tx-1');

        verify(() => transactionsApiClient.deleteTransaction('tx-1')).called(1);
        verify(() => transactionsDao.deleteTransaction('tx-1')).called(1);
      });

      test('throws TransactionException on API failure', () async {
        when(
          () => transactionsApiClient.deleteTransaction('tx-1'),
        ).thenThrow(const EnvelopeApiException('error'));

        await expectLater(
          () => repository.deleteTransaction('tx-1'),
          throwsA(isA<TransactionException>()),
        );
      });
    });

    // ---------------------------------------------------------------------------
    // Recurring Rules
    // ---------------------------------------------------------------------------

    group('createRecurringRule', () {
      test('returns RecurringRule on success', () async {
        when(
          () => recurringApiClient.createRecurringRule(any()),
        ).thenAnswer((_) async => testRecurringRuleDto);
        when(
          () => recurringDao.insertRecurringRule(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createRecurringRule(
          budgetId: 'budget-1',
          accountId: 'account-1',
          type: 'expense',
          amount: 10000,
          currency: 'USD',
          frequency: 'monthly',
          startDate: now,
        );

        expect(result, testRecurringRule);
      });

      test('throws TransactionException on API failure', () async {
        when(
          () => recurringApiClient.createRecurringRule(any()),
        ).thenThrow(const EnvelopeApiException('error'));

        await expectLater(
          () => repository.createRecurringRule(
            budgetId: 'budget-1',
            accountId: 'account-1',
            type: 'expense',
            amount: 10000,
            currency: 'USD',
            frequency: 'monthly',
            startDate: now,
          ),
          throwsA(isA<TransactionException>()),
        );
      });
    });

    group('watchRecurringRules', () {
      test('returns stream of recurring rules', () {
        when(
          () => recurringDao.watchRecurringRulesByBudgetId('budget-1'),
        ).thenAnswer((_) => Stream.value([testLocalRecurringRule]));

        final stream = repository.watchRecurringRules('budget-1');

        expect(stream, emits([testRecurringRule]));
      });
    });

    group('deleteRecurringRule', () {
      test('calls API and removes from local cache', () async {
        when(
          () => recurringApiClient.deleteRecurringRule('rule-1'),
        ).thenAnswer((_) async {});
        when(
          () => recurringDao.deleteRecurringRule('rule-1'),
        ).thenAnswer((_) async => 1);

        await repository.deleteRecurringRule('rule-1');

        verify(
          () => recurringApiClient.deleteRecurringRule('rule-1'),
        ).called(1);
        verify(() => recurringDao.deleteRecurringRule('rule-1')).called(1);
      });
    });

    group('pauseRecurringRule', () {
      test('pauses via local cache when available', () async {
        when(
          () => recurringDao.getRecurringRule('rule-1'),
        ).thenAnswer((_) async => testLocalRecurringRule);
        when(() => recurringApiClient.updateRecurringRule(any())).thenAnswer(
          (_) async => testRecurringRuleDto.copyWith(isPaused: true),
        );
        when(
          () => recurringDao.insertRecurringRule(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.pauseRecurringRule('rule-1');

        final captured = verify(
          () => recurringApiClient.updateRecurringRule(captureAny()),
        ).captured;
        final dto = captured.first as RecurringRuleDto;
        expect(dto.isPaused, isTrue);
      });
    });

    // ---------------------------------------------------------------------------
    // Bill Reminders
    // ---------------------------------------------------------------------------

    group('createBillReminder', () {
      test('returns BillReminder on success', () async {
        when(
          () => recurringApiClient.createBillReminder(any()),
        ).thenAnswer((_) async => testBillReminderDto);
        when(
          () => recurringDao.insertBillReminder(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createBillReminder(
          budgetId: 'budget-1',
          name: 'Rent',
          estimatedAmount: 150000,
          dueDay: 1,
          frequency: 'monthly',
        );

        expect(result, testBillReminder);
      });

      test('throws TransactionException on API failure', () async {
        when(
          () => recurringApiClient.createBillReminder(any()),
        ).thenThrow(const EnvelopeApiException('error'));

        await expectLater(
          () => repository.createBillReminder(
            budgetId: 'budget-1',
            name: 'Rent',
            estimatedAmount: 150000,
            dueDay: 1,
            frequency: 'monthly',
          ),
          throwsA(isA<TransactionException>()),
        );
      });
    });

    group('watchBillReminders', () {
      test('returns stream of bill reminders', () {
        when(
          () => recurringDao.watchBillRemindersByBudgetId('budget-1'),
        ).thenAnswer((_) => Stream.value([testLocalBillReminder]));

        final stream = repository.watchBillReminders('budget-1');

        expect(stream, emits([testBillReminder]));
      });
    });

    group('deleteBillReminder', () {
      test('calls API and removes from local cache', () async {
        when(
          () => recurringApiClient.deleteBillReminder('reminder-1'),
        ).thenAnswer((_) async {});
        when(
          () => recurringDao.deleteBillReminder('reminder-1'),
        ).thenAnswer((_) async => 1);

        await repository.deleteBillReminder('reminder-1');

        verify(
          () => recurringApiClient.deleteBillReminder('reminder-1'),
        ).called(1);
        verify(() => recurringDao.deleteBillReminder('reminder-1')).called(1);
      });
    });

    // ---------------------------------------------------------------------------
    // Tags
    // ---------------------------------------------------------------------------

    group('createTag', () {
      test('returns Tag on success', () async {
        when(
          () => transactionsApiClient.createTag(any()),
        ).thenAnswer((_) async => testTagDto);
        when(
          () => transactionsDao.insertTag(any(), mode: any(named: 'mode')),
        ).thenAnswer((_) async => 1);

        final result = await repository.createTag(
          budgetId: 'budget-1',
          name: 'Food',
        );

        expect(result, testTag);
      });

      test('throws TransactionException on API failure', () async {
        when(
          () => transactionsApiClient.createTag(any()),
        ).thenThrow(const EnvelopeApiException('error'));

        await expectLater(
          () => repository.createTag(budgetId: 'budget-1', name: 'Food'),
          throwsA(isA<TransactionException>()),
        );
      });
    });

    group('getTags', () {
      test('returns from local cache when available', () async {
        when(
          () => transactionsDao.getTagsByBudgetId('budget-1'),
        ).thenAnswer((_) async => [testLocalTag]);

        final result = await repository.getTags('budget-1');

        expect(result, [testTag]);
        verifyNever(() => transactionsApiClient.getTags(any()));
      });

      test('falls back to API when cache is empty', () async {
        when(
          () => transactionsDao.getTagsByBudgetId('budget-1'),
        ).thenAnswer((_) async => []);
        when(
          () => transactionsApiClient.getTags('budget-1'),
        ).thenAnswer((_) async => [testTagDto]);
        when(
          () => transactionsDao.insertTag(any(), mode: any(named: 'mode')),
        ).thenAnswer((_) async => 1);

        final result = await repository.getTags('budget-1');

        expect(result, [testTag]);
      });
    });

    group('addTagToTransaction', () {
      test('calls API and caches locally', () async {
        when(
          () => transactionsApiClient.addTransactionTag(
            transactionId: any(named: 'transactionId'),
            tagId: any(named: 'tagId'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => transactionsDao.insertTransactionTag(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.addTagToTransaction(
          transactionId: 'tx-1',
          tagId: 'tag-1',
        );

        verify(
          () => transactionsApiClient.addTransactionTag(
            transactionId: 'tx-1',
            tagId: 'tag-1',
          ),
        ).called(1);
      });

      test('throws TransactionException on API failure', () async {
        when(
          () => transactionsApiClient.addTransactionTag(
            transactionId: any(named: 'transactionId'),
            tagId: any(named: 'tagId'),
          ),
        ).thenThrow(const EnvelopeApiException('error'));

        await expectLater(
          () => repository.addTagToTransaction(
            transactionId: 'tx-1',
            tagId: 'tag-1',
          ),
          throwsA(isA<TransactionException>()),
        );
      });
    });

    group('removeTagFromTransaction', () {
      test('calls API and removes from local cache', () async {
        when(
          () => transactionsApiClient.removeTransactionTag(
            transactionId: any(named: 'transactionId'),
            tagId: any(named: 'tagId'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => transactionsDao.deleteTransactionTag(
            transactionId: any(named: 'transactionId'),
            tagId: any(named: 'tagId'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.removeTagFromTransaction(
          transactionId: 'tx-1',
          tagId: 'tag-1',
        );

        verify(
          () => transactionsApiClient.removeTransactionTag(
            transactionId: 'tx-1',
            tagId: 'tag-1',
          ),
        ).called(1);
      });
    });

    // ---------------------------------------------------------------------------
    // TransactionException
    // ---------------------------------------------------------------------------

    group('TransactionException', () {
      test('toString includes message', () {
        const exception = TransactionException('test error');
        expect(exception.toString(), contains('test error'));
      });

      test('toString includes error when provided', () {
        const exception = TransactionException('test error', error: 'cause');
        expect(exception.toString(), contains('cause'));
      });
    });
  });
}
