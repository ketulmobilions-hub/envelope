import 'dart:math' show min;

import 'package:budget_repository/budget_repository.dart';
import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;

/// Repository for budget operations.
///
/// Uses a remote-first strategy: writes go to the Supabase API first,
/// then sync the result to the local Drift database. Reads stream from
/// local storage for reactive UI updates.
class BudgetRepository {
  /// Creates a [BudgetRepository].
  const BudgetRepository({
    required EnvelopeApiClient apiClient,
    required storage.AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final storage.AppDatabase _localDatabase;

  // ---------------------------------------------------------------------------
  // Budget CRUD
  // ---------------------------------------------------------------------------

  /// Creates a new budget.
  Future<Budget> createBudget({
    required String name,
    required String baseCurrency,
    required String ownerId,
    String periodType = 'monthly',
    int periodStartDay = 1,
  }) async {
    try {
      final dto = BudgetDto(
        id: '',
        ownerId: ownerId,
        name: name,
        baseCurrency: baseCurrency,
        periodType: periodType,
        periodStartDay: periodStartDay,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await _apiClient.budgets.createBudget(dto);
      await _cacheBudget(created);
      return _mapBudgetFromDto(created);
    } on EnvelopeApiException catch (e) {
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
    try {
      final dto = _mapBudgetToDto(budget);
      final updated = await _apiClient.budgets.updateBudget(dto);
      await _cacheBudget(updated);
    } on EnvelopeApiException catch (e) {
      throw BudgetException('Failed to update budget', error: e);
    }
  }

  /// Deletes a budget by its [id].
  ///
  /// Removes from the API first. Local cache removal is best-effort.
  Future<void> deleteBudget(String id) async {
    try {
      await _apiClient.budgets.deleteBudget(id);
    } on EnvelopeApiException catch (e) {
      throw BudgetException('Failed to delete budget', error: e);
    }
    try {
      await _localDatabase.budgetsDao.deleteBudget(id);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
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

  /// Fetches budgets from the API and syncs to local storage.
  Future<void> refreshBudgets(String ownerId) async {
    try {
      final remote =
          await _apiClient.budgets.getBudgetsByOwner(ownerId);
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
  }) async {
    try {
      final dto = BudgetPeriodDto(
        id: '',
        budgetId: budgetId,
        startDate: startDate,
        endDate: endDate,
        totalIncome: totalIncome,
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
      final remote =
          await _apiClient.budgets.getBudgetPeriods(budgetId);
      final companions =
          remote.map(_toBudgetPeriodCompanion).toList();
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
      final periods =
          await _localDatabase.budgetsDao.getPeriodsByBudgetId(budgetId);

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

      endDate = _addPeriod(startDate, budget.periodType)
          .subtract(const Duration(days: 1));

      return createBudgetPeriod(
        budgetId: budgetId,
        startDate: startDate,
        endDate: endDate,
      );
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException(
        'Failed to auto-create next period',
        error: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Budget-Level Allocation Operations
  // ---------------------------------------------------------------------------

  /// Calculates the "Ready to Assign" amount for a budget period.
  ///
  /// Formula: totalIncome - totalAllocated + sum(rolloverAmounts)
  Future<int> calculateReadyToAssign(String budgetPeriodId) async {
    try {
      final period = await _localDatabase.budgetsDao
          .getBudgetPeriod(budgetPeriodId);
      if (period == null) {
        throw BudgetException(
          'Budget period not found: $budgetPeriodId',
        );
      }

      final allocations = await _localDatabase.envelopesDao
          .getAllocationsByPeriodId(budgetPeriodId);

      final totalRollover = allocations.fold<int>(
        0,
        (sum, a) => sum + a.rolloverAmount,
      );

      return period.totalIncome - period.totalAllocated + totalRollover;
    } on BudgetException {
      rethrow;
    } on Exception catch (e) {
      throw BudgetException(
        'Failed to calculate ready to assign',
        error: e,
      );
    }
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

        final created = await _apiClient.envelopes
            .createEnvelopeAllocation(dto);
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
      final fromDto = await _apiClient.envelopes
          .getEnvelopeAllocation(fromAllocationId);
      final toDto = await _apiClient.envelopes
          .getEnvelopeAllocation(toAllocationId);

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

      final resultFrom = await _apiClient.envelopes
          .updateEnvelopeAllocation(updatedFrom);

      // If the second update fails, revert the first.
      EnvelopeAllocationDto resultTo;
      try {
        resultTo = await _apiClient.envelopes
            .updateEnvelopeAllocation(updatedTo);
      } on EnvelopeApiException {
        // Revert the first update.
        await _apiClient.envelopes
            .updateEnvelopeAllocation(fromDto);
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
        final created = await _apiClient.envelopes
            .createAllocationTemplateItem(itemDto);
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
      final updated = await _apiClient.envelopes
          .updateAllocationTemplate(dto);
      await _cacheTemplate(updated);

      // Replace items: remote-first — delete old from API, then local.
      final oldItems = await _apiClient.envelopes
          .getAllocationTemplateItems(template.id);
      for (final item in oldItems) {
        await _apiClient.envelopes
            .deleteAllocationTemplateItem(item.id);
      }
      await _localDatabase.envelopesDao
          .deleteTemplateItemsByTemplateId(template.id);

      for (final item in template.items) {
        final itemDto = AllocationTemplateItemDto(
          id: '',
          templateId: template.id,
          envelopeId: item.envelopeId,
          percentage: item.percentage,
        );
        final created = await _apiClient.envelopes
            .createAllocationTemplateItem(itemDto);
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
      final items = await _apiClient.envelopes
          .getAllocationTemplateItems(id);
      for (final item in items) {
        await _apiClient.envelopes
            .deleteAllocationTemplateItem(item.id);
      }
      await _apiClient.envelopes.deleteAllocationTemplate(id);
    } on EnvelopeApiException catch (e) {
      throw BudgetException(
        'Failed to delete allocation template',
        error: e,
      );
    }
    try {
      await _localDatabase.envelopesDao
          .deleteTemplateItemsByTemplateId(id);
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
      final items = await _apiClient.envelopes
          .getAllocationTemplateItems(templateId);

      if (items.isEmpty) return;

      // Validate percentages sum to 100.
      final percentageSum =
          items.fold<double>(0, (sum, i) => sum + i.percentage);
      if ((percentageSum - 100).abs() > 0.01) {
        throw BudgetException(
          'Template item percentages sum to $percentageSum, '
          'expected 100',
        );
      }

      // Check for existing allocations in the target period.
      final existing = await _localDatabase.envelopesDao
          .getAllocationsByPeriodId(budgetPeriodId);
      final existingEnvelopeIds =
          existing.map((a) => a.envelopeId).toSet();
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
        final created = await _apiClient.envelopes
            .createEnvelopeAllocation(dto);
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

      final templateCompanions =
          remoteTemplates.map(_toTemplateCompanion).toList();
      await _localDatabase.envelopesDao.batchInsertTemplates(
        templateCompanions,
        mode: InsertMode.insertOrReplace,
      );

      for (final t in remoteTemplates) {
        final items = await _apiClient.envelopes
            .getAllocationTemplateItems(t.id);
        final itemCompanions =
            items.map(_toTemplateItemCompanion).toList();
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

  static storage.AllocationTemplateItemsCompanion
      _toTemplateItemCompanion(AllocationTemplateItemDto dto) {
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
