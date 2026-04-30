import 'dart:async';
import 'dart:math' show max;

import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:envelope_repository/envelope_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for envelope and category group operations.
///
/// Uses a remote-first strategy: writes go to the Supabase API first,
/// then sync the result to the local Drift database. Reads stream from
/// local storage for reactive UI updates.
class EnvelopeRepository {
  /// Creates an [EnvelopeRepository].
  ///
  /// An optional [supabaseClient] can be provided for Realtime
  /// subscriptions.
  EnvelopeRepository({
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
  // Category Groups
  // ---------------------------------------------------------------------------

  /// Creates a new category group.
  Future<CategoryGroup> createCategoryGroup({
    required String budgetId,
    required String name,
  }) async {
    _beginLocalWrite();
    try {
      final dto = CategoryGroupDto(
        id: '',
        budgetId: budgetId,
        name: name,
        createdAt: DateTime.now(),
      );

      final created = await _apiClient.envelopes.createCategoryGroup(dto);
      await _cacheCategoryGroup(created);
      _endLocalWrite();
      return _mapCategoryGroupFromDto(created);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw EnvelopeException(
        'Failed to create category group',
        error: e,
      );
    }
  }

  /// Gets a category group by its [id].
  ///
  /// Tries local storage first, falls back to the API.
  Future<CategoryGroup> getCategoryGroup(String id) async {
    try {
      final local = await _localDatabase.envelopesDao.getCategoryGroup(id);
      if (local != null) {
        return _mapCategoryGroupFromLocal(local);
      }

      final remote = await _apiClient.envelopes.getCategoryGroup(id);
      await _cacheCategoryGroup(remote);
      return _mapCategoryGroupFromDto(remote);
    } on EnvelopeApiException catch (e) {
      throw EnvelopeException(
        'Failed to get category group',
        error: e,
      );
    }
  }

  /// Watches all category groups for a [budgetId].
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<CategoryGroup>> watchCategoryGroups(String budgetId) {
    return _localDatabase.envelopesDao
        .watchCategoryGroupsByBudgetId(budgetId)
        .map(
          (rows) => rows.map(_mapCategoryGroupFromLocal).toList(),
        )
        .handleError(
          (Object error) => throw EnvelopeException(
            'Failed to watch category groups',
            error: error,
          ),
        );
  }

  /// Updates a category [group].
  ///
  /// Sends the update to the API and syncs locally.
  Future<void> updateCategoryGroup(CategoryGroup group) async {
    _beginLocalWrite();
    try {
      final dto = _mapCategoryGroupToDto(group);
      final updated = await _apiClient.envelopes.updateCategoryGroup(dto);
      await _cacheCategoryGroup(updated);
      _endLocalWrite();
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw EnvelopeException(
        'Failed to update category group',
        error: e,
      );
    }
  }

  /// Deletes a category group by its [id].
  ///
  /// Removes from the API first. Local cache removal is best-effort.
  Future<void> deleteCategoryGroup(String id) async {
    _beginLocalWrite();
    try {
      await _apiClient.envelopes.deleteCategoryGroup(id);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw EnvelopeException(
        'Failed to delete category group',
        error: e,
      );
    }
    try {
      await _localDatabase.envelopesDao.deleteCategoryGroup(id);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
    _endLocalWrite();
  }

  /// Archives a category group by its [id].
  ///
  /// Sets `isArchived` to `true`, preserving all data.
  Future<void> archiveCategoryGroup(String id) async {
    try {
      final group = await getCategoryGroup(id);
      final archived = group.copyWith(isArchived: true);
      await updateCategoryGroup(archived);
    } on EnvelopeException {
      rethrow;
    } on Exception catch (e) {
      throw EnvelopeException(
        'Failed to archive category group',
        error: e,
      );
    }
  }

  /// Unarchives a category group by its [id].
  Future<void> unarchiveCategoryGroup(String id) async {
    try {
      final group = await getCategoryGroup(id);
      final unarchived = group.copyWith(isArchived: false);
      await updateCategoryGroup(unarchived);
    } on EnvelopeException {
      rethrow;
    } on Exception catch (e) {
      throw EnvelopeException(
        'Failed to unarchive category group',
        error: e,
      );
    }
  }

  /// Reorders category groups by [orderedIds].
  ///
  /// Fetches all groups first, then updates sort orders atomically.
  /// If the update fails partway through, some groups may have
  /// stale sort orders until the next refresh.
  Future<void> reorderCategoryGroups(
    List<String> orderedIds,
  ) async {
    try {
      // Fetch all DTOs first to minimize partial-failure window.
      final dtos = <CategoryGroupDto>[];
      for (final id in orderedIds) {
        final dto = await _apiClient.envelopes.getCategoryGroup(id);
        dtos.add(dto);
      }

      // Apply new sort orders.
      final results = <CategoryGroupDto>[];
      for (var i = 0; i < dtos.length; i++) {
        final updated = dtos[i].copyWith(sortOrder: i);
        final result = await _apiClient.envelopes.updateCategoryGroup(updated);
        results.add(result);
      }

      // Batch cache all results.
      final companions = results.map(_toCategoryGroupCompanion).toList();
      await _localDatabase.envelopesDao.batchInsertCategoryGroups(
        companions,
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw EnvelopeException(
        'Failed to reorder category groups',
        error: e,
      );
    }
  }

  /// Fetches category groups from the API and syncs to local storage.
  Future<void> refreshCategoryGroups(String budgetId) async {
    try {
      final remote = await _apiClient.envelopes.getCategoryGroupsByBudget(
        budgetId,
      );
      final companions = remote.map(_toCategoryGroupCompanion).toList();
      await _localDatabase.envelopesDao.batchInsertCategoryGroups(
        companions,
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw EnvelopeException(
        'Failed to refresh category groups',
        error: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Envelopes
  // ---------------------------------------------------------------------------

  /// Creates a new envelope.
  Future<Envelope> createEnvelope({
    required String categoryGroupId,
    required String budgetId,
    required String name,
    String? color,
    String? linkedAccountId,
  }) async {
    _beginLocalWrite();
    try {
      final dto = EnvelopeDto(
        id: '',
        categoryGroupId: categoryGroupId,
        budgetId: budgetId,
        name: name,
        color: color,
        linkedAccountId: linkedAccountId,
        createdAt: DateTime.now(),
      );

      final created = await _apiClient.envelopes.createEnvelope(dto);
      await _cacheEnvelope(created);
      _endLocalWrite();
      return _mapEnvelopeFromDto(created);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw EnvelopeException(
        'Failed to create envelope',
        error: e,
      );
    }
  }

  /// Returns the CC Payment envelope linked to [accountId], or null if none exists.
  Future<Envelope?> getEnvelopeByLinkedAccountId(
    String accountId,
    String budgetId,
  ) async {
    try {
      final local = await _localDatabase.envelopesDao
          .getEnvelopeByLinkedAccountId(accountId, budgetId);
      if (local != null) return _mapEnvelopeFromLocal(local);

      // Fallback: search remote envelopes for the budget and find the match.
      final remote =
          await _apiClient.envelopes.getEnvelopesByBudget(budgetId);
      final match = remote.where((e) => e.linkedAccountId == accountId);
      if (match.isEmpty) return null;
      final dto = match.first;
      await _cacheEnvelope(dto);
      return _mapEnvelopeFromDto(dto);
    } on Exception {
      return null;
    }
  }

  /// Gets an envelope by its [id].
  ///
  /// Tries local storage first, falls back to the API.
  Future<Envelope> getEnvelope(String id) async {
    try {
      final local = await _localDatabase.envelopesDao.getEnvelope(id);
      if (local != null) {
        return _mapEnvelopeFromLocal(local);
      }

      final remote = await _apiClient.envelopes.getEnvelope(id);
      await _cacheEnvelope(remote);
      return _mapEnvelopeFromDto(remote);
    } on EnvelopeApiException catch (e) {
      throw EnvelopeException(
        'Failed to get envelope',
        error: e,
      );
    }
  }

  /// Watches all envelopes for a [budgetId].
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<Envelope>> watchEnvelopes(String budgetId) {
    return _localDatabase.envelopesDao
        .watchEnvelopesByBudgetId(budgetId)
        .map(
          (rows) => rows.map(_mapEnvelopeFromLocal).toList(),
        )
        .handleError(
          (Object error) => throw EnvelopeException(
            'Failed to watch envelopes',
            error: error,
          ),
        );
  }

  /// Watches envelopes for a specific [categoryGroupId].
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<Envelope>> watchEnvelopesByCategoryGroup(
    String categoryGroupId,
  ) {
    return _localDatabase.envelopesDao
        .watchEnvelopesByCategoryGroupId(categoryGroupId)
        .map(
          (rows) => rows.map(_mapEnvelopeFromLocal).toList(),
        )
        .handleError(
          (Object error) => throw EnvelopeException(
            'Failed to watch envelopes by category group',
            error: error,
          ),
        );
  }

  /// Updates an [envelope].
  ///
  /// Sends the update to the API and syncs locally.
  Future<void> updateEnvelope(Envelope envelope) async {
    _beginLocalWrite();
    try {
      final dto = _mapEnvelopeToDto(envelope);
      final updated = await _apiClient.envelopes.updateEnvelope(dto);
      await _cacheEnvelope(updated);
      _endLocalWrite();
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw EnvelopeException(
        'Failed to update envelope',
        error: e,
      );
    }
  }

  /// Soft-deletes an envelope by its [id].
  ///
  /// Sets `deleted_at` on the API. Local cache removal is best-effort.
  Future<void> deleteEnvelope(String id) async {
    _beginLocalWrite();
    try {
      await _apiClient.envelopes.deleteEnvelope(id);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw EnvelopeException(
        'Failed to delete envelope',
        error: e,
      );
    }
    try {
      await _localDatabase.envelopesDao.deleteEnvelope(id);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
    _endLocalWrite();
  }

  /// Restores a soft-deleted envelope by clearing `deleted_at`.
  Future<void> restoreEnvelope(String id) async {
    _beginLocalWrite();
    try {
      await _apiClient.envelopes.restoreEnvelope(id);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw EnvelopeException(
        'Failed to restore envelope',
        error: e,
      );
    }
    _endLocalWrite();
  }

  /// Archives an envelope by its [id].
  ///
  /// Sets `isArchived` to `true`, preserving all data.
  Future<void> archiveEnvelope(String id) async {
    try {
      final envelope = await getEnvelope(id);
      final archived = envelope.copyWith(isArchived: true);
      await updateEnvelope(archived);
    } on EnvelopeException {
      rethrow;
    } on Exception catch (e) {
      throw EnvelopeException(
        'Failed to archive envelope',
        error: e,
      );
    }
  }

  /// Unarchives an envelope by its [id].
  Future<void> unarchiveEnvelope(String id) async {
    try {
      final envelope = await getEnvelope(id);
      final unarchived = envelope.copyWith(isArchived: false);
      await updateEnvelope(unarchived);
    } on EnvelopeException {
      rethrow;
    } on Exception catch (e) {
      throw EnvelopeException(
        'Failed to unarchive envelope',
        error: e,
      );
    }
  }

  /// Moves an envelope to a new category group.
  Future<void> moveEnvelope({
    required String envelopeId,
    required String newCategoryGroupId,
  }) async {
    try {
      final envelope = await getEnvelope(envelopeId);
      final moved = envelope.copyWith(
        categoryGroupId: newCategoryGroupId,
      );
      await updateEnvelope(moved);
    } on EnvelopeException {
      rethrow;
    } on Exception catch (e) {
      throw EnvelopeException(
        'Failed to move envelope',
        error: e,
      );
    }
  }

  /// Reorders envelopes by [orderedIds].
  ///
  /// Fetches all envelopes first, then updates sort orders.
  /// If the update fails partway through, some envelopes may have
  /// stale sort orders until the next refresh.
  Future<void> reorderEnvelopes(List<String> orderedIds) async {
    try {
      // Fetch all DTOs first to minimize partial-failure window.
      final dtos = <EnvelopeDto>[];
      for (final id in orderedIds) {
        final dto = await _apiClient.envelopes.getEnvelope(id);
        dtos.add(dto);
      }

      // Apply new sort orders.
      final results = <EnvelopeDto>[];
      for (var i = 0; i < dtos.length; i++) {
        final updated = dtos[i].copyWith(sortOrder: i);
        final result = await _apiClient.envelopes.updateEnvelope(updated);
        results.add(result);
      }

      // Batch cache all results.
      final companions = results.map(_toEnvelopeCompanion).toList();
      await _localDatabase.envelopesDao.batchInsertEnvelopes(
        companions,
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw EnvelopeException(
        'Failed to reorder envelopes',
        error: e,
      );
    }
  }

  /// Fetches envelopes from the API and syncs to local storage.
  Future<void> refreshEnvelopes(String budgetId) async {
    try {
      final remote = await _apiClient.envelopes.getEnvelopesByBudget(budgetId);
      final companions = remote.map(_toEnvelopeCompanion).toList();
      await _localDatabase.envelopesDao.batchInsertEnvelopes(
        companions,
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw EnvelopeException(
        'Failed to refresh envelopes',
        error: e,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Allocations
  // ---------------------------------------------------------------------------

  /// Creates an allocation for an envelope in a budget period.
  Future<EnvelopeAllocation> allocate({
    required String envelopeId,
    required String budgetPeriodId,
    required int amount,
  }) async {
    _beginLocalWrite();
    try {
      final dto = EnvelopeAllocationDto(
        id: '',
        envelopeId: envelopeId,
        budgetPeriodId: budgetPeriodId,
        allocatedAmount: amount,
        createdAt: DateTime.now(),
      );

      final created = await _apiClient.envelopes.createEnvelopeAllocation(dto);
      await _cacheAllocation(created);
      _endLocalWrite();
      return _mapAllocationFromDto(created);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw EnvelopeException(
        'Failed to create allocation',
        error: e,
      );
    }
  }

  /// Ensures a \$0 allocation record exists for [envelopeId] in [budgetPeriodId].
  ///
  /// No-op if one already exists. Called before creating expense transactions
  /// so the DB spent-amount trigger has a row to update.
  Future<void> ensureAllocation({
    required String envelopeId,
    required String budgetPeriodId,
  }) async {
    final existing = await _localDatabase.envelopesDao
        .getAllocationByEnvelopeAndPeriod(envelopeId, budgetPeriodId);
    if (existing != null) return;
    await allocate(
      envelopeId: envelopeId,
      budgetPeriodId: budgetPeriodId,
      amount: 0,
    );
  }

  /// Gets the allocation for [envelopeId] in [budgetPeriodId], or null.
  Future<EnvelopeAllocation?> getEnvelopeAllocationByEnvelopeAndPeriod({
    required String envelopeId,
    required String budgetPeriodId,
  }) async {
    final local = await _localDatabase.envelopesDao
        .getAllocationByEnvelopeAndPeriod(envelopeId, budgetPeriodId);
    if (local != null) return _mapAllocationFromLocal(local);
    return null;
  }

  /// Watches all allocations for a [budgetPeriodId].
  ///
  /// Returns a reactive stream from local storage.
  Stream<List<EnvelopeAllocation>> watchAllocations(
    String budgetPeriodId,
  ) {
    return _localDatabase.envelopesDao
        .watchAllocationsByPeriodId(budgetPeriodId)
        .map(
          (rows) => rows.map(_mapAllocationFromLocal).toList(),
        )
        .handleError(
          (Object error) => throw EnvelopeException(
            'Failed to watch allocations',
            error: error,
          ),
        );
  }

  /// Updates an [allocation].
  ///
  /// Sends the update to the API and syncs locally.
  Future<void> updateAllocation(
    EnvelopeAllocation allocation,
  ) async {
    _beginLocalWrite();
    try {
      final dto = _mapAllocationToDto(allocation);
      final updated = await _apiClient.envelopes.updateEnvelopeAllocation(dto);
      await _cacheAllocation(updated);
      _endLocalWrite();
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw EnvelopeException(
        'Failed to update allocation',
        error: e,
      );
    }
  }

  /// Deletes an allocation by its [id].
  ///
  /// Removes from the API first. Local cache removal is best-effort.
  Future<void> deleteAllocation(String id) async {
    _beginLocalWrite();
    try {
      await _apiClient.envelopes.deleteEnvelopeAllocation(id);
    } on EnvelopeApiException catch (e) {
      _endLocalWrite();
      throw EnvelopeException(
        'Failed to delete allocation',
        error: e,
      );
    }
    try {
      await _localDatabase.envelopesDao.deleteAllocation(id);
    } on Exception {
      // Stale local entry will be cleaned up on next refresh.
    }
    _endLocalWrite();
  }

  /// Immediately decrements `spentAmount` in local SQLite for the allocation
  /// matching [envelopeId] + the budget period that contains [date] in
  /// [budgetId]. No API call is made — this is an optimistic update to give
  /// instant UI feedback after a transaction is deleted.
  Future<void> decrementLocalSpentAmount({
    required String envelopeId,
    required String budgetId,
    required DateTime date,
    required int amount,
  }) async {
    try {
      // Find the budget period that contains this date (local DB only).
      final periods = await _localDatabase.budgetsDao
          .getPeriodsByBudgetId(budgetId);
      storage.BudgetPeriod? period;
      for (final p in periods) {
        if (!p.startDate.isAfter(date) && !p.endDate.isBefore(date)) {
          period = p;
          break;
        }
      }
      if (period == null) return;

      // Find the local allocation for this envelope in that period.
      final allocs = await _localDatabase.envelopesDao
          .getAllocationsByPeriodId(period.id);
      storage.EnvelopeAllocation? alloc;
      for (final a in allocs) {
        if (a.envelopeId == envelopeId) {
          alloc = a;
          break;
        }
      }
      if (alloc == null) return;

      // Floor at zero and write back to local DB — instant UI update.
      final newSpent = max(0, alloc.spentAmount - amount);
      await _localDatabase.envelopesDao.updateAllocation(
        storage.EnvelopeAllocationsCompanion(
          id: Value(alloc.id),
          envelopeId: Value(alloc.envelopeId),
          budgetPeriodId: Value(alloc.budgetPeriodId),
          allocatedAmount: Value(alloc.allocatedAmount),
          spentAmount: Value(newSpent),
          rolloverAmount: Value(alloc.rolloverAmount),
          createdAt: Value(alloc.createdAt),
        ),
      );
    } on Exception {
      // Best-effort — the async refreshAllocations call will correct any
      // discrepancy on the next round-trip.
    }
  }

  /// Immediately increments `spentAmount` in local SQLite for the allocation
  /// matching [envelopeId] + the budget period that contains [date] in
  /// [budgetId]. No API call is made — this is an optimistic update to give
  /// instant UI feedback after an expense transaction is created.
  Future<void> incrementLocalSpentAmount({
    required String envelopeId,
    required String budgetId,
    required DateTime date,
    required int amount,
  }) async {
    try {
      final periods = await _localDatabase.budgetsDao
          .getPeriodsByBudgetId(budgetId);
      storage.BudgetPeriod? period;
      for (final p in periods) {
        if (!p.startDate.isAfter(date) && !p.endDate.isBefore(date)) {
          period = p;
          break;
        }
      }
      if (period == null) return;

      final allocs = await _localDatabase.envelopesDao
          .getAllocationsByPeriodId(period.id);
      storage.EnvelopeAllocation? alloc;
      for (final a in allocs) {
        if (a.envelopeId == envelopeId) {
          alloc = a;
          break;
        }
      }
      if (alloc == null) return;

      await _localDatabase.envelopesDao.updateAllocation(
        storage.EnvelopeAllocationsCompanion(
          id: Value(alloc.id),
          envelopeId: Value(alloc.envelopeId),
          budgetPeriodId: Value(alloc.budgetPeriodId),
          allocatedAmount: Value(alloc.allocatedAmount),
          spentAmount: Value(alloc.spentAmount + amount),
          rolloverAmount: Value(alloc.rolloverAmount),
          createdAt: Value(alloc.createdAt),
        ),
      );
    } on Exception {
      // Best-effort — refreshAllocations will correct any discrepancy.
    }
  }

  /// Computes the available balance for a CC Payment envelope using
  /// transaction history instead of allocated_amount manipulation.
  ///
  /// Formula: allocated + CC charges in period - CC payments in period + rollover
  Future<int> calculateCCPaymentAvailable({
    required EnvelopeAllocation? allocation,
    required String ccAccountId,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    final allocated = allocation?.allocatedAmount ?? 0;
    final rollover = allocation?.rolloverAmount ?? 0;

    final txns = await _localDatabase.transactionsDao
        .getTransactionsByAccountId(ccAccountId);

    final inPeriod = txns.where(
      (t) =>
          t.deletedAt == null &&
          !t.date.isBefore(periodStart) &&
          !t.date.isAfter(periodEnd),
    );

    final charges = inPeriod
        .where((t) => t.type == 'expense')
        .fold(0, (sum, t) => sum + t.amount);

    final payments = inPeriod
        .where((t) => t.type == 'transfer' && t.amount > 0)
        .fold(0, (sum, t) => sum + t.amount);

    return allocated + charges - payments + rollover;
  }

  /// Fetches allocations from the API and syncs to local storage.
  Future<void> refreshAllocations(String budgetPeriodId) async {
    try {
      final remote = await _apiClient.envelopes.getAllocationsByPeriod(
        budgetPeriodId,
      );
      final companions = remote.map(_toAllocationCompanion).toList();
      await _localDatabase.envelopesDao.batchInsertAllocations(
        companions,
        mode: InsertMode.insertOrReplace,
      );
    } on EnvelopeApiException catch (e) {
      throw EnvelopeException(
        'Failed to refresh allocations',
        error: e,
      );
    }
  }

  /// Calculates the rollover amount for an envelope.
  ///
  /// Rollover = allocatedAmount - spentAmount + previous rolloverAmount.
  /// A positive value means unspent funds carry forward.
  /// A negative value means overspending carries forward as debt.
  static int calculateRollover(EnvelopeAllocation allocation) {
    return allocation.allocatedAmount -
        allocation.spentAmount +
        allocation.rolloverAmount;
  }

  // ---------------------------------------------------------------------------
  // Realtime
  // ---------------------------------------------------------------------------

  /// Subscribes to real-time changes on the `envelopes` table
  /// filtered by [budgetId].
  RealtimeChannel? subscribeToEnvelopeChanges(String budgetId) {
    final client = _supabaseClient;
    if (client == null) return null;

    final channel = client
        .channel('envelopes:$budgetId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'envelopes',
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
                    final dto = EnvelopeDto.fromJson(newRecord);
                    // Soft-deleted envelopes must be removed locally, not cached.
                    if (newRecord['deleted_at'] != null) {
                      await _localDatabase.envelopesDao.deleteEnvelope(dto.id);
                    } else {
                      await _cacheEnvelope(dto);
                    }
                    if (_localWriteCount == 0) {
                      _remoteChangeController.add(null);
                    }
                  }
                case PostgresChangeEvent.delete:
                  if (oldRecord.isNotEmpty) {
                    final id = oldRecord['id'] as String?;
                    if (id != null) {
                      await _localDatabase.envelopesDao.deleteEnvelope(id);
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

  /// Subscribes to real-time changes on the `category_groups` table
  /// filtered by [budgetId].
  RealtimeChannel? subscribeToCategoryGroupChanges(String budgetId) {
    final client = _supabaseClient;
    if (client == null) return null;

    final channel = client
        .channel('category_groups:$budgetId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'category_groups',
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
                    final dto = CategoryGroupDto.fromJson(newRecord);
                    await _cacheCategoryGroup(dto);
                    if (_localWriteCount == 0) {
                      _remoteChangeController.add(null);
                    }
                  }
                case PostgresChangeEvent.delete:
                  if (oldRecord.isNotEmpty) {
                    final id = oldRecord['id'] as String?;
                    if (id != null) {
                      await _localDatabase.envelopesDao.deleteCategoryGroup(id);
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

  /// Subscribes to real-time changes on the `envelope_allocations` table
  /// filtered by [budgetPeriodId].
  ///
  /// Note: `envelope_allocations` has no `budget_id` column, so must
  /// filter by `budget_period_id`.
  RealtimeChannel? subscribeToAllocationChanges(String budgetPeriodId) {
    final client = _supabaseClient;
    if (client == null) return null;

    final channel = client
        .channel('envelope_allocations:$budgetPeriodId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'envelope_allocations',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'budget_period_id',
            value: budgetPeriodId,
          ),
          callback: (payload) async {
            try {
              final newRecord = payload.newRecord;
              final oldRecord = payload.oldRecord;

              switch (payload.eventType) {
                case PostgresChangeEvent.insert:
                case PostgresChangeEvent.update:
                  if (newRecord.isNotEmpty) {
                    final dto = EnvelopeAllocationDto.fromJson(newRecord);
                    await _cacheAllocation(dto);
                    if (_localWriteCount == 0) {
                      _remoteChangeController.add(null);
                    }
                  }
                case PostgresChangeEvent.delete:
                  if (oldRecord.isNotEmpty) {
                    final id = oldRecord['id'] as String?;
                    if (id != null) {
                      await _localDatabase.envelopesDao.deleteAllocation(id);
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

  void beginExternalWrite() => _beginLocalWrite();

  void endExternalWrite() => _endLocalWrite();

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

  static CategoryGroup _mapCategoryGroupFromDto(
    CategoryGroupDto dto,
  ) {
    return CategoryGroup(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
      sortOrder: dto.sortOrder,
      isDefault: dto.isDefault,
      isArchived: dto.isArchived,
      createdAt: dto.createdAt,
    );
  }

  static CategoryGroup _mapCategoryGroupFromLocal(
    storage.CategoryGroup row,
  ) {
    return CategoryGroup(
      id: row.id,
      budgetId: row.budgetId,
      name: row.name,
      sortOrder: row.sortOrder,
      isDefault: row.isDefault,
      isArchived: row.isArchived,
      createdAt: row.createdAt,
    );
  }

  static CategoryGroupDto _mapCategoryGroupToDto(
    CategoryGroup group,
  ) {
    return CategoryGroupDto(
      id: group.id,
      budgetId: group.budgetId,
      name: group.name,
      sortOrder: group.sortOrder,
      isDefault: group.isDefault,
      isArchived: group.isArchived,
      createdAt: group.createdAt,
    );
  }

  static Envelope _mapEnvelopeFromDto(EnvelopeDto dto) {
    return Envelope(
      id: dto.id,
      categoryGroupId: dto.categoryGroupId,
      budgetId: dto.budgetId,
      name: dto.name,
      sortOrder: dto.sortOrder,
      isArchived: dto.isArchived,
      color: dto.color,
      linkedAccountId: dto.linkedAccountId,
      createdAt: dto.createdAt,
    );
  }

  static Envelope _mapEnvelopeFromLocal(storage.Envelope row) {
    return Envelope(
      id: row.id,
      categoryGroupId: row.categoryGroupId,
      budgetId: row.budgetId,
      name: row.name,
      sortOrder: row.sortOrder,
      isArchived: row.isArchived,
      color: row.color,
      linkedAccountId: row.linkedAccountId,
      createdAt: row.createdAt,
    );
  }

  static EnvelopeDto _mapEnvelopeToDto(Envelope envelope) {
    return EnvelopeDto(
      id: envelope.id,
      categoryGroupId: envelope.categoryGroupId,
      budgetId: envelope.budgetId,
      name: envelope.name,
      sortOrder: envelope.sortOrder,
      isArchived: envelope.isArchived,
      color: envelope.color,
      linkedAccountId: envelope.linkedAccountId,
      createdAt: envelope.createdAt,
    );
  }

  static EnvelopeAllocation _mapAllocationFromDto(
    EnvelopeAllocationDto dto,
  ) {
    return EnvelopeAllocation(
      id: dto.id,
      envelopeId: dto.envelopeId,
      budgetPeriodId: dto.budgetPeriodId,
      allocatedAmount: dto.allocatedAmount,
      spentAmount: dto.spentAmount,
      rolloverAmount: dto.rolloverAmount,
      createdAt: dto.createdAt,
    );
  }

  static EnvelopeAllocation _mapAllocationFromLocal(
    storage.EnvelopeAllocation row,
  ) {
    return EnvelopeAllocation(
      id: row.id,
      envelopeId: row.envelopeId,
      budgetPeriodId: row.budgetPeriodId,
      allocatedAmount: row.allocatedAmount,
      spentAmount: row.spentAmount,
      rolloverAmount: row.rolloverAmount,
      createdAt: row.createdAt,
    );
  }

  static EnvelopeAllocationDto _mapAllocationToDto(
    EnvelopeAllocation allocation,
  ) {
    return EnvelopeAllocationDto(
      id: allocation.id,
      envelopeId: allocation.envelopeId,
      budgetPeriodId: allocation.budgetPeriodId,
      allocatedAmount: allocation.allocatedAmount,
      spentAmount: allocation.spentAmount,
      rolloverAmount: allocation.rolloverAmount,
      createdAt: allocation.createdAt,
    );
  }

  // ---------------------------------------------------------------------------
  // Private — Local cache helpers
  // ---------------------------------------------------------------------------

  static storage.CategoryGroupsCompanion _toCategoryGroupCompanion(
    CategoryGroupDto dto,
  ) {
    return storage.CategoryGroupsCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      name: dto.name,
      sortOrder: Value(dto.sortOrder),
      isDefault: Value(dto.isDefault),
      isArchived: Value(dto.isArchived),
      createdAt: dto.createdAt,
    );
  }

  Future<void> _cacheCategoryGroup(CategoryGroupDto dto) async {
    await _localDatabase.envelopesDao.insertCategoryGroup(
      _toCategoryGroupCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  static storage.EnvelopesCompanion _toEnvelopeCompanion(
    EnvelopeDto dto,
  ) {
    return storage.EnvelopesCompanion.insert(
      id: dto.id,
      categoryGroupId: dto.categoryGroupId,
      budgetId: dto.budgetId,
      name: dto.name,
      sortOrder: Value(dto.sortOrder),
      isArchived: Value(dto.isArchived),
      color: Value(dto.color),
      linkedAccountId: Value(dto.linkedAccountId),
      createdAt: dto.createdAt,
    );
  }

  Future<void> _cacheEnvelope(EnvelopeDto dto) async {
    await _localDatabase.envelopesDao.insertEnvelope(
      _toEnvelopeCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }

  static storage.EnvelopeAllocationsCompanion _toAllocationCompanion(
    EnvelopeAllocationDto dto,
  ) {
    return storage.EnvelopeAllocationsCompanion.insert(
      id: dto.id,
      envelopeId: dto.envelopeId,
      budgetPeriodId: dto.budgetPeriodId,
      allocatedAmount: Value(dto.allocatedAmount),
      spentAmount: Value(dto.spentAmount),
      rolloverAmount: Value(dto.rolloverAmount),
      createdAt: dto.createdAt,
    );
  }

  Future<void> _cacheAllocation(EnvelopeAllocationDto dto) async {
    await _localDatabase.envelopesDao.insertAllocation(
      _toAllocationCompanion(dto),
      mode: InsertMode.insertOrReplace,
    );
  }
}
