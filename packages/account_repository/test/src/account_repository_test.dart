import 'package:account_repository/account_repository.dart';
import 'package:drift/drift.dart' show InsertMode;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockEnvelopeApiClient extends Mock implements EnvelopeApiClient {}

class MockAccountsApiClient extends Mock implements AccountsApiClient {}

class MockAppDatabase extends Mock implements storage.AppDatabase {}

class MockAccountsDao extends Mock implements storage.AccountsDao {}

class FakeAccountDto extends Fake implements AccountDto {}

class FakeDebtAccountDto extends Fake implements DebtAccountDto {}

class FakeAccountsCompanion extends Fake implements storage.AccountsCompanion {}

class FakeDebtAccountsCompanion extends Fake
    implements storage.DebtAccountsCompanion {}

void main() {
  late AccountRepository repository;
  late MockEnvelopeApiClient apiClient;
  late MockAccountsApiClient accountsApiClient;
  late MockAppDatabase localDatabase;
  late MockAccountsDao accountsDao;

  final now = DateTime(2024);
  final testAccountDto = AccountDto(
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

  final testLocalAccount = storage.Account(
    id: 'acc-1',
    budgetId: 'budget-1',
    name: 'Checking',
    type: 'checking',
    currency: 'USD',
    startingBalance: 10000,
    currentBalance: 15000,
    isArchived: false,
    createdAt: now,
    updatedAt: now,
  );

  final testDebtAccountDto = DebtAccountDto(
    accountId: 'acc-1',
    interestRate: 5.5,
    minimumPayment: 5000,
    originalBalance: 100000,
    payoffStrategy: 'avalanche',
  );

  final testDebtAccount = DebtAccount(
    accountId: 'acc-1',
    interestRate: 5.5,
    minimumPayment: 5000,
    originalBalance: 100000,
    payoffStrategy: 'avalanche',
  );

  final testLocalDebtAccount = storage.DebtAccount(
    accountId: 'acc-1',
    interestRate: 5.5,
    minimumPayment: 5000,
    originalBalance: 100000,
    payoffStrategy: 'avalanche',
  );

  setUpAll(() {
    registerFallbackValue(FakeAccountDto());
    registerFallbackValue(FakeDebtAccountDto());
    registerFallbackValue(FakeAccountsCompanion());
    registerFallbackValue(FakeDebtAccountsCompanion());
    registerFallbackValue(InsertMode.insert);
    registerFallbackValue(<storage.AccountsCompanion>[]);
  });

  setUp(() {
    apiClient = MockEnvelopeApiClient();
    accountsApiClient = MockAccountsApiClient();
    localDatabase = MockAppDatabase();
    accountsDao = MockAccountsDao();

    when(() => apiClient.accounts).thenReturn(accountsApiClient);
    when(() => localDatabase.accountsDao).thenReturn(accountsDao);

    repository = AccountRepository(
      apiClient: apiClient,
      localDatabase: localDatabase,
    );
  });

  group('AccountRepository', () {
    group('createAccount', () {
      test('creates account via API and caches locally', () async {
        when(() => accountsApiClient.createAccount(any()))
            .thenAnswer((_) async => testAccountDto);
        when(
          () => accountsDao.insertAccount(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createAccount(
          budgetId: 'budget-1',
          name: 'Checking',
          type: 'checking',
          currency: 'USD',
          startingBalance: 10000,
        );

        expect(result.id, equals('acc-1'));
        expect(result.name, equals('Checking'));
        expect(result.startingBalance, equals(10000));
        verify(() => accountsApiClient.createAccount(any())).called(1);
        verify(
          () => accountsDao.insertAccount(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws AccountException on API failure', () async {
        when(() => accountsApiClient.createAccount(any()))
            .thenThrow(const EnvelopeApiException('Network error'));

        expect(
          () => repository.createAccount(
            budgetId: 'budget-1',
            name: 'Checking',
            type: 'checking',
            currency: 'USD',
          ),
          throwsA(isA<AccountException>()),
        );
      });
    });

    group('getAccount', () {
      test('returns from local storage when available', () async {
        when(() => accountsDao.getAccount('acc-1'))
            .thenAnswer((_) async => testLocalAccount);

        final result = await repository.getAccount('acc-1');

        expect(result.id, equals('acc-1'));
        expect(result.name, equals('Checking'));
        verifyNever(() => accountsApiClient.getAccount(any()));
      });

      test('falls back to API when not in local storage', () async {
        when(() => accountsDao.getAccount('acc-1'))
            .thenAnswer((_) async => null);
        when(() => accountsApiClient.getAccount('acc-1'))
            .thenAnswer((_) async => testAccountDto);
        when(
          () => accountsDao.insertAccount(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.getAccount('acc-1');

        expect(result.id, equals('acc-1'));
        verify(() => accountsApiClient.getAccount('acc-1')).called(1);
      });

      test('throws AccountException on API failure', () async {
        when(() => accountsDao.getAccount('acc-1'))
            .thenAnswer((_) async => null);
        when(() => accountsApiClient.getAccount('acc-1'))
            .thenThrow(const EnvelopeApiException('Not found'));

        expect(
          () => repository.getAccount('acc-1'),
          throwsA(isA<AccountException>()),
        );
      });
    });

    group('watchAccounts', () {
      test('streams mapped accounts from local storage', () {
        when(() => accountsDao.watchAccountsByBudgetId('budget-1'))
            .thenAnswer((_) => Stream.value([testLocalAccount]));

        final stream = repository.watchAccounts('budget-1');

        expect(
          stream,
          emits(
            isA<List<Account>>()
                .having((l) => l.length, 'length', 1)
                .having((l) => l.first.id, 'first id', 'acc-1'),
          ),
        );
      });

      test('wraps stream errors in AccountException', () {
        when(() => accountsDao.watchAccountsByBudgetId('budget-1'))
            .thenAnswer((_) => Stream.error(Exception('DB error')));

        final stream = repository.watchAccounts('budget-1');

        expect(stream, emitsError(isA<AccountException>()));
      });
    });

    group('updateAccount', () {
      test('updates via API and caches locally', () async {
        when(() => accountsApiClient.updateAccount(any()))
            .thenAnswer((_) async => testAccountDto);
        when(
          () => accountsDao.insertAccount(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.updateAccount(testAccount);

        verify(() => accountsApiClient.updateAccount(any())).called(1);
        verify(
          () => accountsDao.insertAccount(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws AccountException on API failure', () async {
        when(() => accountsApiClient.updateAccount(any()))
            .thenThrow(const EnvelopeApiException('Update failed'));

        expect(
          () => repository.updateAccount(testAccount),
          throwsA(isA<AccountException>()),
        );
      });
    });

    group('deleteAccount', () {
      test('deletes from API and local storage', () async {
        when(() => accountsApiClient.deleteAccount('acc-1'))
            .thenAnswer((_) async {});
        when(() => accountsDao.deleteAccount('acc-1'))
            .thenAnswer((_) async => 1);

        await repository.deleteAccount('acc-1');

        verify(() => accountsApiClient.deleteAccount('acc-1')).called(1);
        verify(() => accountsDao.deleteAccount('acc-1')).called(1);
      });

      test('throws AccountException on API failure', () async {
        when(() => accountsApiClient.deleteAccount('acc-1'))
            .thenThrow(const EnvelopeApiException('Delete failed'));

        expect(
          () => repository.deleteAccount('acc-1'),
          throwsA(isA<AccountException>()),
        );
      });

      test('succeeds even if local delete fails', () async {
        when(() => accountsApiClient.deleteAccount('acc-1'))
            .thenAnswer((_) async {});
        when(() => accountsDao.deleteAccount('acc-1'))
            .thenThrow(Exception('DB error'));

        // Should not throw — local failure is best-effort.
        await repository.deleteAccount('acc-1');

        verify(() => accountsApiClient.deleteAccount('acc-1')).called(1);
      });
    });

    group('archiveAccount', () {
      test('sets isArchived to true and updates', () async {
        when(() => accountsDao.getAccount('acc-1'))
            .thenAnswer((_) async => testLocalAccount);
        when(() => accountsApiClient.updateAccount(any()))
            .thenAnswer((_) async => testAccountDto);
        when(
          () => accountsDao.insertAccount(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.archiveAccount('acc-1');

        final captured = verify(
          () => accountsApiClient.updateAccount(captureAny()),
        ).captured;
        final updatedDto = captured.first as AccountDto;
        expect(updatedDto.isArchived, isTrue);
      });

      test('throws AccountException on failure', () async {
        when(() => accountsDao.getAccount('acc-1'))
            .thenAnswer((_) async => null);
        when(() => accountsApiClient.getAccount('acc-1'))
            .thenThrow(const EnvelopeApiException('Not found'));

        expect(
          () => repository.archiveAccount('acc-1'),
          throwsA(isA<AccountException>()),
        );
      });
    });

    group('unarchiveAccount', () {
      test('sets isArchived to false and updates', () async {
        final archivedLocal = storage.Account(
          id: 'acc-1',
          budgetId: 'budget-1',
          name: 'Checking',
          type: 'checking',
          currency: 'USD',
          startingBalance: 10000,
          currentBalance: 15000,
          isArchived: true,
          createdAt: now,
          updatedAt: now,
        );
        when(() => accountsDao.getAccount('acc-1'))
            .thenAnswer((_) async => archivedLocal);
        when(() => accountsApiClient.updateAccount(any()))
            .thenAnswer((_) async => testAccountDto);
        when(
          () => accountsDao.insertAccount(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.unarchiveAccount('acc-1');

        final captured = verify(
          () => accountsApiClient.updateAccount(captureAny()),
        ).captured;
        final updatedDto = captured.first as AccountDto;
        expect(updatedDto.isArchived, isFalse);
      });
    });

    group('reconcileAccount', () {
      test('updates currentBalance to the reconciled value', () async {
        when(() => accountsDao.getAccount('acc-1'))
            .thenAnswer((_) async => testLocalAccount);
        when(() => accountsApiClient.updateAccount(any()))
            .thenAnswer((_) async => testAccountDto);
        when(
          () => accountsDao.insertAccount(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.reconcileAccount('acc-1', 20000);

        final captured = verify(
          () => accountsApiClient.updateAccount(captureAny()),
        ).captured;
        final updatedDto = captured.first as AccountDto;
        expect(updatedDto.currentBalance, equals(20000));
      });

      test('throws AccountException on failure', () async {
        when(() => accountsDao.getAccount('acc-1'))
            .thenAnswer((_) async => null);
        when(() => accountsApiClient.getAccount('acc-1'))
            .thenThrow(const EnvelopeApiException('Not found'));

        expect(
          () => repository.reconcileAccount('acc-1', 20000),
          throwsA(isA<AccountException>()),
        );
      });
    });

    group('refreshAccounts', () {
      test('fetches from API and batch-caches all accounts', () async {
        when(() => accountsApiClient.getAccountsByBudget('budget-1'))
            .thenAnswer((_) async => [testAccountDto]);
        when(
          () => accountsDao.batchInsertAccounts(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async {});

        await repository.refreshAccounts('budget-1');

        verify(
          () => accountsApiClient.getAccountsByBudget('budget-1'),
        ).called(1);
        verify(
          () => accountsDao.batchInsertAccounts(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws AccountException on API failure', () async {
        when(() => accountsApiClient.getAccountsByBudget('budget-1'))
            .thenThrow(const EnvelopeApiException('Network error'));

        expect(
          () => repository.refreshAccounts('budget-1'),
          throwsA(isA<AccountException>()),
        );
      });
    });

    group('createDebtAccount', () {
      test('creates debt account via API and caches locally', () async {
        when(() => accountsApiClient.createDebtAccount(any()))
            .thenAnswer((_) async => testDebtAccountDto);
        when(
          () => accountsDao.insertDebtAccount(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createDebtAccount(
          accountId: 'acc-1',
          interestRate: 5.5,
          minimumPayment: 5000,
          originalBalance: 100000,
          payoffStrategy: 'avalanche',
        );

        expect(result.accountId, equals('acc-1'));
        expect(result.interestRate, equals(5.5));
      });

      test('throws AccountException on API failure', () async {
        when(() => accountsApiClient.createDebtAccount(any()))
            .thenThrow(const EnvelopeApiException('Create failed'));

        expect(
          () => repository.createDebtAccount(
            accountId: 'acc-1',
            interestRate: 5.5,
            minimumPayment: 5000,
            originalBalance: 100000,
          ),
          throwsA(isA<AccountException>()),
        );
      });
    });

    group('getDebtAccount', () {
      test('returns from local storage when available', () async {
        when(() => accountsDao.getDebtAccount('acc-1'))
            .thenAnswer((_) async => testLocalDebtAccount);

        final result = await repository.getDebtAccount('acc-1');

        expect(result, isNotNull);
        expect(result!.accountId, equals('acc-1'));
        verifyNever(() => accountsApiClient.getDebtAccount(any()));
      });

      test('falls back to API when not in local storage', () async {
        when(() => accountsDao.getDebtAccount('acc-1'))
            .thenAnswer((_) async => null);
        when(() => accountsApiClient.getDebtAccount('acc-1'))
            .thenAnswer((_) async => testDebtAccountDto);
        when(
          () => accountsDao.insertDebtAccount(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.getDebtAccount('acc-1');

        expect(result, isNotNull);
        expect(result!.interestRate, equals(5.5));
      });

      test('returns null when not found locally or remotely', () async {
        when(() => accountsDao.getDebtAccount('acc-1'))
            .thenAnswer((_) async => null);
        when(() => accountsApiClient.getDebtAccount('acc-1'))
            .thenAnswer((_) async => null);

        final result = await repository.getDebtAccount('acc-1');

        expect(result, isNull);
      });

      test('throws AccountException on API failure', () async {
        when(() => accountsDao.getDebtAccount('acc-1'))
            .thenAnswer((_) async => null);
        when(() => accountsApiClient.getDebtAccount('acc-1'))
            .thenThrow(const EnvelopeApiException('Network error'));

        expect(
          () => repository.getDebtAccount('acc-1'),
          throwsA(isA<AccountException>()),
        );
      });
    });

    group('updateDebtAccount', () {
      test('updates via API and caches locally', () async {
        when(() => accountsApiClient.updateDebtAccount(any()))
            .thenAnswer((_) async => testDebtAccountDto);
        when(
          () => accountsDao.insertDebtAccount(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.updateDebtAccount(testDebtAccount);

        verify(() => accountsApiClient.updateDebtAccount(any())).called(1);
        verify(
          () => accountsDao.insertDebtAccount(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws AccountException on API failure', () async {
        when(() => accountsApiClient.updateDebtAccount(any()))
            .thenThrow(const EnvelopeApiException('Update failed'));

        expect(
          () => repository.updateDebtAccount(testDebtAccount),
          throwsA(isA<AccountException>()),
        );
      });
    });

    group('deleteDebtAccount', () {
      test('deletes from API and local storage', () async {
        when(() => accountsApiClient.deleteDebtAccount('acc-1'))
            .thenAnswer((_) async {});
        when(() => accountsDao.deleteDebtAccount('acc-1'))
            .thenAnswer((_) async => 1);

        await repository.deleteDebtAccount('acc-1');

        verify(() => accountsApiClient.deleteDebtAccount('acc-1')).called(1);
        verify(() => accountsDao.deleteDebtAccount('acc-1')).called(1);
      });

      test('throws AccountException on API failure', () async {
        when(() => accountsApiClient.deleteDebtAccount('acc-1'))
            .thenThrow(const EnvelopeApiException('Delete failed'));

        expect(
          () => repository.deleteDebtAccount('acc-1'),
          throwsA(isA<AccountException>()),
        );
      });

      test('succeeds even if local delete fails', () async {
        when(() => accountsApiClient.deleteDebtAccount('acc-1'))
            .thenAnswer((_) async {});
        when(() => accountsDao.deleteDebtAccount('acc-1'))
            .thenThrow(Exception('DB error'));

        await repository.deleteDebtAccount('acc-1');

        verify(() => accountsApiClient.deleteDebtAccount('acc-1')).called(1);
      });
    });
  });

  group('AccountException', () {
    test('toString includes error details when present', () {
      const exception = AccountException(
        'Failed',
        error: EnvelopeApiException('Network timeout'),
      );

      expect(
        exception.toString(),
        contains('EnvelopeApiException: Network timeout'),
      );
    });

    test('toString omits error when null', () {
      const exception = AccountException('Failed');

      expect(exception.toString(), equals('AccountException: Failed'));
    });
  });
}
