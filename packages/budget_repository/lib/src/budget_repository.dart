import 'dart:async';

import 'package:budget_repository/budget_repository.dart';
import 'package:drift/drift.dart'
    show InsertMode, TableUpdate, TableUpdateQuery, Value;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:envelope_repository/envelope_repository.dart'
    show EnvelopeAllocation;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for budget operations.
///
/// Uses a remote-first strategy: writes go to the Supabase API first,
/// then sync the result to the local Drift database. Reads stream from
/// local storage for reactive UI updates.
///
/// As of issue #82, budget periods have been removed entirely. RTA and
/// envelope allocations are global. Monthly views are re-derived from
/// transaction dates on demand by the reports layer.
class BudgetRepository {
  /// Creates a [BudgetRepository].
  ///
  /// An optional [supabaseClient] can be provided for Realtime
  /// subscriptions via [subscribeToBudgetChanges].
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
  /// [openingBalance] (cents) is the seed cash anchored on [openingDate]. It
  /// folds directly into the global RTA formula.
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
  Stream<List<Budget>> watchBudgets(String ownerId) {
    return _localDatabase.budgetsDao
        .watchBudgetsByOwnerId(ownerId)
        .map((rows) => rows.map(_mapBudgetFromLocal).toList())
        .handleError(
          (Object error) =>
              throw BudgetException('Failed to watch budgets', error: error),
        );
  }

  /// Updates a [budget].
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
  /// multiple cubits.
  final Map<String, Future<void>> _openingBalanceRefreshQueue = {};

  /// Recomputes `Budget.openingBalance` from the current set of on-budget,
  /// non-archived accounts.
  ///
  /// Sum rule mirrors onboarding: each on-budget account contributes its
  /// `startingBalance` clamped at zero (negative starting balances do NOT
  /// count as seed cash). Only `startingBalance` changes affect the seed
  /// cash — `currentBalance` edits do NOT require this refresh.
  ///
  /// `openingDate` is preserved.
  // TODO(#80-fx): FX-convert per-account `startingBalance` to base currency
  // before summing.
  Future<void> refreshOpeningBalanceForBudget(String budgetId) async {
    final prior = _openingBalanceRefreshQueue[budgetId];
    final completer = Completer<void>();
    _openingBalanceRefreshQueue[budgetId] = completer.future;
    if (prior != null) {
      try {
        await prior;
      } on Object {
        // Prior caller's error is theirs to handle.
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
      if (sum == budget.accountSeedBalance) return;

      // Write to accountSeedBalance only — openingBalance is reserved for the
      // legacy seed plus pre-#82 historical income folded in by migration
      // 00041, and must survive routine account edits intact.
      await updateBudget(
        budget.copyWith(
          accountSeedBalance: sum,
          updatedAt: DateTime.now(),
        ),
      );
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException('Failed to refresh opening balance', error: e);
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
  // Ready to Assign
  // ---------------------------------------------------------------------------

  /// Calculates the "Ready to Assign" amount for a budget.
  ///
  /// Formula:
  ///   `sumIncomeTransactions + openingBalance + accountSeedBalance
  ///    - sumAllAllocations`.
  ///
  /// All terms are budget-global. Income is derived from the transactions
  /// table on demand. `openingBalance` carries the legacy seed plus any
  /// pre-#82 historical income folded in by migration 00041 — it is set
  /// once and never recomputed. `accountSeedBalance` tracks the on-budget
  /// account starting-balance sum and is refreshed by
  /// [refreshOpeningBalanceForBudget] whenever accounts change.
  Future<int> calculateReadyToAssign(String budgetId) async {
    try {
      final budget = await getBudget(budgetId);
      final totalIncome = await _localDatabase.transactionsDao
          .sumIncomeByBudgetId(budgetId);
      final totalAllocated = await _localDatabase.envelopesDao
          .sumAllocationsByBudgetId(budgetId);
      return totalIncome +
          budget.openingBalance +
          budget.accountSeedBalance -
          totalAllocated;
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException('Failed to calculate ready to assign', error: e);
    }
  }

  /// Streams "Ready to Assign" for a budget. Re-emits whenever any input
  /// changes (budget row, income transactions, envelope allocations).
  ///
  /// Updates are debounced by 80ms so that bulk writes (CSV import, bulk
  /// allocate, realtime sync fan-in) collapse to a single recompute instead
  /// of one query-trio per row.
  Stream<int> watchReadyToAssign(String budgetId) {
    late StreamController<int> controller;
    StreamSubscription<Set<TableUpdate>>? sub;
    Timer? debounce;
    var disposed = false;

    Future<void> emitLatest() async {
      if (disposed) return;
      try {
        final value = await calculateReadyToAssign(budgetId);
        if (!disposed && !controller.isClosed) controller.add(value);
      } on Object catch (e, st) {
        if (!disposed && !controller.isClosed) controller.addError(e, st);
      }
    }

    void scheduleEmit() {
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 80), emitLatest);
    }

    controller = StreamController<int>(
      onListen: () {
        // Initial emission is immediate so first paint isn't delayed.
        unawaited(emitLatest());
        sub = _localDatabase
            .tableUpdates(
              TableUpdateQuery.onAllTables({
                _localDatabase.budgets,
                _localDatabase.transactions,
                _localDatabase.envelopeAllocations,
              }),
            )
            .listen((_) => scheduleEmit());
      },
      onCancel: () async {
        disposed = true;
        debounce?.cancel();
        await sub?.cancel();
      },
    );
    return controller.stream;
  }

  // ---------------------------------------------------------------------------
  // Envelope Allocations (global — one row per envelope)
  // ---------------------------------------------------------------------------

  /// Watches the running list of allocations for [budgetId]. Each envelope
  /// has at most one allocation row.
  Stream<List<EnvelopeAllocation>> watchAllocationsByBudgetId(String budgetId) {
    return _localDatabase.envelopesDao
        .watchAllocationsByBudgetId(budgetId)
        .map((rows) => rows.map(_mapAllocationFromLocal).toList())
        .handleError(
          (Object error) => throw BudgetException(
            'Failed to watch allocations',
            error: error,
          ),
        );
  }

  /// Watches the single allocation row for [envelopeId], or null when the
  /// envelope has never been allocated to.
  Stream<EnvelopeAllocation?> watchAllocationByEnvelopeId(String envelopeId) {
    return _localDatabase.envelopesDao
        .watchAllocationByEnvelopeId(envelopeId)
        .map((row) => row == null ? null : _mapAllocationFromLocal(row))
        .handleError(
          (Object error) => throw BudgetException(
            'Failed to watch allocation',
            error: error,
          ),
        );
  }

  /// Sets the global allocation for [envelopeId] to [allocatedAmount]. Creates
  /// the row when missing.
  Future<EnvelopeAllocation> setAllocation({
    required String envelopeId,
    required int allocatedAmount,
  }) async {
    if (allocatedAmount < 0) {
      throw const BudgetException('Allocated amount cannot be negative');
    }
    try {
      final existing = await _apiClient.envelopes.getAllocationByEnvelope(
        envelopeId,
      );
      EnvelopeAllocationDto result;
      if (existing == null) {
        final dto = EnvelopeAllocationDto(
          id: '',
          envelopeId: envelopeId,
          allocatedAmount: allocatedAmount,
          createdAt: DateTime.now(),
        );
        result = await _apiClient.envelopes.createEnvelopeAllocation(dto);
      } else {
        result = await _apiClient.envelopes.updateEnvelopeAllocation(
          existing.copyWith(allocatedAmount: allocatedAmount),
        );
      }
      await _cacheAllocation(result);
      return _mapAllocationFromDto(result);
    } on EnvelopeApiException catch (e) {
      throw BudgetException('Failed to set allocation', error: e);
    }
  }

  /// Transfers an amount between two envelope allocations.
  ///
  /// Subtracts [amount] from [fromAllocationId] and adds it to
  /// [toAllocationId]. Both updates go through the API first.
  ///
  /// If the second update fails after the first succeeds, the first
  /// update is reverted to prevent data loss.
  Future<void> transferBetweenEnvelopes({
    required String fromAllocationId,
    required String toAllocationId,
    required int amount,
  }) async {
    if (amount <= 0) {
      throw const BudgetException('Transfer amount must be positive');
    }

    try {
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

      EnvelopeAllocationDto resultTo;
      try {
        resultTo = await _apiClient.envelopes.updateEnvelopeAllocation(
          updatedTo,
        );
      } on EnvelopeApiException {
        await _apiClient.envelopes.updateEnvelopeAllocation(fromDto);
        rethrow;
      }

      await _cacheAllocation(resultFrom);
      await _cacheAllocation(resultTo);
    } on BudgetException {
      rethrow;
    } on EnvelopeApiException catch (e) {
      throw BudgetException('Failed to transfer between envelopes', error: e);
    }
  }

  /// Increases a single allocation's `allocatedAmount` by [amount]. Used for
  /// CC payment envelope funding — does NOT reduce any source allocation.
  Future<void> increaseEnvelopeAllocation({
    required String allocationId,
    required int amount,
  }) async {
    if (amount <= 0) {
      throw const BudgetException('Amount must be positive');
    }
    try {
      final dto = await _apiClient.envelopes.getEnvelopeAllocation(
        allocationId,
      );
      final updated = dto.copyWith(
        allocatedAmount: dto.allocatedAmount + amount,
      );
      final result = await _apiClient.envelopes.updateEnvelopeAllocation(
        updated,
      );
      await _cacheAllocation(result);
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to update envelope allocation',
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

      return _mapTemplateFromDto(createdTemplate, createdItems);
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to create allocation template',
        error: e,
      );
    }
  }

  /// Gets all allocation templates for a [budgetId].
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
  Stream<List<AllocationTemplate>> watchAllocationTemplates(String budgetId) {
    return _localDatabase.envelopesDao
        .watchTemplatesByBudgetId(budgetId)
        .asyncMap((templates) async {
          final results = <AllocationTemplate>[];
          for (final t in templates) {
            final items = await _localDatabase.envelopesDao
                .getTemplateItemsByTemplateId(t.id);
            results.add(_mapTemplateFromLocal(t, items));
          }
          return results;
        })
        .handleError(
          (Object error) => throw BudgetException(
            'Failed to watch allocation templates',
            error: error,
          ),
        );
  }

  /// Updates an allocation template.
  Future<void> updateAllocationTemplate(AllocationTemplate template) async {
    try {
      final dto = _mapTemplateToDto(template);
      final updated = await _apiClient.envelopes.updateAllocationTemplate(dto);
      await _cacheTemplate(updated);

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
  Future<void> deleteAllocationTemplate(String id) async {
    try {
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

  /// Applies an allocation template to a budget's envelopes. Distributes
  /// [totalAmount] across the template's items by percentage; any rounding
  /// remainder goes to the first item.
  ///
  /// Existing per-envelope allocations are SUMMED with the template-derived
  /// amount (additive). Throws when the template's percentages don't sum to
  /// 100.
  Future<void> applyAllocationTemplate({
    required String templateId,
    required int totalAmount,
  }) async {
    try {
      final items = await _apiClient.envelopes.getAllocationTemplateItems(
        templateId,
      );

      if (items.isEmpty) return;

      final percentageSum = items.fold<double>(
        0,
        (sum, i) => sum + i.percentage,
      );
      if ((percentageSum - 100).abs() > 0.01) {
        throw BudgetException(
          'Template item percentages sum to $percentageSum, expected 100',
        );
      }

      final amounts = <int>[];
      var allocated = 0;
      for (var i = 0; i < items.length; i++) {
        final amount = (totalAmount * items[i].percentage / 100).round();
        amounts.add(amount);
        allocated += amount;
      }
      final remainder = totalAmount - allocated;
      amounts[0] += remainder;

      for (var i = 0; i < items.length; i++) {
        final envelopeId = items[i].envelopeId;
        final existing = await _apiClient.envelopes.getAllocationByEnvelope(
          envelopeId,
        );
        if (existing == null) {
          final dto = EnvelopeAllocationDto(
            id: '',
            envelopeId: envelopeId,
            allocatedAmount: amounts[i],
            createdAt: DateTime.now(),
          );
          final created = await _apiClient.envelopes.createEnvelopeAllocation(
            dto,
          );
          await _cacheAllocation(created);
        } else {
          final updated = await _apiClient.envelopes.updateEnvelopeAllocation(
            existing.copyWith(
              allocatedAmount: existing.allocatedAmount + amounts[i],
            ),
          );
          await _cacheAllocation(updated);
        }
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

  /// Subscribes to real-time changes on the `budgets` table filtered by
  /// [budgetId].
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
      accountSeedBalance: dto.accountSeedBalance,
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
      accountSeedBalance: row.accountSeedBalance,
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
      accountSeedBalance: budget.accountSeedBalance,
      openingDate: budget.openingDate,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
    );
  }

  static EnvelopeAllocation _mapAllocationFromDto(EnvelopeAllocationDto dto) {
    return EnvelopeAllocation(
      id: dto.id,
      envelopeId: dto.envelopeId,
      allocatedAmount: dto.allocatedAmount,
      createdAt: dto.createdAt,
    );
  }

  static EnvelopeAllocation _mapAllocationFromLocal(
    storage.EnvelopeAllocation row,
  ) {
    return EnvelopeAllocation(
      id: row.id,
      envelopeId: row.envelopeId,
      allocatedAmount: row.allocatedAmount,
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

  static AllocationTemplateDto _mapTemplateToDto(AllocationTemplate template) {
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
      accountSeedBalance: Value(dto.accountSeedBalance),
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
        allocatedAmount: Value(dto.allocatedAmount),
        createdAt: dto.createdAt,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
}
