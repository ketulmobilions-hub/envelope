// Integration test for issue #80 phase 6 — the canonical "April scenario".
//
// Wires the real `BudgetRepository` against an in-memory Drift database and a
// mocked `EnvelopeApiClient`. The API mocks assign sequential ids (mimicking
// the server) and echo back updates. End-to-end coverage that the seed-cash
// anchor shifts and the carry-forward cascade re-runs when a back-dated
// transaction forces a new earliest period — including the overspend-penalty
// branch and the multi-step anchor shift.
//
// Placement: lives in the main app's `test/integration/` rather than under
// `packages/budget_repository/test/` because the latter is a pure-Dart
// package without sqlite3 binaries at test time. The main app's flutter_test
// pulls `sqlite3_flutter_libs` via `envelope_local_storage`, so
// `NativeDatabase.memory()` works here without an extra dependency.

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

class _FakeEnvelopeAllocationDto extends Fake
    implements EnvelopeAllocationDto {}

void main() {
  late storage.AppDatabase db;
  late _MockApi api;
  late _MockBudgetsApi budgetsApi;
  late _MockEnvelopesApi envelopesApi;
  late BudgetRepository repo;

  setUpAll(() {
    registerFallbackValue(_FakeBudgetDto());
    registerFallbackValue(_FakeBudgetPeriodDto());
    registerFallbackValue(_FakeEnvelopeAllocationDto());
  });

  setUp(() {
    db = storage.AppDatabase.forTesting(NativeDatabase.memory());
    api = _MockApi();
    budgetsApi = _MockBudgetsApi();
    envelopesApi = _MockEnvelopesApi();
    when(() => api.budgets).thenReturn(budgetsApi);
    when(() => api.envelopes).thenReturn(envelopesApi);

    // Sequential id assignment (mimics the server). Budgets get "b1, b2…",
    // periods "p1, p2…", allocations "a1, a2…".
    var bSeq = 0;
    var pSeq = 0;
    var aSeq = 0;
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
    when(() => envelopesApi.createEnvelopeAllocation(any())).thenAnswer((
      inv,
    ) async {
      final dto = inv.positionalArguments.first as EnvelopeAllocationDto;
      return dto.copyWith(id: 'a${++aSeq}');
    });

    repo = BudgetRepository(apiClient: api, localDatabase: db);
  });

  tearDown(() async => db.close());

  test(
    'April scenario: backdated transaction shifts openingDate, '
    'cascade carries opening balance forward (#80)',
    () async {
      final budget = await repo.createBudget(
        name: 'My Budget',
        baseCurrency: 'USD',
        ownerId: 'owner-1',
        openingBalance: 100000,
        openingDate: DateTime(2026, 5),
      );
      final mayPeriod = await repo.createBudgetPeriod(
        budgetId: budget.id,
        startDate: DateTime(2026, 5),
        endDate: DateTime(2026, 5, 31),
      );

      // Sanity: May RTA = openingBalance, no allocations.
      expect(
        await repo.calculateReadyToAssign(mayPeriod.id),
        equals(100000),
        reason: 'Pre-backfill, May contains the opening anchor.',
      );

      // Backdated expense dated April 15 forces an April period.
      final aprPeriodId = await repo.ensurePeriodForDate(
        budgetId: budget.id,
        date: DateTime(2026, 4, 15),
      );

      expect(aprPeriodId, isNotNull);

      // Anchor must have shifted to the new earliest period (April 1).
      final shifted = await repo.getBudget(budget.id);
      expect(shifted.openingDate, equals(DateTime(2026, 4)));
      expect(shifted.openingBalance, equals(100000));

      // April RTA = 100,000 (period contains the shifted anchor, no
      // allocations yet → the back-dated expense can be covered).
      expect(
        await repo.calculateReadyToAssign(aprPeriodId!),
        equals(100000),
      );

      // May carriedRta must now equal 100,000: signedPrev(April) = 0 +
      // 100,000 + 0 − 0 = 100,000.
      final periods = await db.budgetsDao.getPeriodsByBudgetId(budget.id);
      final mayAfter = periods.firstWhere((p) => p.id == mayPeriod.id);
      expect(mayAfter.carriedRta, equals(100000));

      // May RTA should be unchanged at 100,000 — the seed cash is now
      // carried forward via `carriedRta` instead of being folded in here.
      expect(
        await repo.calculateReadyToAssign(mayPeriod.id),
        equals(100000),
        reason: 'No double-counting: opening contribution lands in April only.',
      );
    },
  );

  test(
    'April overspend deducts uncovered cash penalty from May carriedRta (#80)',
    () async {
      final budget = await repo.createBudget(
        name: 'My Budget',
        baseCurrency: 'USD',
        ownerId: 'owner-1',
        openingBalance: 100000,
        openingDate: DateTime(2026, 5),
      );
      final mayPeriod = await repo.createBudgetPeriod(
        budgetId: budget.id,
        startDate: DateTime(2026, 5),
        endDate: DateTime(2026, 5, 31),
      );

      // Back-fill April (shifts anchor to April 1).
      final aprPeriodId = await repo.ensurePeriodForDate(
        budgetId: budget.id,
        date: DateTime(2026, 4, 15),
      );

      // Seed an envelope + category group directly via Drift so we can write
      // an April allocation that overspends its envelope. The repo only
      // touches `envelope_allocations`; the table-level FKs require an
      // envelope row to satisfy `envelope_id`.
      await db.envelopesDao.insertCategoryGroup(
        storage.CategoryGroupsCompanion.insert(
          id: 'cg-1',
          budgetId: budget.id,
          name: 'Bills',
          createdAt: DateTime(2026),
        ),
      );
      await db.envelopesDao.insertEnvelope(
        storage.EnvelopesCompanion.insert(
          id: 'env-1',
          categoryGroupId: 'cg-1',
          budgetId: budget.id,
          name: 'Rent',
          createdAt: DateTime(2026),
        ),
      );
      await db.envelopesDao.insertAllocation(
        storage.EnvelopeAllocationsCompanion.insert(
          id: 'alloc-1',
          envelopeId: 'env-1',
          budgetPeriodId: aprPeriodId!,
          allocatedAmount: const Value(30000),
          spentAmount: const Value(50000), // overspent by 20,000
          createdAt: DateTime(2026, 4, 20),
        ),
        mode: InsertMode.insertOrReplace,
      );

      // Re-run the cascade so the overspend penalty propagates into May.
      // (In production this fires automatically when the back-fill writes
      // happen alongside transaction recording; tests have to call it.)
      await repo.recomputeCarryForwardFrom(
        budgetId: budget.id,
        fromPeriodId: aprPeriodId,
      );

      // April RTA = 0 + 100,000 + 0 − 30,000 = 70,000.
      expect(
        await repo.calculateReadyToAssign(aprPeriodId),
        equals(70000),
      );

      // May carriedRta = signedPrev(April) − uncoveredOverspend
      //                = 70,000 − 20,000 = 50,000.
      final periods = await db.budgetsDao.getPeriodsByBudgetId(budget.id);
      final mayAfter = periods.firstWhere((p) => p.id == mayPeriod.id);
      expect(
        mayAfter.carriedRta,
        equals(50000),
        reason: 'Overspend in the anchor period drains carriedRta.',
      );
      expect(
        await repo.calculateReadyToAssign(mayPeriod.id),
        equals(50000),
      );
    },
  );

  test(
    'multi-month back-fill walks the anchor through each step (#80)',
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

      // Walk back one period at a time, asserting the anchor shifts on each
      // step. A regression that only shifted on the first backward step
      // would be caught here, whereas calling `ensurePeriodForDate` in one
      // jump only sees the final state.
      await repo.autoCreatePreviousPeriod(budget.id);
      expect(
        (await repo.getBudget(budget.id)).openingDate,
        equals(DateTime(2026, 4)),
        reason: 'After back-filling April, anchor sits on April 1.',
      );

      await repo.autoCreatePreviousPeriod(budget.id);
      expect(
        (await repo.getBudget(budget.id)).openingDate,
        equals(DateTime(2026, 3)),
      );

      await repo.autoCreatePreviousPeriod(budget.id);
      expect(
        (await repo.getBudget(budget.id)).openingDate,
        equals(DateTime(2026, 2)),
      );

      // Periods chain: Feb, Mar, Apr, May. Each later period carries 100k
      // forward because no income / allocations exist in the chain.
      final periods = await db.budgetsDao.getPeriodsByBudgetId(budget.id);
      expect(periods, hasLength(4));
      final byStart = [...periods]
        ..sort((a, b) => a.startDate.compareTo(b.startDate));
      expect(byStart.first.startDate, equals(DateTime(2026, 2)));
      for (final p in byStart.skip(1)) {
        expect(p.carriedRta, equals(100000));
      }
    },
  );

  test(
    'cascade reads recomputed carriedRta (not stale snapshot) when income '
    'in a middle period differentiates each step (#80, phase-3 cascade fix)',
    () async {
      // Three-period chain (Feb / Mar / Apr) with income added to March so
      // each period's `carriedRta` is a different value. If the cascade
      // read the snapshot `carriedRta` instead of the just-recomputed value
      // (pre-phase-3 bug), April would see Mar's stale 0 instead of the
      // computed 150k.
      final budget = await repo.createBudget(
        name: 'My Budget',
        baseCurrency: 'USD',
        ownerId: 'owner-1',
        openingBalance: 100000,
        openingDate: DateTime(2026, 4),
      );
      final aprPeriod = await repo.createBudgetPeriod(
        budgetId: budget.id,
        startDate: DateTime(2026, 4),
        endDate: DateTime(2026, 4, 30),
      );

      // Back-fill March then February. After each step the anchor shifts.
      await repo.autoCreatePreviousPeriod(budget.id); // → Mar
      await repo.autoCreatePreviousPeriod(budget.id); // → Feb

      // Anchor now Feb 1. Add 50k income to March. Then re-run the cascade
      // from Feb so the new March income propagates forward.
      var periods = await db.budgetsDao.getPeriodsByBudgetId(budget.id);
      periods = [...periods]
        ..sort((a, b) => a.startDate.compareTo(b.startDate));
      final marPeriod = periods[1];
      await repo.updateBudgetPeriod(
        BudgetPeriod(
          id: marPeriod.id,
          budgetId: marPeriod.budgetId,
          startDate: marPeriod.startDate,
          endDate: marPeriod.endDate,
          totalIncome: 50000,
          createdAt: marPeriod.createdAt,
        ),
      );
      await repo.recomputeCarryForwardFrom(
        budgetId: budget.id,
        fromPeriodId: periods.first.id, // Feb
      );

      // Mar carriedRta = signedPrev(Feb) = 0 + 100,000 + 0 - 0 = 100,000.
      // Apr carriedRta = signedPrev(Mar) = 50,000 + 0 + 100,000 - 0
      //                                  = 150,000.
      final after = await db.budgetsDao.getPeriodsByBudgetId(budget.id);
      final marAfter = after.firstWhere((p) => p.id == marPeriod.id);
      final aprAfter = after.firstWhere((p) => p.id == aprPeriod.id);
      expect(marAfter.carriedRta, equals(100000));
      expect(
        aprAfter.carriedRta,
        equals(150000),
        reason:
            'Apr carriedRta must read the JUST-recomputed Mar carriedRta, '
            'not the stale snapshot (pre-phase-3 bug).',
      );
    },
  );
}
