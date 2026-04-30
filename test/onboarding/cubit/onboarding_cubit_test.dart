import 'package:account_repository/account_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/onboarding/cubit/cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  group('OnboardingCubit', () {
    late SharedPreferences prefs;
    late MockEnvelopeRepository envelopeRepository;
    late MockAccountRepository accountRepository;
    late MockBudgetRepository budgetRepository;

    const testUserId = 'test-user-id';
    const testBudgetId = 'test-budget-id';

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      envelopeRepository = MockEnvelopeRepository();
      accountRepository = MockAccountRepository();
      budgetRepository = MockBudgetRepository();
    });

    OnboardingCubit buildCubit() => OnboardingCubit(
      sharedPreferences: prefs,
      envelopeRepository: envelopeRepository,
      accountRepository: accountRepository,
      budgetRepository: budgetRepository,
      userId: testUserId,
    );

    test('initial state is correct', () {
      final cubit = buildCubit();
      expect(cubit.state, const OnboardingState());
      expect(
        cubit.state.currentStep,
        OnboardingStep.welcome,
      );
      expect(cubit.state.status, OnboardingStatus.initial);
      expect(cubit.state.baseCurrency, 'USD');
      expect(cubit.state.accounts, isEmpty);
      expect(cubit.state.categoryGroups, defaultCategoryGroups);
      expect(cubit.state.allocations, isEmpty);
    });

    group('step navigation', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'nextStep advances from welcome to currency',
        build: buildCubit,
        act: (cubit) => cubit.nextStep(),
        expect: () => [
          const OnboardingState(
            currentStep: OnboardingStep.currency,
          ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'previousStep goes from currency to welcome',
        build: buildCubit,
        seed: () => const OnboardingState(
          currentStep: OnboardingStep.currency,
        ),
        act: (cubit) => cubit.previousStep(),
        expect: () => [
          const OnboardingState(),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'previousStep does nothing on welcome step',
        build: buildCubit,
        act: (cubit) => cubit.previousStep(),
        expect: () => <OnboardingState>[],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'nextStep does not advance past allocation',
        build: buildCubit,
        seed: () => const OnboardingState(
          currentStep: OnboardingStep.allocation,
        ),
        act: (cubit) => cubit.nextStep(),
        expect: () => <OnboardingState>[],
      );
    });

    group('accounts validation', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'nextStep fails on accounts step with no accounts',
        build: buildCubit,
        seed: () => const OnboardingState(
          currentStep: OnboardingStep.accounts,
        ),
        act: (cubit) => cubit.nextStep(),
        expect: () => [
          isA<OnboardingState>()
              .having(
                (s) => s.status,
                'status',
                OnboardingStatus.failure,
              )
              .having(
                (s) => s.error,
                'error',
                OnboardingError.accountRequired,
              ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'nextStep advances on accounts step with accounts',
        build: buildCubit,
        seed: () => const OnboardingState(
          currentStep: OnboardingStep.accounts,
          accounts: [
            OnboardingAccount(
              name: 'Checking',
              type: 'checking',
              currency: 'USD',
            ),
          ],
        ),
        act: (cubit) => cubit.nextStep(),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.currentStep,
            'currentStep',
            OnboardingStep.envelopes,
          ),
        ],
      );
    });

    group('envelope validation', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'nextStep fails on envelopes step with no envelopes',
        build: buildCubit,
        seed: () => const OnboardingState(
          currentStep: OnboardingStep.envelopes,
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'Empty',
              envelopes: <String>[],
            ),
          ],
        ),
        act: (cubit) => cubit.nextStep(),
        expect: () => [
          isA<OnboardingState>()
              .having(
                (s) => s.status,
                'status',
                OnboardingStatus.failure,
              )
              .having(
                (s) => s.error,
                'error',
                OnboardingError.envelopeRequired,
              ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'nextStep advances on envelopes step with envelopes',
        build: buildCubit,
        seed: () => const OnboardingState(
          currentStep: OnboardingStep.envelopes,
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'Needs',
              envelopes: ['Rent'],
            ),
          ],
        ),
        act: (cubit) => cubit.nextStep(),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.currentStep,
            'currentStep',
            OnboardingStep.allocation,
          ),
        ],
      );
    });

    group('currency selection', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'selectCurrency updates baseCurrency',
        build: buildCubit,
        act: (cubit) => cubit.selectCurrency('EUR'),
        expect: () => [
          const OnboardingState(baseCurrency: 'EUR'),
        ],
      );
    });

    group('account CRUD', () {
      const account = OnboardingAccount(
        name: 'Checking',
        type: 'checking',
        currency: 'USD',
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'addAccount adds to list',
        build: buildCubit,
        act: (cubit) => cubit.addAccount(account),
        expect: () => [
          const OnboardingState(accounts: [account]),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'removeAccount removes by index',
        build: buildCubit,
        seed: () => const OnboardingState(accounts: [account]),
        act: (cubit) => cubit.removeAccount(0),
        expect: () => [
          const OnboardingState(),
        ],
      );
    });

    group('category group CRUD', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'addCategoryGroup adds a new group',
        build: buildCubit,
        act: (cubit) => cubit.addCategoryGroup('Custom'),
        expect: () => [
          isA<OnboardingState>()
              .having(
                (s) => s.categoryGroups.length,
                'length',
                defaultCategoryGroups.length + 1,
              )
              .having(
                (s) => s.categoryGroups.last.name,
                'last group name',
                'Custom',
              ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'removeCategoryGroup removes by index',
        build: buildCubit,
        seed: () => const OnboardingState(
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'A',
              envelopes: ['a1'],
            ),
            OnboardingCategoryGroup(
              name: 'B',
              envelopes: ['b1'],
            ),
          ],
        ),
        act: (cubit) => cubit.removeCategoryGroup(0),
        expect: () => [
          const OnboardingState(
            categoryGroups: [
              OnboardingCategoryGroup(
                name: 'B',
                envelopes: ['b1'],
              ),
            ],
          ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'renameCategoryGroup renames by index',
        build: buildCubit,
        seed: () => const OnboardingState(
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'Old',
              envelopes: [],
            ),
          ],
        ),
        act: (cubit) => cubit.renameCategoryGroup(0, 'New'),
        expect: () => [
          const OnboardingState(
            categoryGroups: [
              OnboardingCategoryGroup(
                name: 'New',
                envelopes: [],
              ),
            ],
          ),
        ],
      );
    });

    group('envelope CRUD', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'addEnvelope adds to group',
        build: buildCubit,
        seed: () => const OnboardingState(
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'Group',
              envelopes: [],
            ),
          ],
        ),
        act: (cubit) => cubit.addEnvelope(0, 'Rent'),
        expect: () => [
          const OnboardingState(
            categoryGroups: [
              OnboardingCategoryGroup(
                name: 'Group',
                envelopes: ['Rent'],
              ),
            ],
          ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'removeEnvelope removes from group',
        build: buildCubit,
        seed: () => const OnboardingState(
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'Group',
              envelopes: ['Rent', 'Food'],
            ),
          ],
        ),
        act: (cubit) => cubit.removeEnvelope(0, 0),
        expect: () => [
          const OnboardingState(
            categoryGroups: [
              OnboardingCategoryGroup(
                name: 'Group',
                envelopes: ['Food'],
              ),
            ],
          ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'renameEnvelope renames in group',
        build: buildCubit,
        seed: () => const OnboardingState(
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'Group',
              envelopes: ['Old'],
            ),
          ],
        ),
        act: (cubit) => cubit.renameEnvelope(0, 0, 'New'),
        expect: () => [
          const OnboardingState(
            categoryGroups: [
              OnboardingCategoryGroup(
                name: 'Group',
                envelopes: ['New'],
              ),
            ],
          ),
        ],
      );
    });

    group('allocation', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'setAllocation updates allocation map with composite key',
        build: buildCubit,
        act: (cubit) => cubit.setAllocation(0, 'Rent', 1500),
        expect: () => [
          const OnboardingState(
            allocations: {'0:Rent': 1500},
          ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'getAllocation returns value for composite key',
        build: buildCubit,
        seed: () => const OnboardingState(
          allocations: {'0:Rent': 1500},
        ),
        verify: (cubit) {
          expect(cubit.getAllocation(0, 'Rent'), 1500);
          expect(cubit.getAllocation(1, 'Rent'), 0);
        },
      );
    });

    group('completeOnboarding', () {
      final now = DateTime.now();

      void stubCreateBudget() {
        when(
          () => budgetRepository.createBudget(
            name: any(named: 'name'),
            baseCurrency: any(named: 'baseCurrency'),
            ownerId: any(named: 'ownerId'),
          ),
        ).thenAnswer(
          (_) async => Budget(
            id: testBudgetId,
            ownerId: testUserId,
            name: 'My Budget',
            baseCurrency: 'USD',
            createdAt: now,
            updatedAt: now,
          ),
        );
        when(
          () => budgetRepository.createBudgetPeriod(
            budgetId: any(named: 'budgetId'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
            totalIncome: any(named: 'totalIncome'),
          ),
        ).thenAnswer(
          (_) async => BudgetPeriod(
            id: 'period-1',
            budgetId: testBudgetId,
            startDate: DateTime(now.year, now.month),
            endDate: DateTime(
              now.year,
              now.month + 1,
            ).subtract(const Duration(days: 1)),
            createdAt: now,
          ),
        );
      }

      blocTest<OnboardingCubit, OnboardingState>(
        'creates budget first, then persists accounts, groups, envelopes',
        build: () {
          stubCreateBudget();
          when(
            () => accountRepository.createAccount(
              budgetId: any(named: 'budgetId'),
              name: any(named: 'name'),
              type: any(named: 'type'),
              currency: any(named: 'currency'),
              startingBalance: any(named: 'startingBalance'),
            ),
          ).thenAnswer(
            (_) async => Account(
              id: 'acc-1',
              budgetId: testBudgetId,
              name: 'Checking',
              type: 'checking',
              currency: 'USD',
              createdAt: now,
              updatedAt: now,
            ),
          );
          when(
            () => envelopeRepository.createCategoryGroup(
              budgetId: any(named: 'budgetId'),
              name: any(named: 'name'),
            ),
          ).thenAnswer(
            (_) async => CategoryGroup(
              id: 'group-1',
              budgetId: testBudgetId,
              name: 'Needs',
              createdAt: now,
            ),
          );
          when(
            () => envelopeRepository.createEnvelope(
              categoryGroupId: any(named: 'categoryGroupId'),
              budgetId: any(named: 'budgetId'),
              name: any(named: 'name'),
            ),
          ).thenAnswer(
            (_) async => Envelope(
              id: 'env-1',
              categoryGroupId: 'group-1',
              budgetId: testBudgetId,
              name: 'Rent',
              createdAt: now,
            ),
          );
          return buildCubit();
        },
        seed: () => const OnboardingState(
          accounts: [
            OnboardingAccount(
              name: 'Checking',
              type: 'checking',
              currency: 'USD',
              startingBalance: 1500.50,
            ),
          ],
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'Needs',
              envelopes: ['Rent', 'Groceries'],
            ),
          ],
        ),
        act: (cubit) => cubit.completeOnboarding(),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.status,
            'status',
            OnboardingStatus.submitting,
          ),
          isA<OnboardingState>().having(
            (s) => s.status,
            'status',
            OnboardingStatus.success,
          ),
        ],
        verify: (_) {
          verify(
            () => budgetRepository.createBudget(
              name: 'My Budget',
              baseCurrency: 'USD',
              ownerId: testUserId,
            ),
          ).called(1);
          verify(
            () => accountRepository.createAccount(
              budgetId: testBudgetId,
              name: 'Checking',
              type: 'checking',
              currency: 'USD',
              startingBalance: 150050,
            ),
          ).called(1);
          verify(
            () => envelopeRepository.createCategoryGroup(
              budgetId: testBudgetId,
              name: 'Needs',
            ),
          ).called(1);
          verify(
            () => envelopeRepository.createEnvelope(
              categoryGroupId: 'group-1',
              budgetId: testBudgetId,
              name: 'Rent',
            ),
          ).called(1);
          verify(
            () => envelopeRepository.createEnvelope(
              categoryGroupId: 'group-1',
              budgetId: testBudgetId,
              name: 'Groceries',
            ),
          ).called(1);
          expect(prefs.getBool('onboarding_complete'), isTrue);
          expect(prefs.getString('active_budget_id'), testBudgetId);
        },
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'assigns envelopes to correct group when multiple groups',
        build: () {
          stubCreateBudget();
          var groupCallCount = 0;
          when(
            () => accountRepository.createAccount(
              budgetId: any(named: 'budgetId'),
              name: any(named: 'name'),
              type: any(named: 'type'),
              currency: any(named: 'currency'),
              startingBalance: any(named: 'startingBalance'),
            ),
          ).thenAnswer(
            (_) async => Account(
              id: 'acc-1',
              budgetId: testBudgetId,
              name: 'Checking',
              type: 'checking',
              currency: 'USD',
              createdAt: now,
              updatedAt: now,
            ),
          );
          when(
            () => envelopeRepository.createCategoryGroup(
              budgetId: any(named: 'budgetId'),
              name: any(named: 'name'),
            ),
          ).thenAnswer((_) async {
            groupCallCount++;
            return CategoryGroup(
              id: 'group-$groupCallCount',
              budgetId: testBudgetId,
              name: groupCallCount == 1 ? 'Needs' : 'Wants',
              createdAt: now,
            );
          });
          when(
            () => envelopeRepository.createEnvelope(
              categoryGroupId: any(named: 'categoryGroupId'),
              budgetId: any(named: 'budgetId'),
              name: any(named: 'name'),
            ),
          ).thenAnswer(
            (_) async => Envelope(
              id: 'env-1',
              categoryGroupId: 'group-1',
              budgetId: testBudgetId,
              name: 'Rent',
              createdAt: now,
            ),
          );
          return buildCubit();
        },
        seed: () => const OnboardingState(
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'Needs',
              envelopes: ['Rent'],
            ),
            OnboardingCategoryGroup(
              name: 'Wants',
              envelopes: ['Dining Out'],
            ),
          ],
        ),
        act: (cubit) => cubit.completeOnboarding(),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.status,
            'status',
            OnboardingStatus.submitting,
          ),
          isA<OnboardingState>().having(
            (s) => s.status,
            'status',
            OnboardingStatus.success,
          ),
        ],
        verify: (_) {
          verify(
            () => envelopeRepository.createCategoryGroup(
              budgetId: testBudgetId,
              name: 'Needs',
            ),
          ).called(1);
          verify(
            () => envelopeRepository.createCategoryGroup(
              budgetId: testBudgetId,
              name: 'Wants',
            ),
          ).called(1);
          verify(
            () => envelopeRepository.createEnvelope(
              categoryGroupId: 'group-1',
              budgetId: testBudgetId,
              name: 'Rent',
            ),
          ).called(1);
          verify(
            () => envelopeRepository.createEnvelope(
              categoryGroupId: 'group-2',
              budgetId: testBudgetId,
              name: 'Dining Out',
            ),
          ).called(1);
        },
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits failure when repository throws',
        build: () {
          stubCreateBudget();
          when(
            () => accountRepository.createAccount(
              budgetId: any(named: 'budgetId'),
              name: any(named: 'name'),
              type: any(named: 'type'),
              currency: any(named: 'currency'),
              startingBalance: any(named: 'startingBalance'),
            ),
          ).thenThrow(Exception('network error'));
          return buildCubit();
        },
        seed: () => const OnboardingState(
          accounts: [
            OnboardingAccount(
              name: 'Checking',
              type: 'checking',
              currency: 'USD',
            ),
          ],
        ),
        act: (cubit) => cubit.completeOnboarding(),
        expect: () => [
          isA<OnboardingState>().having(
            (s) => s.status,
            'status',
            OnboardingStatus.submitting,
          ),
          isA<OnboardingState>()
              .having(
                (s) => s.status,
                'status',
                OnboardingStatus.failure,
              )
              .having(
                (s) => s.error,
                'error',
                OnboardingError.completionFailed,
              ),
        ],
      );

      group('credit cards', () {
        Account ccAccount(String id, String name) => Account(
          id: id,
          budgetId: testBudgetId,
          name: name,
          type: 'credit_card',
          currency: 'USD',
          createdAt: now,
          updatedAt: now,
        );

        CategoryGroup catGroup(String id, String name) => CategoryGroup(
          id: id,
          budgetId: testBudgetId,
          name: name,
          createdAt: now,
        );

        Envelope envelope(String id, String groupId, String name) => Envelope(
          id: id,
          categoryGroupId: groupId,
          budgetId: testBudgetId,
          name: name,
          createdAt: now,
        );

        void stubAccountCreate(Account account) {
          when(
            () => accountRepository.createAccount(
              budgetId: any(named: 'budgetId'),
              name: any(named: 'name'),
              type: any(named: 'type'),
              currency: any(named: 'currency'),
              startingBalance: any(named: 'startingBalance'),
              isOnBudget: any(named: 'isOnBudget'),
            ),
          ).thenAnswer((_) async => account);
        }

        void stubEnvelopeCreate(Envelope env) {
          when(
            () => envelopeRepository.createEnvelope(
              categoryGroupId: any(named: 'categoryGroupId'),
              budgetId: any(named: 'budgetId'),
              name: any(named: 'name'),
              linkedAccountId: any(named: 'linkedAccountId'),
            ),
          ).thenAnswer((_) async => env);
        }

        void stubGroupCreate(CategoryGroup group) {
          when(
            () => envelopeRepository.createCategoryGroup(
              budgetId: any(named: 'budgetId'),
              name: any(named: 'name'),
            ),
          ).thenAnswer((_) async => group);
        }

        void stubWatchGroups(List<CategoryGroup> groups) {
          when(
            () => envelopeRepository.watchCategoryGroups(any()),
          ).thenAnswer((_) => Stream.value(groups));
        }

        blocTest<OnboardingCubit, OnboardingState>(
          'persists credit limit and creates linked CC payment envelope',
          build: () {
            stubCreateBudget();
            stubAccountCreate(ccAccount('acc-cc', 'Visa'));
            stubGroupCreate(catGroup('cc-group', 'Credit Card Payments'));
            stubEnvelopeCreate(envelope('env-cc', 'cc-group', 'Visa Payment'));
            stubWatchGroups(const []);
            when(
              () => accountRepository.upsertDebtAccountCreditLimit(
                any(),
                any(),
              ),
            ).thenAnswer((_) async {});
            return buildCubit();
          },
          seed: () => const OnboardingState(
            accounts: [
              OnboardingAccount(
                name: 'Visa',
                type: 'credit_card',
                currency: 'USD',
                creditLimitCents: 500000,
              ),
            ],
            categoryGroups: [],
          ),
          act: (cubit) => cubit.completeOnboarding(),
          verify: (_) {
            verify(
              () => accountRepository.upsertDebtAccountCreditLimit(
                'acc-cc',
                500000,
              ),
            ).called(1);
            verify(
              () => envelopeRepository.createCategoryGroup(
                budgetId: testBudgetId,
                name: 'Credit Card Payments',
              ),
            ).called(1);
            verify(
              () => envelopeRepository.createEnvelope(
                categoryGroupId: 'cc-group',
                budgetId: testBudgetId,
                name: 'Visa Payment',
                linkedAccountId: 'acc-cc',
              ),
            ).called(1);
          },
        );

        blocTest<OnboardingCubit, OnboardingState>(
          'skips upsert when creditLimitCents is null but still creates env',
          build: () {
            stubCreateBudget();
            stubAccountCreate(ccAccount('acc-cc', 'Amex'));
            stubGroupCreate(catGroup('cc-group', 'Credit Card Payments'));
            stubEnvelopeCreate(envelope('env-cc', 'cc-group', 'Amex Payment'));
            stubWatchGroups(const []);
            return buildCubit();
          },
          seed: () => const OnboardingState(
            accounts: [
              OnboardingAccount(
                name: 'Amex',
                type: 'credit_card',
                currency: 'USD',
              ),
            ],
            categoryGroups: [],
          ),
          act: (cubit) => cubit.completeOnboarding(),
          verify: (_) {
            verifyNever(
              () => accountRepository.upsertDebtAccountCreditLimit(
                any(),
                any(),
              ),
            );
            verify(
              () => envelopeRepository.createEnvelope(
                categoryGroupId: 'cc-group',
                budgetId: testBudgetId,
                name: 'Amex Payment',
                linkedAccountId: 'acc-cc',
              ),
            ).called(1);
          },
        );

        blocTest<OnboardingCubit, OnboardingState>(
          'creates one CC group for multiple cards and one envelope per card',
          build: () {
            stubCreateBudget();
            var n = 0;
            when(
              () => accountRepository.createAccount(
                budgetId: any(named: 'budgetId'),
                name: any(named: 'name'),
                type: any(named: 'type'),
                currency: any(named: 'currency'),
                startingBalance: any(named: 'startingBalance'),
                isOnBudget: any(named: 'isOnBudget'),
              ),
            ).thenAnswer((invocation) async {
              n++;
              return ccAccount(
                'acc-$n',
                invocation.namedArguments[#name] as String,
              );
            });
            stubGroupCreate(catGroup('cc-group', 'Credit Card Payments'));
            stubEnvelopeCreate(envelope('env-cc', 'cc-group', 'X Payment'));
            stubWatchGroups(const []);
            return buildCubit();
          },
          seed: () => const OnboardingState(
            accounts: [
              OnboardingAccount(
                name: 'Visa',
                type: 'credit_card',
                currency: 'USD',
              ),
              OnboardingAccount(
                name: 'Amex',
                type: 'credit_card',
                currency: 'USD',
              ),
            ],
            categoryGroups: [],
          ),
          act: (cubit) => cubit.completeOnboarding(),
          verify: (_) {
            verify(
              () => envelopeRepository.createCategoryGroup(
                budgetId: testBudgetId,
                name: 'Credit Card Payments',
              ),
            ).called(1);
            verify(
              () => envelopeRepository.createEnvelope(
                categoryGroupId: 'cc-group',
                budgetId: testBudgetId,
                name: any(named: 'name'),
                linkedAccountId: any(named: 'linkedAccountId'),
              ),
            ).called(2);
          },
        );

        blocTest<OnboardingCubit, OnboardingState>(
          'reuses existing Credit Card Payments group when present',
          build: () {
            stubCreateBudget();
            stubAccountCreate(ccAccount('acc-cc', 'Visa'));
            stubEnvelopeCreate(envelope('env-cc', 'existing', 'Visa Payment'));
            stubWatchGroups(
              [catGroup('existing', 'Credit Card Payments')],
            );
            return buildCubit();
          },
          seed: () => const OnboardingState(
            accounts: [
              OnboardingAccount(
                name: 'Visa',
                type: 'credit_card',
                currency: 'USD',
              ),
            ],
            categoryGroups: [],
          ),
          act: (cubit) => cubit.completeOnboarding(),
          verify: (_) {
            verifyNever(
              () => envelopeRepository.createCategoryGroup(
                budgetId: any(named: 'budgetId'),
                name: 'Credit Card Payments',
              ),
            );
            verify(
              () => envelopeRepository.createEnvelope(
                categoryGroupId: 'existing',
                budgetId: testBudgetId,
                name: 'Visa Payment',
                linkedAccountId: 'acc-cc',
              ),
            ).called(1);
          },
        );

        blocTest<OnboardingCubit, OnboardingState>(
          'completes successfully when CC envelope creation throws',
          build: () {
            stubCreateBudget();
            stubAccountCreate(ccAccount('acc-cc', 'Visa'));
            stubGroupCreate(catGroup('cc-group', 'Credit Card Payments'));
            stubWatchGroups(const []);
            when(
              () => envelopeRepository.createEnvelope(
                categoryGroupId: any(named: 'categoryGroupId'),
                budgetId: any(named: 'budgetId'),
                name: any(named: 'name'),
                linkedAccountId: any(named: 'linkedAccountId'),
              ),
            ).thenThrow(Exception('boom'));
            return buildCubit();
          },
          seed: () => const OnboardingState(
            accounts: [
              OnboardingAccount(
                name: 'Visa',
                type: 'credit_card',
                currency: 'USD',
              ),
            ],
            categoryGroups: [],
          ),
          act: (cubit) => cubit.completeOnboarding(),
          expect: () => [
            isA<OnboardingState>().having(
              (s) => s.status,
              'status',
              OnboardingStatus.submitting,
            ),
            isA<OnboardingState>().having(
              (s) => s.status,
              'status',
              OnboardingStatus.success,
            ),
          ],
        );

        blocTest<OnboardingCubit, OnboardingState>(
          'completes successfully when credit limit upsert throws',
          build: () {
            stubCreateBudget();
            stubAccountCreate(ccAccount('acc-cc', 'Visa'));
            stubGroupCreate(catGroup('cc-group', 'Credit Card Payments'));
            stubEnvelopeCreate(envelope('env-cc', 'cc-group', 'Visa Payment'));
            stubWatchGroups(const []);
            when(
              () => accountRepository.upsertDebtAccountCreditLimit(
                any(),
                any(),
              ),
            ).thenThrow(Exception('boom'));
            return buildCubit();
          },
          seed: () => const OnboardingState(
            accounts: [
              OnboardingAccount(
                name: 'Visa',
                type: 'credit_card',
                currency: 'USD',
                creditLimitCents: 500000,
              ),
            ],
            categoryGroups: [],
          ),
          act: (cubit) => cubit.completeOnboarding(),
          expect: () => [
            isA<OnboardingState>().having(
              (s) => s.status,
              'status',
              OnboardingStatus.submitting,
            ),
            isA<OnboardingState>().having(
              (s) => s.status,
              'status',
              OnboardingStatus.success,
            ),
          ],
        );
      });
    });

    group('isOnboardingComplete', () {
      test('returns false when not set', () {
        final result = OnboardingCubit.isOnboardingComplete(prefs);
        expect(result, isFalse);
      });

      test('returns true when flag is set', () async {
        await prefs.setBool('onboarding_complete', true);
        final result = OnboardingCubit.isOnboardingComplete(prefs);
        expect(result, isTrue);
      });
    });
  });
}
