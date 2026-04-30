import 'package:account_repository/account_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/accounts/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockAccountRepository accountRepository;

  final now = DateTime(2024);
  final testAccounts = [
    Account(
      id: 'acc-1',
      budgetId: 'budget-1',
      name: 'Checking',
      type: 'checking',
      currency: 'USD',
      startingBalance: 10000,
      currentBalance: 15000,
      createdAt: now,
      updatedAt: now,
    ),
    Account(
      id: 'acc-2',
      budgetId: 'budget-1',
      name: 'Savings',
      type: 'savings',
      currency: 'USD',
      startingBalance: 50000,
      currentBalance: 60000,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    accountRepository = MockAccountRepository();
  });

  group('AccountsBloc', () {
    blocTest<AccountsBloc, AccountsState>(
      'emits [loading, loaded] when AccountsStarted is added',
      build: () {
        when(
          () => accountRepository.watchAccounts('budget-1'),
        ).thenAnswer((_) => Stream.value(testAccounts));
        when(
          () => accountRepository.refreshAccounts('budget-1'),
        ).thenAnswer((_) async {});
        return AccountsBloc(
          accountRepository: accountRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const AccountsStarted()),
      expect: () => [
        const AccountsState(status: AccountsStatus.loading),
        AccountsState(
          status: AccountsStatus.loaded,
          accounts: testAccounts,
        ),
      ],
      verify: (_) {
        verify(() => accountRepository.watchAccounts('budget-1')).called(1);
        verify(() => accountRepository.refreshAccounts('budget-1')).called(1);
      },
    );

    blocTest<AccountsBloc, AccountsState>(
      'still loads from local stream when refresh fails',
      build: () {
        when(
          () => accountRepository.watchAccounts('budget-1'),
        ).thenAnswer((_) => Stream.value(testAccounts));
        when(
          () => accountRepository.refreshAccounts('budget-1'),
        ).thenThrow(const AccountException('Network error'));
        return AccountsBloc(
          accountRepository: accountRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const AccountsStarted()),
      expect: () => [
        const AccountsState(status: AccountsStatus.loading),
        AccountsState(
          status: AccountsStatus.loaded,
          accounts: testAccounts,
        ),
      ],
    );

    blocTest<AccountsBloc, AccountsState>(
      'archives account when AccountArchiveToggled is added '
      'with non-archived account',
      build: () {
        when(
          () => accountRepository.archiveAccount('acc-1'),
        ).thenAnswer((_) async {});
        return AccountsBloc(
          accountRepository: accountRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(AccountArchiveToggled(testAccounts.first)),
      verify: (_) {
        verify(() => accountRepository.archiveAccount('acc-1')).called(1);
      },
    );

    blocTest<AccountsBloc, AccountsState>(
      'unarchives account when AccountArchiveToggled is added '
      'with archived account',
      build: () {
        when(
          () => accountRepository.unarchiveAccount('acc-1'),
        ).thenAnswer((_) async {});
        return AccountsBloc(
          accountRepository: accountRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(
        AccountArchiveToggled(
          testAccounts.first.copyWith(isArchived: true),
        ),
      ),
      verify: (_) {
        verify(() => accountRepository.unarchiveAccount('acc-1')).called(1);
      },
    );

    blocTest<AccountsBloc, AccountsState>(
      'emits error then loaded when archive fails',
      build: () {
        when(
          () => accountRepository.archiveAccount('acc-1'),
        ).thenThrow(const AccountException('Failed'));
        return AccountsBloc(
          accountRepository: accountRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(AccountArchiveToggled(testAccounts.first)),
      expect: () => [
        const AccountsState(
          status: AccountsStatus.error,
          error: AccountsError.updateFailed,
        ),
        const AccountsState(status: AccountsStatus.loaded),
      ],
    );

    blocTest<AccountsBloc, AccountsState>(
      'emits error then loaded when delete fails',
      build: () {
        when(
          () => accountRepository.deleteAccount('acc-1'),
        ).thenThrow(const AccountException('Failed'));
        return AccountsBloc(
          accountRepository: accountRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const AccountDeleted('acc-1')),
      expect: () => [
        const AccountsState(
          status: AccountsStatus.error,
          error: AccountsError.deleteFailed,
        ),
        const AccountsState(status: AccountsStatus.loaded),
      ],
    );

    blocTest<AccountsBloc, AccountsState>(
      'deletes account when AccountDeleted is added',
      build: () {
        when(
          () => accountRepository.deleteAccount('acc-1'),
        ).thenAnswer((_) async {});
        return AccountsBloc(
          accountRepository: accountRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const AccountDeleted('acc-1')),
      verify: (_) {
        verify(() => accountRepository.deleteAccount('acc-1')).called(1);
      },
    );

    blocTest<AccountsBloc, AccountsState>(
      'refreshes accounts when AccountsRefreshRequested is added',
      build: () {
        when(
          () => accountRepository.refreshAccounts('budget-1'),
        ).thenAnswer((_) async {});
        return AccountsBloc(
          accountRepository: accountRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const AccountsRefreshRequested()),
      verify: (_) {
        verify(() => accountRepository.refreshAccounts('budget-1')).called(1);
      },
    );
  });

  group('AccountsState', () {
    test('activeAccountsByType groups non-archived accounts', () {
      final state = AccountsState(accounts: testAccounts);
      final grouped = state.activeAccountsByType;

      expect(grouped.keys.length, equals(2));
      expect(grouped['checking']!.length, equals(1));
      expect(grouped['savings']!.length, equals(1));
    });

    test('archivedAccounts returns only archived', () {
      final state = AccountsState(
        accounts: [
          ...testAccounts,
          testAccounts.first.copyWith(
            id: 'acc-3',
            isArchived: true,
          ),
        ],
      );

      expect(state.archivedAccounts.length, equals(1));
      expect(state.archivedAccounts.first.id, equals('acc-3'));
    });

    test('totalBalance sums active accounts only', () {
      final state = AccountsState(
        accounts: [
          ...testAccounts,
          testAccounts.first.copyWith(
            id: 'acc-3',
            currentBalance: 99999,
            isArchived: true,
          ),
        ],
      );

      expect(state.totalBalance, equals(75000)); // 15000 + 60000
    });
  });
}
