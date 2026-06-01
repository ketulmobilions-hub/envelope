// Integration test for issue #80 phase 7 — data backfill.
//
// Spins up an in-memory Drift database at the current schema, seeds it with
// pre-phase-2 budget rows (seed cash trapped in the earliest period's
// `total_income`), runs `backfillOpeningBalance`, and asserts:
//   - the seed cash moved to `budgets.opening_balance` / `opening_date`
//   - the earliest period's `total_income` is zeroed
//   - per-period RTA (via the real `BudgetRepository`) is unchanged for any
//     existing period (acceptance criterion)
//   - the backfill is idempotent
//   - already-migrated (phase-2) budgets are left alone

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

void main() {
  late storage.AppDatabase db;
  late _MockApi api;
  late _MockBudgetsApi budgetsApi;
  late _MockEnvelopesApi envelopesApi;
  late BudgetRepository repo;

  final now = DateTime(2026);

  setUp(() {
    db = storage.AppDatabase.forTesting(NativeDatabase.memory());
    api = _MockApi();
    budgetsApi = _MockBudgetsApi();
    envelopesApi = _MockEnvelopesApi();
    when(() => api.budgets).thenReturn(budgetsApi);
    when(() => api.envelopes).thenReturn(envelopesApi);
    repo = BudgetRepository(apiClient: api, localDatabase: db);
  });

  tearDown(() async => db.close());

  Future<void> seedPrePhase2Budget({
    required String id,
    required String ownerId,
    required int earliestIncome,
    required DateTime earliestStart,
  }) async {
    await db.budgetsDao.insertBudget(
      storage.BudgetsCompanion.insert(
        id: id,
        ownerId: ownerId,
        name: 'Pre-phase-2 budget',
        baseCurrency: 'USD',
        createdAt: now,
        updatedAt: now,
      ),
      mode: InsertMode.insertOrReplace,
    );
    await db.budgetsDao.insertBudgetPeriod(
      storage.BudgetPeriodsCompanion.insert(
        id: '$id-p1',
        budgetId: id,
        startDate: earliestStart,
        endDate: DateTime(
          earliestStart.year,
          earliestStart.month + 1,
        ).subtract(const Duration(days: 1)),
        totalIncome: Value(earliestIncome),
        createdAt: now,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  test(
    'backfill moves seed cash off earliest period.totalIncome onto the '
    'budget row (#80, phase 7)',
    () async {
      await seedPrePhase2Budget(
        id: 'budget-1',
        ownerId: 'owner-1',
        earliestIncome: 100000,
        earliestStart: DateTime(2026, 5),
      );

      // Pre-backfill RTA — verify the seed currently lives on totalIncome.
      final preRta = await repo.calculateReadyToAssign('budget-1-p1');
      expect(preRta, equals(100000));

      await storage.backfillOpeningBalance(db);

      final budget = await db.budgetsDao.getBudget('budget-1');
      expect(budget?.openingBalance, equals(100000));
      expect(budget?.openingDate, equals(DateTime(2026, 5)));

      final period = await db.budgetsDao.getBudgetPeriod('budget-1-p1');
      expect(period?.totalIncome, equals(0));

      // Acceptance: RTA must be unchanged for any existing period.
      final postRta = await repo.calculateReadyToAssign('budget-1-p1');
      expect(
        postRta,
        equals(preRta),
        reason: 'RTA is invariant under the totalIncome → openingBalance swap.',
      );
    },
  );

  test(
    'backfill leaves already-migrated (phase-2) budgets alone (#80, phase 7)',
    () async {
      // Phase-2 onboarding always sets opening_date for budgets with non-zero
      // seed cash. This budget already has a 250k anchor; backfill must not
      // touch it even if the earliest period coincidentally has totalIncome.
      await db.budgetsDao.insertBudget(
        storage.BudgetsCompanion.insert(
          id: 'budget-2',
          ownerId: 'owner-1',
          name: 'Phase-2 budget',
          baseCurrency: 'USD',
          openingBalance: const Value(250000),
          openingDate: Value<DateTime?>(DateTime(2026, 6)),
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );
      await db.budgetsDao.insertBudgetPeriod(
        storage.BudgetPeriodsCompanion.insert(
          id: 'budget-2-p1',
          budgetId: 'budget-2',
          startDate: DateTime(2026, 6),
          endDate: DateTime(2026, 6, 30),
          // Phase-2 leaves this at 0, but seed something to prove the gate
          // catches it on `opening_date IS NOT NULL`.
          totalIncome: const Value(5000),
          createdAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );

      await storage.backfillOpeningBalance(db);

      final budget = await db.budgetsDao.getBudget('budget-2');
      expect(budget?.openingBalance, equals(250000));
      expect(budget?.openingDate, equals(DateTime(2026, 6)));

      final period = await db.budgetsDao.getBudgetPeriod('budget-2-p1');
      expect(
        period?.totalIncome,
        equals(5000),
        reason: 'Phase-2 budget income must NOT be zeroed.',
      );
    },
  );

  test(
    'backfill is idempotent — re-running leaves migrated budgets unchanged',
    () async {
      await seedPrePhase2Budget(
        id: 'budget-3',
        ownerId: 'owner-1',
        earliestIncome: 75000,
        earliestStart: DateTime(2026, 3),
      );

      await storage.backfillOpeningBalance(db);
      final after1 = await db.budgetsDao.getBudget('budget-3');
      final period1 = await db.budgetsDao.getBudgetPeriod('budget-3-p1');

      await storage.backfillOpeningBalance(db);
      final after2 = await db.budgetsDao.getBudget('budget-3');
      final period2 = await db.budgetsDao.getBudgetPeriod('budget-3-p1');

      expect(after2?.openingBalance, equals(after1?.openingBalance));
      expect(after2?.openingDate, equals(after1?.openingDate));
      expect(period2?.totalIncome, equals(period1?.totalIncome));
      expect(after2?.openingBalance, equals(75000));
    },
  );

  test(
    'mixed batch: migrates pre-phase-2 budget AND leaves phase-2 budget '
    'untouched in a single call (#80, phase 7)',
    () async {
      // Pre-phase-2 row.
      await seedPrePhase2Budget(
        id: 'mix-pre',
        ownerId: 'owner-1',
        earliestIncome: 80000,
        earliestStart: DateTime(2026, 4),
      );
      // Phase-2 row.
      await db.budgetsDao.insertBudget(
        storage.BudgetsCompanion.insert(
          id: 'mix-phase2',
          ownerId: 'owner-1',
          name: 'Phase-2',
          baseCurrency: 'USD',
          openingBalance: const Value(120000),
          openingDate: Value<DateTime?>(DateTime(2026, 5)),
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );
      await db.budgetsDao.insertBudgetPeriod(
        storage.BudgetPeriodsCompanion.insert(
          id: 'mix-phase2-p1',
          budgetId: 'mix-phase2',
          startDate: DateTime(2026, 5),
          endDate: DateTime(2026, 5, 31),
          createdAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );

      await storage.backfillOpeningBalance(db);

      final pre = await db.budgetsDao.getBudget('mix-pre');
      expect(pre?.openingBalance, equals(80000));
      expect(pre?.openingDate, equals(DateTime(2026, 4)));

      final phase2 = await db.budgetsDao.getBudget('mix-phase2');
      expect(phase2?.openingBalance, equals(120000));
      expect(phase2?.openingDate, equals(DateTime(2026, 5)));
    },
  );

  test(
    'corrupted state: openingBalance > 0 but openingDate IS NULL is left '
    'alone (#80, phase 7)',
    () async {
      // This shouldn't happen in production, but pins the gate behavior so
      // a future relaxation of the WHERE clause is caught by tests.
      await db.budgetsDao.insertBudget(
        storage.BudgetsCompanion.insert(
          id: 'corrupt-1',
          ownerId: 'owner-1',
          name: 'Corrupted',
          baseCurrency: 'USD',
          openingBalance: const Value(50000),
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );
      await db.budgetsDao.insertBudgetPeriod(
        storage.BudgetPeriodsCompanion.insert(
          id: 'corrupt-1-p1',
          budgetId: 'corrupt-1',
          startDate: DateTime(2026, 5),
          endDate: DateTime(2026, 5, 31),
          totalIncome: const Value(90000),
          createdAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );

      await storage.backfillOpeningBalance(db);

      // Gate (`opening_balance = 0`) fails → row is left as-is.
      final budget = await db.budgetsDao.getBudget('corrupt-1');
      expect(budget?.openingBalance, equals(50000));
      expect(budget?.openingDate, isNull);
      final period = await db.budgetsDao.getBudgetPeriod('corrupt-1-p1');
      expect(period?.totalIncome, equals(90000));
    },
  );

  test(
    'backfill skips budgets whose earliest period has zero totalIncome '
    '(legacy budget with no seed cash to move)',
    () async {
      await db.budgetsDao.insertBudget(
        storage.BudgetsCompanion.insert(
          id: 'budget-4',
          ownerId: 'owner-1',
          name: 'Zero-income budget',
          baseCurrency: 'USD',
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );
      await db.budgetsDao.insertBudgetPeriod(
        storage.BudgetPeriodsCompanion.insert(
          id: 'budget-4-p1',
          budgetId: 'budget-4',
          startDate: DateTime(2026, 7),
          endDate: DateTime(2026, 7, 31),
          createdAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );

      await storage.backfillOpeningBalance(db);

      final budget = await db.budgetsDao.getBudget('budget-4');
      expect(budget?.openingBalance, equals(0));
      expect(budget?.openingDate, isNull);
    },
  );

  test(
    "multi-period chain: subsequent periods' carriedRta unchanged after "
    'backfill (#80, phase 7 invariant)',
    () async {
      // Pre-phase-2 chain: May (earliest, seed=100k) → June (carriedRta=100k).
      await db.budgetsDao.insertBudget(
        storage.BudgetsCompanion.insert(
          id: 'budget-5',
          ownerId: 'owner-1',
          name: 'Chain',
          baseCurrency: 'USD',
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );
      await db.budgetsDao.insertBudgetPeriod(
        storage.BudgetPeriodsCompanion.insert(
          id: 'b5-may',
          budgetId: 'budget-5',
          startDate: DateTime(2026, 5),
          endDate: DateTime(2026, 5, 31),
          totalIncome: const Value(100000),
          createdAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );
      await db.budgetsDao.insertBudgetPeriod(
        storage.BudgetPeriodsCompanion.insert(
          id: 'b5-jun',
          budgetId: 'budget-5',
          startDate: DateTime(2026, 6),
          endDate: DateTime(2026, 6, 30),
          carriedRta: const Value(100000),
          createdAt: now,
        ),
        mode: InsertMode.insertOrReplace,
      );

      final preMayRta = await repo.calculateReadyToAssign('b5-may');
      final preJunRta = await repo.calculateReadyToAssign('b5-jun');
      // Sanity-anchor the absolute values so a same-on-both-sides regression
      // (e.g. RTA computing to 0 both before and after) doesn't slip through.
      expect(preMayRta, equals(100000));
      expect(preJunRta, equals(100000));

      await storage.backfillOpeningBalance(db);

      // RTA must be identical before/after for both periods — the cascade is
      // invariant: signedPrev(may) = income+carried-allocated → seed+0-0 =
      // 100k pre-mig, AND 0+seed+0-0 = 100k post-mig. June.carriedRta does
      // not need recomputing.
      expect(
        await repo.calculateReadyToAssign('b5-may'),
        equals(preMayRta),
      );
      expect(
        await repo.calculateReadyToAssign('b5-jun'),
        equals(preJunRta),
      );

      // And June.carriedRta itself untouched.
      final jun = await db.budgetsDao.getBudgetPeriod('b5-jun');
      expect(jun?.carriedRta, equals(100000));
    },
  );
}
