import 'dart:async';
import 'dart:math' show min;

import 'package:budget_repository/budget_repository.dart';
import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for budget operations.
///
/// Uses a remote-first strategy: writes go to the Supabase API first,
/// then sync the result to the local Drift database. Reads stream from
/// local storage for reactive UI updates.
class BudgetRepository {
  /// Creates a [BudgetRepository].
  ///
  /// An optional [supabaseClient] can be provided for Realtime
  /// subscriptions via [subscribeToBudgetChanges] and
  /// [subscribeToPeriodChanges].
  BudgetRepository({
    required EnvelopeApiClient apiClient,
    required storage.AppDatabase localDatabase,
    SupabaseClient? supabaseClient,
  }) : _apiClient = apiClient,
       _localDatabase = localDatabase,
       _supabaseClient = supabaseClient;

  final EnvelopeApiClient _apiClient;
  final storage.AppDatabase _localDatabase;
  final SupabaseClient? _supabaseClient;

  final StreamController<void> _remoteChangeController =
      StreamController<void>.broadcast();

  /// Emits when a remote collaborator's change is received via Realtime.
  Stream<void> get onRemoteChange => _remoteChangeController.stream;

  int _localWriteCount = 0;

  // ---------------------------------------------------------------------------
  // Budget CRUD
  // ---------------------------------------------------------------------------

  /// Creates a new budget.
  ///
  /// [openingBalance] (cents) is the period-agnostic seed cash anchored on
  /// [openingDate]. The seed is added to "Ready to Assign" in whichever
  /// period contains [openingDate] and propagates forward via `carriedRta`.
  Future<Budget> createBudget({
    required String name,
    required String baseCurrency,
    required String ownerId,
    String periodType = 'monthly',
    int periodStartDay = 1,
    int openingBalance = 0,
    DateTime? openingDate,
  }) async {
    _beginLocalWrite();
    try {
      final dto = BudgetDto(
        id: '',
        ownerId: ownerId,
        name: name,
        baseCurrency: baseCurrency,
        periodType: periodType,
        periodStartDay: periodStartDay,
        openingBalance: openingBalance,
        openingDate: openingDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await _apiClient.budgets.createBudget(dto);
      await _cacheBudget(created);
      _endLocalWrite();
      return _mapBudgetFromDto(created);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw BudgetException('Failed to create budget', error: e);
    }
  }

  /// Gets a budget by its [id].
  ///
  /// Tries local storage first, falls back to the API.
  Future<Budget> getBudget(String id) async {
    try {
      final local = await _localDatabase.budgetsDao.getBudget(id);
      if (local != null) {
        return _mapBudgetFromLocal(local);
      }

      final remote = await _apiClient.budgets.getBudget(id);
      await _cacheBudget(remote);
      return _mapBudgetFromDto(remote);
    } on EnvelopeApiException catch (e) {
      throw BudgetException('Failed to get budget', error: e);
    }
  }

  /// Watches a single budget by [budgetId].
  ///
  /// Returns a reactive stream from local storage that re-emits whenever the
  /// row changes (e.g. an `openingBalance` / `openingDate` shift from
  /// [autoCreatePreviousPeriod] or a Realtime cache write). Consumers use
  /// this to refresh derived values (e.g. RTA) without forcing a full reload.
  Stream<Budget> watchBudget(String budgetId) {
    return _localDatabase.budgetsDao
        .watchBudget(budgetId)
        .map(_mapBudgetFromLocal)
        .handleError(
          (Object error) =>
              throw BudgetException('Failed to watch budget', error: error),
        );
  }

  /// Watches all budgets for the given [ownerId].
  ///
  /// Returns a reactive stream from local storage filtered by owner.
  Stream<List<Budget>> watchBudgets(String ownerId) {
    return _localDatabase.budgetsDao
        .watchBudgetsByOwnerId(ownerId)
        .map(
          (rows) => rows.map(_mapBudgetFromLocal).toList(),
        )
        .handleError(
          (Object error) => throw BudgetException(
            'Failed to watch budgets',
            error: error,
          ),
        );
  }

  /// Updates a [budget].
  ///
  /// Sends the update to the API and syncs locally.
  Future<void> updateBudget(Budget budget) async {
    _beginLocalWrite();
    try {
      final dto = _mapBudgetToDto(budget);
      final updated = await _apiClient.budgets.updateBudget(dto);
      await _cacheBudget(updated);
      _endLocalWrite();
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw BudgetException('Failed to update budget', error: e);
    }
  }

  /// Deletes a budget by its [id].
  ///
  /// Removes from the API first. Local cache removal is best-effort.
  Future<void> deleteBudget(String id) async {
    _beginLocalWrite();
    try {
      await _apiClient.budgets.deleteBudget(id);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw BudgetException('Failed to delete budget', error: e);
    }
    try {
      await _localDatabase.budgetsDao.deleteBudget(id);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
    _endLocalWrite();
  }

  /// Archives a budget by its [id].
  ///
  /// Sets `isArchived` to `true`, preserving all data.
  Future<void> archiveBudget(String id) async {
    try {
      final budget = await getBudget(id);
      final archived = budget.copyWith(
        isArchived: true,
        updatedAt: DateTime.now(),
      );
      await updateBudget(archived);
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException('Failed to archive budget', error: e);
    }
  }

  /// Per-budget serialization queue for [refreshOpeningBalanceForBudget].
  /// Prevents lost-update races when account edits arrive concurrently from
  /// multiple cubits (e.g. account form + archive bloc at the same time):
  /// each call waits for the prior one on the same budget to finish before
  /// it reads accounts + budget. Same-budget refreshes serialize; different
  /// budgets remain parallel.
  final Map<String, Future<void>> _openingBalanceRefreshQueue = {};

  /// Recomputes `Budget.openingBalance` from the current set of on-budget,
  /// non-archived accounts and triggers a carry-forward cascade so the change
  /// propagates through `carriedRta` (issue #81).
  ///
  /// Sum rule mirrors onboarding (see `OnboardingCubit.completeOnboarding`):
  /// each on-budget account contributes its `startingBalance` clamped at zero
  /// (negative starting balances do NOT count as seed cash — they're
  /// pre-existing debt the user must clear).
  ///
  /// Only `startingBalance` changes affect the seed cash — `currentBalance`
  /// edits (e.g. `AccountRepository.reconcileAccount`) do NOT require this
  /// refresh because the seed is anchored to onboarding-time balances.
  ///
  /// `openingDate` is preserved. If it is `null` (legacy budget never
  /// onboarded with seed cash) the function still updates `openingBalance`
  /// but skips the cascade — phase 3 RTA logic requires an anchor date to
  /// fold the contribution in. Archived accounts are intentionally ignored:
  /// they may have contributed at onboarding but should not change
  /// `openingBalance` post-archive (product decision deferred from #80; see
  /// PR comments on #81 for context).
  ///
  // TODO(#80-fx): FX-convert per-account `startingBalance` to base currency
  // before summing. Currently sums native cents to match onboarding; under-
  // or over-counts when accounts use different currencies. Same gap exists
  // in `OnboardingCubit`; fix both together.
  Future<void> refreshOpeningBalanceForBudget(String budgetId) async {
    final prior = _openingBalanceRefreshQueue[budgetId];
    final completer = Completer<void>();
    _openingBalanceRefreshQueue[budgetId] = completer.future;
    if (prior != null) {
      try {
        await prior;
      } on Object {
        // Prior caller's error is theirs to handle; we still proceed so
        // a transient failure doesn't permanently block this budget.
      }
    }
    try {
      await _doRefreshOpeningBalance(budgetId);
      completer.complete();
    } on Object catch (e, st) {
      completer.completeError(e, st);
      rethrow;
    } finally {
      if (identical(_openingBalanceRefreshQueue[budgetId], completer.future)) {
        _openingBalanceRefreshQueue.remove(budgetId);
      }
    }
  }

  Future<void> _doRefreshOpeningBalance(String budgetId) async {
    try {
      final budget = await getBudget(budgetId);
      final accounts = await _localDatabase.accountsDao
          .getAccountsByBudgetId(budgetId);

      var sum = 0;
      for (final a in accounts) {
        if (!a.isOnBudget || a.isArchived) continue;
        if (a.startingBalance > 0) sum += a.startingBalance;
      }
      if (sum == budget.openingBalance) return;

      await updateBudget(
        budget.copyWith(openingBalance: sum, updatedAt: DateTime.now()),
      );

      final openingDate = budget.openingDate;
      if (openingDate == null) {
        // Legacy budget shape (phase-7 backfill skipped this row because its
        // earliest period had no income, or this is a never-onboarded
        // budget). `openingBalance` is recorded for downstream visibility
        // but the cascade has no anchor period to fold it into — RTA stays
        // on the old `total_income` model until `openingDate` is set.
        return;
      }

      // Recompute cascade starting from the period that anchors the seed
      // cash — that's the period whose RTA picks up the new contribution
      // first. Downstream periods read its updated `carriedRta`.
      final periods = await _localDatabase.budgetsDao.getPeriodsByBudgetId(
        budgetId,
      );
      if (periods.isEmpty) return;
      final anchor = periodForDate<storage.BudgetPeriod>(
        openingDate,
        periods,
        startDate: (p) => p.startDate,
        endDate: (p) => p.endDate,
      );
      if (anchor == null) return;

      await recomputeCarryForwardFrom(
        budgetId: budgetId,
        fromPeriodId: anchor.id,
      );
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException(
        'Failed to refresh opening balance',
        error: e,
      );
    }
  }

  /// Fetches budgets from the API and syncs to local storage.
  Future<void> refreshBudgets(String ownerId) async {
    try {
      final remote = await _apiClient.budgets.getBudgetsByOwner(ownerId);
      final companions = remote.map(_toBudgetCompanion).toList();
      await _localDatabase.budgetsDao.batchInsertBudgets(
        companions,
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw BudgetException('Failed to refresh budgets', error: e);
    }
  }

  // ---------------------------------------------------------------------------
  // Budget Periods
  // ---------------------------------------------------------------------------

  /// Creates a new budget period.
  Future<BudgetPeriod> createBudgetPeriod({
    required String budgetId,
    required DateTime startDate,
    required DateTime endDate,
    int totalIncome = 0,
    int carriedRta = 0,
  }) async {
    try {
      final dto = BudgetPeriodDto(
        id: '',
        budgetId: budgetId,
        startDate: startDate,
        endDate: endDate,
        totalIncome: totalIncome,
        carriedRta: carriedRta,
        createdAt: DateTime.now(),
      );

      final created = await _apiClient.budgets.createBudgetPeriod(dto);
      await _cacheBudgetPeriod(created);
      return _mapBudgetPeriodFromDto(created);
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to create budget period',
        error: e,
      );
    }
  }

  /// Updates an existing budget period.
  ///
  /// Sends the update to the API and syncs locally.
  Future<void> updateBudgetPeriod(BudgetPeriod period) async {
    _beginLocalWrite();
    try {
      final dto = BudgetPeriodDto(
        id: period.id,
        budgetId: period.budgetId,
        startDate: period.startDate,
        endDate: period.endDate,
        totalIncome: period.totalIncome,
        totalAllocated: period.totalAllocated,
        carriedRta: period.carriedRta,
        isClosed: period.isClosed,
        createdAt: period.createdAt,
      );
      final updated = await _apiClient.budgets.updateBudgetPeriod(dto);
      await _cacheBudgetPeriod(updated);
      _endLocalWrite();
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw BudgetException(
        'Failed to update budget period',
        error: e,
      );
    }
  }

  /// Adds income to the current (latest) budget period.
  ///
  /// Finds the most recent period by start date, increments its
  /// `totalIncome` by [amount], and persists via the API + local cache.
  ///
  /// [amount] must be expressed in the budget's base currency (i.e.
  /// `transaction.amount * transaction.exchangeRate`) so `totalIncome` and the
  /// derived RTA stay denominated in a single currency.
  Future<void> addIncomeToCurrentPeriod({
    required String budgetId,
    required int amount,
  }) async {
    try {
      final periods = await _localDatabase.budgetsDao.getPeriodsByBudgetId(
        budgetId,
      );
      if (periods.isEmpty) return;

      final current = periods.reduce(
        (a, b) => a.startDate.isAfter(b.startDate) ? a : b,
      );

      final updatedPeriod = _mapBudgetPeriodFromLocal(current).copyWith(
        totalIncome: current.totalIncome + amount,
      );

      await updateBudgetPeriod(updatedPeriod);
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException(
        'Failed to add income to current period',
        error: e,
      );
    }
  }

  /// Returns the period in [periods] whose `[startDate, endDate]` window
  /// contains [date], or `null` when [date] falls outside every period.
  ///
  /// Pure helper — no I/O. Used by both [addIncomeToPeriod] /
  /// [removeIncomeFromPeriod] (against local storage rows) and by the UI
  /// (against `BudgetPeriod` domain models) to bucket past-dated income or
  /// transactions into the period they belong to.
  ///
  /// When two periods overlap (should never happen in valid data, but is
  /// possible mid-migration), the latest-starting match wins — it's almost
  /// always the more recently created period.
  static T? periodForDate<T>(
    DateTime date,
    Iterable<T> periods, {
    required DateTime Function(T) startDate,
    required DateTime Function(T) endDate,
  }) {
    T? best;
    for (final p in periods) {
      if (!startDate(p).isAfter(date) && !endDate(p).isBefore(date)) {
        if (best == null || startDate(p).isAfter(startDate(best))) {
          best = p;
        }
      }
    }
    return best;
  }

  /// Increments `totalIncome` on the budget period that contains [date].
  ///
  /// Symmetric counterpart to [removeIncomeFromPeriod]. Use this when undoing
  /// a delete of a past-dated income transaction so the original period is
  /// restored, instead of mistakenly bumping the latest period as
  /// [addIncomeToCurrentPeriod] would.
  ///
  /// [amount] must be expressed in the budget's base currency.
  Future<void> addIncomeToPeriod({
    required String budgetId,
    required DateTime date,
    required int amount,
  }) async {
    try {
      final periods = await _localDatabase.budgetsDao.getPeriodsByBudgetId(
        budgetId,
      );
      final period = periodForDate<storage.BudgetPeriod>(
        date,
        periods,
        startDate: (p) => p.startDate,
        endDate: (p) => p.endDate,
      );
      if (period == null) return;

      final updatedPeriod = _mapBudgetPeriodFromLocal(period).copyWith(
        totalIncome: period.totalIncome + amount,
      );
      await updateBudgetPeriod(updatedPeriod);
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException('Failed to add income to period', error: e);
    }
  }

  /// Decrements `totalIncome` on the budget period that contains [date].
  Future<void> removeIncomeFromPeriod({
    required String budgetId,
    required DateTime date,
    required int amount,
  }) async {
    try {
      final periods = await _localDatabase.budgetsDao.getPeriodsByBudgetId(
        budgetId,
      );
      final period = periodForDate<storage.BudgetPeriod>(
        date,
        periods,
        startDate: (p) => p.startDate,
        endDate: (p) => p.endDate,
      );
      if (period == null) return;

      final updatedPeriod = _mapBudgetPeriodFromLocal(period).copyWith(
        totalIncome: (period.totalIncome - amount).clamp(
          0,
          double.maxFinite.toInt(),
        ),
      );
      await updateBudgetPeriod(updatedPeriod);
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException('Failed to remove income from period', error: e);
    }
  }

  /// Watches all budget periods for a [budgetId].
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<BudgetPeriod>> watchBudgetPeriods(String budgetId) {
    return _localDatabase.budgetsDao
        .watchPeriodsByBudgetId(budgetId)
        .map(
          (rows) => rows.map(_mapBudgetPeriodFromLocal).toList(),
        )
        .handleError(
          (Object error) => throw BudgetException(
            'Failed to watch budget periods',
            error: error,
          ),
        );
  }

  /// Closes a budget period by its [id].
  Future<void> closeBudgetPeriod(String id) async {
    try {
      final closed = await _apiClient.budgets.closeBudgetPeriod(id);
      await _cacheBudgetPeriod(closed);
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to close budget period',
        error: e,
      );
    }
  }

  /// Fetches budget periods from the API and syncs to local storage.
  Future<void> refreshBudgetPeriods(String budgetId) async {
    try {
      final remote = await _apiClient.budgets.getBudgetPeriods(budgetId);
      final companions = remote.map(_toBudgetPeriodCompanion).toList();
      await _localDatabase.budgetsDao.batchInsertBudgetPeriods(
        companions,
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to refresh budget periods',
        error: e,
      );
    }
  }

  /// Automatically creates the next budget period based on the budget
  /// configuration and the latest existing period.
  Future<BudgetPeriod> autoCreateNextPeriod(String budgetId) async {
    try {
      final budget = await getBudget(budgetId);
      final periods = await _localDatabase.budgetsDao.getPeriodsByBudgetId(
        budgetId,
      );

      DateTime startDate;
      DateTime endDate;

      if (periods.isEmpty) {
        // First period — use current month/week aligned to periodStartDay,
        // clamped to the last valid day of the month.
        final now = DateTime.now();
        startDate = _clampedDate(
          now.year,
          now.month,
          budget.periodStartDay,
        );
        if (startDate.isAfter(now)) {
          // Move back one period if start day hasn't occurred yet.
          startDate = _subtractPeriod(startDate, budget.periodType);
        }
      } else {
        // Sort by endDate descending and pick the latest period.
        periods.sort(
          (a, b) => b.endDate.compareTo(a.endDate),
        );
        startDate = periods.first.endDate.add(const Duration(days: 1));
      }

      endDate = _addPeriod(
        startDate,
        budget.periodType,
      ).subtract(const Duration(days: 1));

      // Compute the signed Ready-to-Assign carried forward from the previous
      // period (YNAB-style). `periods` was sorted by endDate desc above, so the
      // first element is the latest existing period.
      var carriedRta = 0;
      final previous = periods.isEmpty ? null : periods.first;
      if (previous != null) {
        final prevAllocations = await _localDatabase.envelopesDao
            .getAllocationsByPeriodId(previous.id);
        final prevAllocated = prevAllocations.fold<int>(
          0,
          (sum, a) => sum + a.allocatedAmount,
        );
        // Signed leftover RTA: positive when under-assigned, negative when
        // over-assigned. carried_rta from the previous period is included so
        // unassigned money compounds across periods instead of vanishing.
        // openingContribution is folded into whichever period contains
        // `Budget.openingDate` so seed cash propagates forward (issue #80).
        // Uses the domain `budget` already fetched above (via getBudget, with
        // remote fallback) rather than the DAO directly to avoid a silently-
        // zero contribution on a cold local cache.
        final prevOpening = _openingContributionFor(
          openingBalance: budget.openingBalance,
          openingDate: budget.openingDate,
          start: previous.startDate,
          end: previous.endDate,
        );
        final signedPrevRta = previous.totalIncome +
            prevOpening +
            previous.carriedRta -
            prevAllocated;
        // Uncovered cash overspend reduces the next period's RTA rather than
        // being carried as a negative envelope rollover (see
        // [_seedRolloverFromPreviousPeriod]).
        var uncoveredOverspend = 0;
        for (final a in prevAllocations) {
          final unspent = a.allocatedAmount - a.spentAmount + a.rolloverAmount;
          if (unspent < 0) uncoveredOverspend += -unspent;
        }
        final prevOffBudgetAdj = await _netOffBudgetTransferAdjustment(
          budgetId: budgetId,
          start: previous.startDate,
          end: previous.endDate,
        );
        carriedRta = signedPrevRta - uncoveredOverspend - prevOffBudgetAdj;
      }

      final newPeriod = await createBudgetPeriod(
        budgetId: budgetId,
        startDate: startDate,
        endDate: endDate,
        carriedRta: carriedRta,
      );

      if (previous != null) {
        // Carry forward each envelope's remaining positive balance.
        await _seedRolloverFromPreviousPeriod(
          fromPeriodId: previous.id,
          toPeriodId: newPeriod.id,
        );
      }

      return newPeriod;
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException(
        'Failed to auto-create next period',
        error: e,
      );
    }
  }

  /// Carries forward each envelope's remaining balance from [fromPeriodId]
  /// into [toPeriodId] as a new allocation with `allocatedAmount=0` and
  /// `rolloverAmount=remaining`. Idempotent: skips envelopes already with an
  /// allocation in the target period. Skips zero and negative remainders —
  /// uncovered overspend is instead deducted from the new period's
  /// `carriedRta` by [autoCreateNextPeriod], so envelopes never carry a
  /// negative (red) rollover.
  Future<void> _seedRolloverFromPreviousPeriod({
    required String fromPeriodId,
    required String toPeriodId,
  }) async {
    final source = await _localDatabase.envelopesDao.getAllocationsByPeriodId(
      fromPeriodId,
    );
    if (source.isEmpty) return;

    final existing = await _localDatabase.envelopesDao.getAllocationsByPeriodId(
      toPeriodId,
    );
    final existingEnvIds = existing.map((a) => a.envelopeId).toSet();

    for (final src in source) {
      if (existingEnvIds.contains(src.envelopeId)) continue;
      final unspent =
          src.allocatedAmount - src.spentAmount + src.rolloverAmount;
      if (unspent <= 0) continue;
      final dto = EnvelopeAllocationDto(
        id: '',
        envelopeId: src.envelopeId,
        budgetPeriodId: toPeriodId,
        allocatedAmount: 0,
        rolloverAmount: unspent,
        createdAt: DateTime.now(),
      );
      final created = await _apiClient.envelopes.createEnvelopeAllocation(dto);
      await _cacheAllocation(created);
    }
  }

  /// Ensures a budget period exists that contains [asOf].
  ///
  /// If the latest existing period's `endDate` is before [asOf], calls
  /// [autoCreateNextPeriod] repeatedly until a period covers [asOf] or the
  /// safety cap is hit. Idempotent: returns immediately if a period already
  /// contains [asOf], if [asOf] is in the past, or if no periods exist
  /// (the seed period is created by onboarding).
  Future<void> ensureCurrentPeriod(
    String budgetId, {
    required DateTime asOf,
  }) async {
    const safetyCap = 24;
    for (var i = 0; i < safetyCap; i++) {
      final periods = await _localDatabase.budgetsDao.getPeriodsByBudgetId(
        budgetId,
      );
      if (periods.isEmpty) return;
      final containsAsOf = periods.any(
        (p) => !p.startDate.isAfter(asOf) && !p.endDate.isBefore(asOf),
      );
      if (containsAsOf) return;
      final latest = periods.reduce(
        (a, b) => a.endDate.isAfter(b.endDate) ? a : b,
      );
      if (!latest.endDate.isBefore(asOf)) return;
      await autoCreateNextPeriod(budgetId);
    }
  }

  /// Returns the id of the budget period containing [date], creating any
  /// missing periods (forward or backward) needed to cover it.
  ///
  /// Walks forward via [autoCreateNextPeriod] when [date] is after the latest
  /// period, and backward via [autoCreatePreviousPeriod] when [date] is before
  /// the earliest. Returns `null` only if no periods exist at all (the seed
  /// period is created by onboarding) or the safety cap is hit.
  Future<String?> ensurePeriodForDate({
    required String budgetId,
    required DateTime date,
  }) async {
    const safetyCap = 36;
    for (var i = 0; i < safetyCap; i++) {
      final periods = await _localDatabase.budgetsDao.getPeriodsByBudgetId(
        budgetId,
      );
      if (periods.isEmpty) return null;

      final containing = periods
          .where((p) => !p.startDate.isAfter(date) && !p.endDate.isBefore(date))
          .firstOrNull;
      if (containing != null) return containing.id;

      final latest = periods.reduce(
        (a, b) => a.endDate.isAfter(b.endDate) ? a : b,
      );
      final earliest = periods.reduce(
        (a, b) => a.startDate.isBefore(b.startDate) ? a : b,
      );

      if (date.isAfter(latest.endDate)) {
        await autoCreateNextPeriod(budgetId);
      } else if (date.isBefore(earliest.startDate)) {
        await autoCreatePreviousPeriod(budgetId);
      } else {
        // Date falls in a gap between existing periods — should not happen for
        // contiguous chains; stop rather than loop forever.
        return null;
      }
    }
    return null;
  }

  /// Creates the budget period immediately BEFORE the earliest existing one.
  ///
  /// Used to back-fill coverage for a transaction dated before the budget's
  /// first period. The new period becomes the earliest (so nothing precedes it,
  /// `carriedRta` starts at 0); the period that was previously earliest then
  /// has its carry-forward recomputed from the new one via
  /// [recomputeCarryForwardFrom].
  Future<BudgetPeriod> autoCreatePreviousPeriod(String budgetId) async {
    try {
      final budget = await getBudget(budgetId);
      final periods = await _localDatabase.budgetsDao.getPeriodsByBudgetId(
        budgetId,
      );
      if (periods.isEmpty) {
        // No anchor to step back from — fall back to the standard seed path.
        return autoCreateNextPeriod(budgetId);
      }

      final earliest = periods.reduce(
        (a, b) => a.startDate.isBefore(b.startDate) ? a : b,
      );
      final startDate = _subtractPeriod(earliest.startDate, budget.periodType);
      final endDate = earliest.startDate.subtract(const Duration(days: 1));

      final created = await createBudgetPeriod(
        budgetId: budgetId,
        startDate: startDate,
        endDate: endDate,
      );

      // If the back-filled period starts before the budget's anchor for seed
      // cash, shift `openingDate` to the new period's startDate so the opening
      // balance lands in the earliest period (issue #80). The cascade below
      // then redistributes it forward via `carriedRta`.
      //
      // Budgets with a null `openingDate` are skipped here: their seed cash
      // has no calendar anchor to migrate. Phase 1+2's onboarding write always
      // sets `openingDate` when `openingBalance` is non-zero, so this branch
      // is effectively legacy-only and the silent skip is intentional.
      final openingDate = budget.openingDate;
      if (openingDate != null && startDate.isBefore(openingDate)) {
        await updateBudget(
          budget.copyWith(openingDate: startDate, updatedAt: DateTime.now()),
        );
      }

      // The formerly-earliest period now follows the new one; propagate
      // carry-forward (RTA + rollovers) forward from the new period.
      await recomputeCarryForwardFrom(
        budgetId: budgetId,
        fromPeriodId: created.id,
      );
      return created;
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException(
        'Failed to auto-create previous period',
        error: e,
      );
    }
  }

  /// Recomputes [BudgetPeriod.carriedRta] and re-seeds positive rollovers for
  /// every period chronologically AFTER [fromPeriodId], propagating changes
  /// (e.g. a newly recorded back-dated overspend) forward through the chain.
  ///
  /// Mirrors the carry-forward formula in [autoCreateNextPeriod]: each period's
  /// carried RTA is the previous period's signed leftover RTA minus its
  /// uncovered cash overspend.
  Future<void> recomputeCarryForwardFrom({
    required String budgetId,
    required String fromPeriodId,
  }) async {
    final periods = await _localDatabase.budgetsDao.getPeriodsByBudgetId(
      budgetId,
    )
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    final startIdx = periods.indexWhere((p) => p.id == fromPeriodId);
    if (startIdx < 0) return;

    // Fetch via repo (remote fallback on cold cache) rather than DAO directly
    // so a stale local cache cannot silently zero the opening contribution.
    final budget = await getBudget(budgetId);

    // Cascade reads its OWN updates: when period N's carriedRta is rewritten,
    // period N+1 must see the new value (not the snapshot loaded above). Track
    // recomputed values in a map keyed by periodId so subsequent iterations
    // read fresh data without re-fetching from the DB.
    final recomputedCarriedRta = <String, int>{};

    for (var i = startIdx + 1; i < periods.length; i++) {
      final previous = periods[i - 1];
      final current = periods[i];

      final prevAllocations = await _localDatabase.envelopesDao
          .getAllocationsByPeriodId(previous.id);
      final prevAllocated = prevAllocations.fold<int>(
        0,
        (sum, a) => sum + a.allocatedAmount,
      );
      // openingContribution is folded in for whichever period contains
      // `Budget.openingDate` so the seed cash propagates forward (issue #80).
      final prevOpening = _openingContributionFor(
        openingBalance: budget.openingBalance,
        openingDate: budget.openingDate,
        start: previous.startDate,
        end: previous.endDate,
      );
      final prevCarriedRta =
          recomputedCarriedRta[previous.id] ?? previous.carriedRta;
      final signedPrevRta = previous.totalIncome +
          prevOpening +
          prevCarriedRta -
          prevAllocated;
      var uncoveredOverspend = 0;
      for (final a in prevAllocations) {
        final unspent = a.allocatedAmount - a.spentAmount + a.rolloverAmount;
        if (unspent < 0) uncoveredOverspend += -unspent;
      }
      final prevOffBudgetAdj = await _netOffBudgetTransferAdjustment(
        budgetId: budgetId,
        start: previous.startDate,
        end: previous.endDate,
      );
      final newCarried = signedPrevRta - uncoveredOverspend - prevOffBudgetAdj;
      recomputedCarriedRta[current.id] = newCarried;

      if (newCarried != current.carriedRta) {
        await updateBudgetPeriod(
          _mapBudgetPeriodFromLocal(current).copyWith(carriedRta: newCarried),
        );
      }
      await _seedRolloverFromPreviousPeriod(
        fromPeriodId: previous.id,
        toPeriodId: current.id,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Budget-Level Allocation Operations
  // ---------------------------------------------------------------------------

  /// Calculates the "Ready to Assign" amount for a budget period.
  ///
  /// Formula:
  /// `totalIncome + openingContribution + carriedRta - sum(allocatedAmounts)`.
  ///
  /// `openingContribution` is `Budget.openingBalance` when the period contains
  /// `Budget.openingDate`, otherwise 0. This anchors the seed cash to a single
  /// period; downstream periods receive it via `carriedRta`.
  ///
  /// `carriedRta` folds in the signed leftover RTA from the previous period
  /// (and any uncovered overspend penalty), so unassigned money rolls forward
  /// instead of vanishing and a negative result forces the user to rebalance.
  ///
  /// `rolloverAmount` is intentionally excluded: it represents money that
  /// stays in its envelope across periods (YNAB-style per-envelope carry).
  /// Including it would double-count those funds — they would appear both as
  /// envelope balance and as free RTA.
  Future<int> calculateReadyToAssign(String budgetPeriodId) async {
    try {
      final period = await _localDatabase.budgetsDao.getBudgetPeriod(
        budgetPeriodId,
      );
      if (period == null) {
        throw BudgetException(
          'Budget period not found: $budgetPeriodId',
        );
      }

      // Fetch via repo (remote fallback on cold cache) rather than DAO directly
      // so a stale local cache cannot silently zero the opening contribution.
      final budget = await getBudget(period.budgetId);

      final allocations = await _localDatabase.envelopesDao
          .getAllocationsByPeriodId(budgetPeriodId);

      final totalAllocated = allocations.fold<int>(
        0,
        (sum, a) => sum + a.allocatedAmount,
      );

      final openingContribution = _openingContributionFor(
        openingBalance: budget.openingBalance,
        openingDate: budget.openingDate,
        start: period.startDate,
        end: period.endDate,
      );

      return period.totalIncome +
          openingContribution +
          period.carriedRta -
          totalAllocated;
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException(
        'Failed to calculate ready to assign',
        error: e,
      );
    }
  }

  /// Returns [openingBalance] when `[start, end]` (inclusive on both ends)
  /// contains [openingDate], else 0. Null-safe — returns 0 when [openingDate]
  /// is unset (e.g. legacy budgets predating #80).
  ///
  /// Inclusive boundaries are load-bearing: periods are stored as a calendar
  /// `[startDate, endDate]` pair (endDate is the last day of the period, not
  /// an exclusive next-period start), so `openingDate == startDate` and
  /// `openingDate == endDate` must both fall inside this period.
  /// Net off-budget transfer adjustment for a period: outflows minus inflows.
  ///
  /// Mirrors the `totalOffBudgetTransfersOut - totalOffBudgetTransfersIn`
  /// computation from `DashboardState` so the same adjustment is applied when
  /// computing `carriedRta`, preventing it from leaking into the next period.
  ///
  /// Only untagged transfers (envelopeId == null) are counted — tagged ones
  /// are already handled via envelope allocations.
  Future<int> _netOffBudgetTransferAdjustment({
    required String budgetId,
    required DateTime start,
    required DateTime end,
  }) async {
    final transactions = await _localDatabase.transactionsDao
        .getTransactionsByBudgetId(budgetId);
    final accounts = await _localDatabase.accountsDao
        .getAccountsByBudgetId(budgetId);

    final accountMap = {for (final a in accounts) a.id: a};

    // Build transferPairId → accountIds map for transfers in this period.
    final pairAccounts = <String, List<String>>{};
    for (final t in transactions) {
      if (t.type != 'transfer' || t.transferPairId == null) continue;
      if (t.date.isBefore(start) || t.date.isAfter(end)) continue;
      (pairAccounts[t.transferPairId!] ??= []).add(t.accountId);
    }

    bool isCc(String type) => type == 'credit_card' || type == 'creditCard';

    var out = 0;
    var inn = 0;
    for (final t in transactions) {
      if (t.type != 'transfer') continue;
      if (t.transferPairId == null || t.envelopeId != null) continue;
      if (t.date.isBefore(start) || t.date.isAfter(end)) continue;

      final account = accountMap[t.accountId];
      if (account == null) continue;

      final legs = pairAccounts[t.transferPairId!] ?? [];
      final otherId = legs.firstWhere(
        (id) => id != t.accountId,
        orElse: () => '',
      );
      if (otherId.isEmpty) continue;
      final other = accountMap[otherId];
      if (other == null) continue;

      if (t.amount < 0 &&
          account.isOnBudget &&
          !other.isOnBudget &&
          !isCc(other.type)) {
        out += t.amount.abs();
      } else if (t.amount > 0 &&
          account.isOnBudget &&
          !other.isOnBudget &&
          !isCc(other.type)) {
        inn += t.amount;
      }
    }
    return out - inn;
  }

  static int _openingContributionFor({
    required int openingBalance,
    required DateTime? openingDate,
    required DateTime start,
    required DateTime end,
  }) {
    if (openingDate == null) return 0;
    if (start.isAfter(openingDate) || end.isBefore(openingDate)) return 0;
    return openingBalance;
  }

  /// Duplicates the allocated amounts from one budget period to another.
  ///
  /// For each allocation in [fromPeriodId], creates a new allocation in
  /// [toPeriodId] with the same `allocatedAmount`. The `spentAmount` and
  /// `rolloverAmount` are set to zero for the new period.
  Future<void> duplicateAllocations({
    required String fromPeriodId,
    required String toPeriodId,
  }) async {
    try {
      final sourceAllocations = await _localDatabase.envelopesDao
          .getAllocationsByPeriodId(fromPeriodId);

      for (final source in sourceAllocations) {
        final dto = EnvelopeAllocationDto(
          id: '',
          envelopeId: source.envelopeId,
          budgetPeriodId: toPeriodId,
          allocatedAmount: source.allocatedAmount,
          createdAt: DateTime.now(),
        );

        final created = await _apiClient.envelopes.createEnvelopeAllocation(
          dto,
        );
        await _cacheAllocation(created);
      }
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to duplicate allocations',
        error: e,
      );
    }
  }

  /// Transfers an amount between two envelope allocations.
  ///
  /// Subtracts [amount] from [fromAllocationId] and adds it to
  /// [toAllocationId]. Both updates go through the API first.
  ///
  /// If the second update fails after the first succeeds, the first
  /// update is reverted to prevent data loss.
  ///
  /// Throws [BudgetException] if [amount] is not positive or exceeds
  /// the source allocation's `allocatedAmount`.
  Future<void> transferBetweenEnvelopes({
    required String fromAllocationId,
    required String toAllocationId,
    required int amount,
  }) async {
    if (amount <= 0) {
      throw const BudgetException(
        'Transfer amount must be positive',
      );
    }

    try {
      // Fetch the specific allocations directly via API.
      final fromDto = await _apiClient.envelopes.getEnvelopeAllocation(
        fromAllocationId,
      );
      final toDto = await _apiClient.envelopes.getEnvelopeAllocation(
        toAllocationId,
      );

      if (amount > fromDto.allocatedAmount) {
        throw BudgetException(
          'Insufficient funds: cannot transfer $amount '
          'from allocation with ${fromDto.allocatedAmount}',
        );
      }

      final updatedFrom = fromDto.copyWith(
        allocatedAmount: fromDto.allocatedAmount - amount,
      );
      final updatedTo = toDto.copyWith(
        allocatedAmount: toDto.allocatedAmount + amount,
      );

      final resultFrom = await _apiClient.envelopes.updateEnvelopeAllocation(
        updatedFrom,
      );

      // If the second update fails, revert the first.
      EnvelopeAllocationDto resultTo;
      try {
        resultTo = await _apiClient.envelopes.updateEnvelopeAllocation(
          updatedTo,
        );
      } on EnvelopeApiException {
        // Revert the first update.
        await _apiClient.envelopes.updateEnvelopeAllocation(fromDto);
        rethrow;
      }

      await _cacheAllocation(resultFrom);
      await _cacheAllocation(resultTo);
    } on BudgetException {
      rethrow;
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to transfer between envelopes',
        error: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Allocation Templates
  // ---------------------------------------------------------------------------

  /// Creates a new allocation template.
  Future<AllocationTemplate> createAllocationTemplate({
    required String budgetId,
    required String name,
    required List<AllocationTemplateItem> items,
  }) async {
    try {
      final templateDto = AllocationTemplateDto(
        id: '',
        budgetId: budgetId,
        name: name,
        createdAt: DateTime.now(),
      );

      final createdTemplate = await _apiClient.envelopes
          .createAllocationTemplate(templateDto);
      await _cacheTemplate(createdTemplate);

      final createdItems = <AllocationTemplateItemDto>[];
      for (final item in items) {
        final itemDto = AllocationTemplateItemDto(
          id: '',
          templateId: createdTemplate.id,
          envelopeId: item.envelopeId,
          percentage: item.percentage,
        );
        final created = await _apiClient.envelopes.createAllocationTemplateItem(
          itemDto,
        );
        await _cacheTemplateItem(created);
        createdItems.add(created);
      }

      return _mapTemplateFromDto(
        createdTemplate,
        createdItems,
      );
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to create allocation template',
        error: e,
      );
    }
  }

  /// Gets all allocation templates for a [budgetId].
  ///
  /// Tries local storage first, falls back to the API.
  Future<List<AllocationTemplate>> getAllocationTemplates(
    String budgetId,
  ) async {
    try {
      final localTemplates = await _localDatabase.envelopesDao
          .getTemplatesByBudgetId(budgetId);

      if (localTemplates.isNotEmpty) {
        final results = <AllocationTemplate>[];
        for (final t in localTemplates) {
          final items = await _localDatabase.envelopesDao
              .getTemplateItemsByTemplateId(t.id);
          results.add(_mapTemplateFromLocal(t, items));
        }
        return results;
      }

      final remoteTemplates = await _apiClient.envelopes
          .getAllocationTemplatesByBudget(budgetId);
      final results = <AllocationTemplate>[];
      for (final t in remoteTemplates) {
        await _cacheTemplate(t);
        final remoteItems = await _apiClient.envelopes
            .getAllocationTemplateItems(t.id);
        for (final item in remoteItems) {
          await _cacheTemplateItem(item);
        }
        results.add(_mapTemplateFromDto(t, remoteItems));
      }
      return results;
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to get allocation templates',
        error: e,
      );
    }
  }

  /// Watches all allocation templates for a [budgetId].
  ///
  /// Returns a reactive stream from local storage. For each template,
  /// loads its items.
  Stream<List<AllocationTemplate>> watchAllocationTemplates(
    String budgetId,
  ) {
    return _localDatabase.envelopesDao
        .watchTemplatesByBudgetId(budgetId)
        .asyncMap(
          (templates) async {
            final results = <AllocationTemplate>[];
            for (final t in templates) {
              final items = await _localDatabase.envelopesDao
                  .getTemplateItemsByTemplateId(t.id);
              results.add(_mapTemplateFromLocal(t, items));
            }
            return results;
          },
        )
        .handleError(
          (Object error) => throw BudgetException(
            'Failed to watch allocation templates',
            error: error,
          ),
        );
  }

  /// Updates an allocation template.
  ///
  /// Updates the template metadata, then replaces all items
  /// (delete old from API first, then local, then create new).
  Future<void> updateAllocationTemplate(
    AllocationTemplate template,
  ) async {
    try {
      final dto = _mapTemplateToDto(template);
      final updated = await _apiClient.envelopes.updateAllocationTemplate(dto);
      await _cacheTemplate(updated);

      // Replace items: remote-first — delete old from API, then local.
      final oldItems = await _apiClient.envelopes.getAllocationTemplateItems(
        template.id,
      );
      for (final item in oldItems) {
        await _apiClient.envelopes.deleteAllocationTemplateItem(item.id);
      }
      await _localDatabase.envelopesDao.deleteTemplateItemsByTemplateId(
        template.id,
      );

      for (final item in template.items) {
        final itemDto = AllocationTemplateItemDto(
          id: '',
          templateId: template.id,
          envelopeId: item.envelopeId,
          percentage: item.percentage,
        );
        final created = await _apiClient.envelopes.createAllocationTemplateItem(
          itemDto,
        );
        await _cacheTemplateItem(created);
      }
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to update allocation template',
        error: e,
      );
    }
  }

  /// Deletes an allocation template by its [id].
  ///
  /// Deletes items first, then the template. Local cleanup is best-effort.
  Future<void> deleteAllocationTemplate(String id) async {
    try {
      // Delete items first from API.
      final items = await _apiClient.envelopes.getAllocationTemplateItems(id);
      for (final item in items) {
        await _apiClient.envelopes.deleteAllocationTemplateItem(item.id);
      }
      await _apiClient.envelopes.deleteAllocationTemplate(id);
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to delete allocation template',
        error: e,
      );
    }
    try {
      await _localDatabase.envelopesDao.deleteTemplateItemsByTemplateId(id);
      await _localDatabase.envelopesDao.deleteTemplate(id);
    } on Exception {
      // Stale local entries will be cleaned up on next refresh.
    }
  }

  /// Applies an allocation template to a budget period.
  ///
  /// Computes amounts from each item's percentage of [totalAmount],
  /// creates allocations for each envelope. Distributes any rounding
  /// remainder to the first item.
  ///
  /// Throws [BudgetException] if the template's item percentages do not
  /// sum to 100, or if allocations for the same envelopes already exist
  /// in the target period.
  Future<void> applyAllocationTemplate({
    required String templateId,
    required String budgetPeriodId,
    required int totalAmount,
  }) async {
    try {
      final items = await _apiClient.envelopes.getAllocationTemplateItems(
        templateId,
      );

      if (items.isEmpty) return;

      // Validate percentages sum to 100.
      final percentageSum = items.fold<double>(
        0,
        (sum, i) => sum + i.percentage,
      );
      if ((percentageSum - 100).abs() > 0.01) {
        throw BudgetException(
          'Template item percentages sum to $percentageSum, '
          'expected 100',
        );
      }

      // Check for existing allocations in the target period.
      final existing = await _localDatabase.envelopesDao
          .getAllocationsByPeriodId(budgetPeriodId);
      final existingEnvelopeIds = existing.map((a) => a.envelopeId).toSet();
      final conflicting = items
          .where((i) => existingEnvelopeIds.contains(i.envelopeId))
          .toList();
      if (conflicting.isNotEmpty) {
        throw BudgetException(
          'Allocations already exist for envelopes: '
          '${conflicting.map((i) => i.envelopeId).join(', ')}',
        );
      }

      // Compute amounts from percentages.
      final amounts = <int>[];
      var allocated = 0;
      for (var i = 0; i < items.length; i++) {
        final amount = (totalAmount * items[i].percentage / 100).round();
        amounts.add(amount);
        allocated += amount;
      }

      // Distribute rounding remainder to the first item.
      final remainder = totalAmount - allocated;
      amounts[0] += remainder;

      // Create allocations.
      for (var i = 0; i < items.length; i++) {
        final dto = EnvelopeAllocationDto(
          id: '',
          envelopeId: items[i].envelopeId,
          budgetPeriodId: budgetPeriodId,
          allocatedAmount: amounts[i],
          createdAt: DateTime.now(),
        );
        final created = await _apiClient.envelopes.createEnvelopeAllocation(
          dto,
        );
        await _cacheAllocation(created);
      }
    } on BudgetException {
      rethrow;
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to apply allocation template',
        error: e,
      );
    }
  }

  /// Fetches allocation templates from the API and syncs to local storage.
  Future<void> refreshAllocationTemplates(String budgetId) async {
    try {
      final remoteTemplates = await _apiClient.envelopes
          .getAllocationTemplatesByBudget(budgetId);

      final templateCompanions = remoteTemplates
          .map(_toTemplateCompanion)
          .toList();
      await _localDatabase.envelopesDao.batchInsertTemplates(
        templateCompanions,
        mode: InsertMode.insertOrReplace,
      );

      for (final t in remoteTemplates) {
        final items = await _apiClient.envelopes.getAllocationTemplateItems(
          t.id,
        );
        final itemCompanions = items.map(_toTemplateItemCompanion).toList();
        await _localDatabase.envelopesDao.batchInsertTemplateItems(
          itemCompanions,
          mode: InsertMode.insertOrReplace,
        );
      }
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to refresh allocation templates',
        error: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Realtime
  // ---------------------------------------------------------------------------

  /// Subscribes to real-time changes on the `budgets` table
  /// filtered by [budgetId].
  RealtimeChannel? subscribeToBudgetChanges(String budgetId) {
    final client = _supabaseClient;
    if (client == null) return null;

    final channel = client
        .channel('budgets:$budgetId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'budgets',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: budgetId,
          ),
          callback: (payload) async {
            try {
              final newRecord = payload.newRecord;
              final oldRecord = payload.oldRecord;

              switch (payload.eventType) {
                case PostgresChangeEvent.insert:
                case PostgresChangeEvent.update:
                  if (newRecord.isNotEmpty) {
                    final dto = BudgetDto.fromJson(newRecord);
                    await _cacheBudget(dto);
                    if (_localWriteCount == 0) {
                      _remoteChangeController.add(null);
                    }
                  }
                case PostgresChangeEvent.delete:
                  if (oldRecord.isNotEmpty) {
                    final id = oldRecord['id'] as String?;
                    if (id != null) {
                      await _localDatabase.budgetsDao.deleteBudget(id);
                      if (_localWriteCount == 0) {
                        _remoteChangeController.add(null);
                      }
                    }
                  }
                case PostgresChangeEvent.all:
                  break;
              }
            } on Exception {
              // Prevent malformed payload from breaking the channel.
            }
          },
        )
        .subscribe();

    return channel;
  }

  /// Subscribes to real-time changes on the `budget_periods` table
  /// filtered by [budgetId].
  RealtimeChannel? subscribeToPeriodChanges(String budgetId) {
    final client = _supabaseClient;
    if (client == null) return null;

    final channel = client
        .channel('budget_periods:$budgetId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'budget_periods',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'budget_id',
            value: budgetId,
          ),
          callback: (payload) async {
            try {
              final newRecord = payload.newRecord;
              final oldRecord = payload.oldRecord;

              switch (payload.eventType) {
                case PostgresChangeEvent.insert:
                case PostgresChangeEvent.update:
                  if (newRecord.isNotEmpty) {
                    final dto = BudgetPeriodDto.fromJson(newRecord);
                    await _cacheBudgetPeriod(dto);
                    if (_localWriteCount == 0) {
                      _remoteChangeController.add(null);
                    }
                  }
                case PostgresChangeEvent.delete:
                  if (oldRecord.isNotEmpty) {
                    final id = oldRecord['id'] as String?;
                    if (id != null) {
                      await _localDatabase.budgetsDao.deleteBudgetPeriod(id);
                      if (_localWriteCount == 0) {
                        _remoteChangeController.add(null);
                      }
                    }
                  }
                case PostgresChangeEvent.all:
                  break;
              }
            } on Exception {
              // Prevent malformed payload from breaking the channel.
            }
          },
        )
        .subscribe();

    return channel;
  }

  void _beginLocalWrite() => _localWriteCount++;

  void _endLocalWrite() {
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (_localWriteCount > 0) _localWriteCount--;
    });
  }

  /// Closes resources held by this repository.
  void dispose() {
    _remoteChangeController.close();
  }

  // ---------------------------------------------------------------------------
  // Private — Period helpers
  // ---------------------------------------------------------------------------

  /// Creates a [DateTime] with the day clamped to the last valid day
  /// of the given month, avoiding Dart's automatic month rollover.
  static DateTime _clampedDate(int year, int month, int day) {
    // DateTime(year, month + 1, 0) gives the last day of [month].
    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, min(day, lastDay));
  }

  static DateTime _addPeriod(DateTime date, String periodType) {
    switch (periodType) {
      case 'weekly':
        return date.add(const Duration(days: 7));
      case 'biweekly':
        return date.add(const Duration(days: 14));
      case 'monthly':
      default:
        return _clampedDate(date.year, date.month + 1, date.day);
    }
  }

  static DateTime _subtractPeriod(DateTime date, String periodType) {
    switch (periodType) {
      case 'weekly':
        return date.subtract(const Duration(days: 7));
      case 'biweekly':
        return date.subtract(const Duration(days: 14));
      case 'monthly':
      default:
        return _clampedDate(date.year, date.month - 1, date.day);
    }
  }

  // ---------------------------------------------------------------------------
  // Private — DTO ↔ Domain mapping
  // ---------------------------------------------------------------------------

  static Budget _mapBudgetFromDto(BudgetDto dto) {
    return Budget(
      id: dto.id,
      ownerId: dto.ownerId,
      name: dto.name,
      baseCurrency: dto.baseCurrency,
      periodType: dto.periodType,
      periodStartDay: dto.periodStartDay,
      isArchived: dto.isArchived,
      openingBalance: dto.openingBalance,
      openingDate: dto.openingDate,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static Budget _mapBudgetFromLocal(storage.Budget row) {
    return Budget(
      id: row.id,
      ownerId: row.ownerId,
      name: row.name,
      baseCurrency: row.baseCurrency,
      periodType: row.periodType,
      periodStartDay: row.periodStartDay,
      isArchived: row.isArchived,
      openingBalance: row.openingBalance,
      openingDate: row.openingDate,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static BudgetDto _mapBudgetToDto(Budget budget) {
    return BudgetDto(
      id: budget.id,
      ownerId: budget.ownerId,
      name: budget.name,
      baseCurrency: budget.baseCurrency,
      periodType: budget.periodType,
      periodStartDay: budget.periodStartDay,
      isArchived: budget.isArchived,
      openingBalance: budget.openingBalance,
      openingDate: budget.openingDate,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
    );
  }

  static BudgetPeriod _mapBudgetPeriodFromDto(BudgetPeriodDto dto) {
    return BudgetPeriod(
      id: dto.id,
      budgetId: dto.budgetId,
      startDate: dto.startDate,
      endDate: dto.endDate,
      totalIncome: dto.totalIncome,
      totalAllocated: dto.totalAllocated,
      carriedRta: dto.carriedRta,
      isClosed: dto.isClosed,
      createdAt: dto.createdAt,
    );
  }

  static BudgetPeriod _mapBudgetPeriodFromLocal(
    storage.BudgetPeriod row,
  ) {
    return BudgetPeriod(
      id: row.id,
      budgetId: row.budgetId,
      startDate: row.startDate,
      endDate: row.endDate,
      totalIncome: row.totalIncome,
      totalAllocated: row.totalAllocated,
      carriedRta: row.carriedRta,
      isClosed: row.isClosed,
      createdAt: row.createdAt,
    );
  }

  static AllocationTemplate _mapTemplateFromDto(
    AllocationTemplateDto dto,
    List<AllocationTemplateItemDto> itemDtos,
  ) {
    return AllocationTemplate(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
      createdAt: dto.createdAt,
      items: itemDtos.map(_mapTemplateItemFromDto).toList(),
    );
  }

  static AllocationTemplate _mapTemplateFromLocal(
    storage.AllocationTemplate row,
    List<storage.AllocationTemplateItem> itemRows,
  ) {
    return AllocationTemplate(
      id: row.id,
      budgetId: row.budgetId,
      name: row.name,
      createdAt: row.createdAt,
      items: itemRows.map(_mapTemplateItemFromLocal).toList(),
    );
  }

  static AllocationTemplateDto _mapTemplateToDto(
    AllocationTemplate template,
  ) {
    return AllocationTemplateDto(
      id: template.id,
      budgetId: template.budgetId,
      name: template.name,
      createdAt: template.createdAt,
    );
  }

  static AllocationTemplateItem _mapTemplateItemFromDto(
    AllocationTemplateItemDto dto,
  ) {
    return AllocationTemplateItem(
      id: dto.id,
      templateId: dto.templateId,
      envelopeId: dto.envelopeId,
      percentage: dto.percentage,
    );
  }

  static AllocationTemplateItem _mapTemplateItemFromLocal(
    storage.AllocationTemplateItem row,
  ) {
    return AllocationTemplateItem(
      id: row.id,
      templateId: row.templateId,
      envelopeId: row.envelopeId,
      percentage: row.percentage,
    );
  }

  // ---------------------------------------------------------------------------
  // Private — Local cache helpers
  // ---------------------------------------------------------------------------

  static storage.BudgetsCompanion _toBudgetCompanion(BudgetDto dto) {
    return storage.BudgetsCompanion.insert(
      id: dto.id,
      ownerId: dto.ownerId,
      name: dto.name,
      baseCurrency: dto.baseCurrency,
      periodType: Value(dto.periodType),
      periodStartDay: Value(dto.periodStartDay),
      isArchived: Value(dto.isArchived),
      openingBalance: Value(dto.openingBalance),
      openingDate: Value(dto.openingDate),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  Future<void> _cacheBudget(BudgetDto dto) async {
    await _localDatabase.budgetsDao.insertBudget(
      _toBudgetCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  static storage.BudgetPeriodsCompanion _toBudgetPeriodCompanion(
    BudgetPeriodDto dto,
  ) {
    return storage.BudgetPeriodsCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      startDate: dto.startDate,
      endDate: dto.endDate,
      totalIncome: Value(dto.totalIncome),
      totalAllocated: Value(dto.totalAllocated),
      carriedRta: Value(dto.carriedRta),
      isClosed: Value(dto.isClosed),
      createdAt: dto.createdAt,
    );
  }

  Future<void> _cacheBudgetPeriod(BudgetPeriodDto dto) async {
    await _localDatabase.budgetsDao.insertBudgetPeriod(
      _toBudgetPeriodCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  static storage.AllocationTemplatesCompanion _toTemplateCompanion(
    AllocationTemplateDto dto,
  ) {
    return storage.AllocationTemplatesCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
      createdAt: dto.createdAt,
    );
  }

  Future<void> _cacheTemplate(AllocationTemplateDto dto) async {
    await _localDatabase.envelopesDao.insertTemplate(
      _toTemplateCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  static storage.AllocationTemplateItemsCompanion _toTemplateItemCompanion(
    AllocationTemplateItemDto dto,
  ) {
    return storage.AllocationTemplateItemsCompanion.insert(
      id: dto.id,
      templateId: dto.templateId,
      envelopeId: dto.envelopeId,
      percentage: dto.percentage,
    );
  }

  Future<void> _cacheTemplateItem(AllocationTemplateItemDto dto) async {
    await _localDatabase.envelopesDao.insertTemplateItem(
      _toTemplateItemCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> _cacheAllocation(EnvelopeAllocationDto dto) async {
    await _localDatabase.envelopesDao.insertAllocation(
      storage.EnvelopeAllocationsCompanion.insert(
        id: dto.id,
        envelopeId: dto.envelopeId,
        budgetPeriodId: dto.budgetPeriodId,
        allocatedAmount: Value(dto.allocatedAmount),
        spentAmount: Value(dto.spentAmount),
        rolloverAmount: Value(dto.rolloverAmount),
        createdAt: dto.createdAt,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
}
