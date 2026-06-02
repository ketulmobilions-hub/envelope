// Integration test for issue #81 — account-edit triggered seed-cash refresh.
//
// Wires the real `BudgetRepository` against an in-memory Drift database and a
// mocked `EnvelopeApiClient`. Seeds an on-budget account, edits its starting
// balance, asserts (a) `Budget.openingBalance` updates, (b) cascade
// propagates through `carriedRta`, (c) RTA in the anchor period reflects the
// new seed.

import 'package:budget_repository/budget_repository.dart';
import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:drift/native.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements EnvelopeApiClient {}

class _MockBudgetsApi extends Mock implements BudgetsApiClient {}

class _MockEnvelopesApi extends Mock implements EnvelopesApiClient {}

class _FakeBudgetDto extends Fake implements BudgetDto {}

class _FakeBudgetPeriodDto extends Fake implements BudgetPeriodDto {}

void main() {
  late storage.AppDatabase db;
  late _MockApi api;
  late _MockBudgetsApi budgetsApi;
  late _MockEnvelopesApi envelopesApi;
  late BudgetRepository repo;

  setUpAll(() {
    registerFallbackValue(_FakeBudgetDto());
    registerFallbackValue(_FakeBudgetPeriodDto());
  });

  setUp(() {
    db = storage.AppDatabase.forTesting(NativeDatabase.memory());
    api = _MockApi();
    budgetsApi = _MockBudgetsApi();
    envelopesApi = _MockEnvelopesApi();
    when(() => api.budgets).thenReturn(budgetsApi);
    when(() => api.envelopes).thenReturn(envelopesApi);

    var bSeq = 0;
    var pSeq = 0;
    when(() => budgetsApi.createBudget(any())).thenAnswer((inv) async {
      final dto = inv.positionalArguments.first as BudgetDto;
      return dto.copyWith(id: 'b${++bSeq}');
    });
    when(() => budgetsApi.updateBudget(any())).thenAnswer(
      (inv) async => inv.positionalArguments.first as BudgetDto,
    );
    when(() => budgetsApi.createBudgetPeriod(any())).thenAnswer((inv) async {
      final dto = inv.positionalArguments.first as BudgetPeriodDto;
      return dto.copyWith(id: 'p${++pSeq}');
    });
    when(() => budgetsApi.updateBudgetPeriod(any())).thenAnswer(
      (inv) async => inv.positionalArguments.first as BudgetPeriodDto,
    );

    repo = BudgetRepository(apiClient: api, localDatabase: db);
  });

  tearDown(() async => db.close());

  Future<void> seedAccount({
    required String id,
    required String budgetId,
    required int startingBalance,
    bool isOnBudget = true,
    bool isArchived = false,
  }) async {
    await db.accountsDao.insertAccount(
      storage.AccountsCompanion.insert(
        id: id,
        budgetId: budgetId,
        name: id,
        type: 'checking',
        currency: 'USD',
        startingBalance: Value(startingBalance),
        currentBalance: Value(startingBalance),
        isOnBudget: Value(isOnBudget),
        isArchived: Value(isArchived),
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  test(
    'editing an on-budget account starting balance updates '
    'openingBalance and refreshes RTA (#81)',
    () async {
      // Create budget + May period + seed 2 accounts ($1,000 + $500 = $1,500).
      final budget = await repo.createBudget(
        name: 'My Budget',
        baseCurrency: 'USD',
        ownerId: 'owner-1',
        openingBalance: 150000,
        openingDate: DateTime(2026, 5),
      );
      final mayPeriod = await repo.createBudgetPeriod(
        budgetId: budget.id,
        startDate: DateTime(2026, 5),
        endDate: DateTime(2026, 5, 31),
      );
      await seedAccount(
        id: 'a-1',
        budgetId: budget.id,
        startingBalance: 100000,
      );
      await seedAccount(
        id: 'a-2',
        budgetId: budget.id,
        startingBalance: 50000,
      );

      expect(
        await repo.calculateReadyToAssign(mayPeriod.id),
        equals(150000),
      );

      // Edit account a-2 from 50k to 200k. Total seed should be 300k.
      await db.accountsDao.insertAccount(
        storage.AccountsCompanion.insert(
          id: 'a-2',
          budgetId: budget.id,
          name: 'a-2',
          type: 'checking',
          currency: 'USD',
          startingBalance: const Value(200000),
          currentBalance: const Value(200000),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
        mode: InsertMode.insertOrReplace,
      );

      await repo.refreshOpeningBalanceForBudget(budget.id);

      final updated = await repo.getBudget(budget.id);
      expect(updated.openingBalance, equals(300000));
      expect(
        await repo.calculateReadyToAssign(mayPeriod.id),
        equals(300000),
      );
    },
  );

  test(
    'toggling isOnBudget off removes an account from openingBalance (#81)',
    () async {
      final budget = await repo.createBudget(
        name: 'My Budget',
        baseCurrency: 'USD',
        ownerId: 'owner-1',
        openingBalance: 150000,
        openingDate: DateTime(2026, 5),
      );
      final mayPeriod = await repo.createBudgetPeriod(
        budgetId: budget.id,
        startDate: DateTime(2026, 5),
        endDate: DateTime(2026, 5, 31),
      );
      await seedAccount(
        id: 'a-1',
        budgetId: budget.id,
        startingBalance: 100000,
      );
      await seedAccount(
        id: 'a-2',
        budgetId: budget.id,
        startingBalance: 50000,
      );

      // Flip a-1 to off-budget.
      await db.accountsDao.insertAccount(
        storage.AccountsCompanion.insert(
          id: 'a-1',
          budgetId: budget.id,
          name: 'a-1',
          type: 'checking',
          currency: 'USD',
          startingBalance: const Value(100000),
          currentBalance: const Value(100000),
          isOnBudget: const Value(false),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
        mode: InsertMode.insertOrReplace,
      );

      await repo.refreshOpeningBalanceForBudget(budget.id);

      final updated = await repo.getBudget(budget.id);
      expect(updated.openingBalance, equals(50000));
      expect(
        await repo.calculateReadyToAssign(mayPeriod.id),
        equals(50000),
      );
    },
  );

  test(
    'updates openingBalance but leaves periods untouched when openingDate '
    'is null (legacy budget, #81)',
    () async {
      // Legacy budget shape: opening_balance defaults to 0, opening_date
      // null. Phase 7's backfill skips this row, so the cascade fold has no
      // anchor to land on.
      final budget = await repo.createBudget(
        name: 'Legacy',
        baseCurrency: 'USD',
        ownerId: 'owner-1',
      );
      final mayPeriod = await repo.createBudgetPeriod(
        budgetId: budget.id,
        startDate: DateTime(2026, 5),
        endDate: DateTime(2026, 5, 31),
        totalIncome: 100000,
      );
      await seedAccount(
        id: 'a-1',
        budgetId: budget.id,
        startingBalance: 100000,
      );

      final preMayRta = await repo.calculateReadyToAssign(mayPeriod.id);

      await repo.refreshOpeningBalanceForBudget(budget.id);

      final updated = await repo.getBudget(budget.id);
      expect(updated.openingBalance, equals(100000));
      expect(updated.openingDate, isNull);

      // No anchor → RTA in May still reads from totalIncome only.
      // The new openingBalance is recorded but doesn't contribute to RTA
      // until openingDate is set (e.g. via the phase-7 backfill).
      expect(
        await repo.calculateReadyToAssign(mayPeriod.id),
        equals(preMayRta),
      );
      // No cascade ran — May period carriedRta stays at default.
      final mayAfter = await db.budgetsDao.getBudgetPeriod(mayPeriod.id);
      expect(mayAfter?.carriedRta, equals(0));
    },
  );

  test(
    'cascade propagates the new openingBalance through downstream '
    'carriedRta (#81)',
    () async {
      final budget = await repo.createBudget(
        name: 'My Budget',
        baseCurrency: 'USD',
        ownerId: 'owner-1',
        openingBalance: 100000,
        openingDate: DateTime(2026, 5),
      );
      await repo.createBudgetPeriod(
        budgetId: budget.id,
        startDate: DateTime(2026, 5),
        endDate: DateTime(2026, 5, 31),
      );
      // Add June so the cascade has somewhere to propagate to.
      final junePeriod = await repo.createBudgetPeriod(
        budgetId: budget.id,
        startDate: DateTime(2026, 6),
        endDate: DateTime(2026, 6, 30),
        carriedRta: 100000,
      );
      await seedAccount(
        id: 'a-1',
        budgetId: budget.id,
        startingBalance: 100000,
      );

      // Bump account from 100k to 250k.
      await db.accountsDao.insertAccount(
        storage.AccountsCompanion.insert(
          id: 'a-1',
          budgetId: budget.id,
          name: 'a-1',
          type: 'checking',
          currency: 'USD',
          startingBalance: const Value(250000),
          currentBalance: const Value(250000),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
        mode: InsertMode.insertOrReplace,
      );

      await repo.refreshOpeningBalanceForBudget(budget.id);

      // June.carriedRta should now be 250k — the cascade re-ran from May.
      final juneRefreshed = await db.budgetsDao.getBudgetPeriod(junePeriod.id);
      expect(juneRefreshed?.carriedRta, equals(250000));
      expect(
        await repo.calculateReadyToAssign(junePeriod.id),
        equals(250000),
      );
    },
  );
}
