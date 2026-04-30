import 'dart:async';

import 'package:drift/drift.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart';
import 'package:sync_repository/src/exceptions.dart';
import 'package:sync_repository/src/models/models.dart';
import 'package:sync_repository/src/sync_delegate.dart';

/// Sync metadata status constants.
abstract final class SyncMetadataStatus {
  static const String pending = 'pending';
  static const String synced = 'synced';
  static const String conflict = 'conflict';
}

/// Typedef for a function that returns the current time.
typedef Clock = DateTime Function();

/// Repository for offline-first data synchronization.
///
/// All writes go to Drift first, are queued via sync_metadata, and pushed
/// to Supabase when online. Reads always come from the local Drift
/// database (single source of truth). Conflicts are resolved using
/// last-write-wins based on `updated_at` timestamps. When timestamps
/// are equal, the record is marked as `conflict` for manual resolution.
class SyncRepository {
  SyncRepository({
    required AppDatabase localDatabase,
    required String deviceId,
    Clock? clock,
  }) : _localDatabase = localDatabase,
       _deviceId = deviceId,
       _clock = clock ?? DateTime.now;

  final AppDatabase _localDatabase;
  final String _deviceId;
  final Clock _clock;

  final _delegates = <String, SyncDelegate>{};
  final _statusController = StreamController<SyncStatus>.broadcast();
  SyncStatus _status = const SyncStatus();
  bool _isSyncing = false;
  bool _isDisposed = false;

  /// The current device identifier.
  String get deviceId => _deviceId;

  /// Stream of the current sync status.
  Stream<SyncStatus> get syncStatus async* {
    yield _status;
    yield* _statusController.stream;
  }

  /// The current sync status snapshot.
  SyncStatus get currentStatus => _status;

  /// Registers a [SyncDelegate] for a specific table.
  ///
  /// Once registered, the sync engine can push/pull data for that table.
  void registerDelegate(SyncDelegate delegate) {
    _delegates[delegate.tableName] = delegate;
  }

  /// Unregisters the delegate for [tableName].
  void unregisterDelegate(String tableName) {
    _delegates.remove(tableName);
  }

  /// Records a local change that needs to be synced.
  ///
  /// Called by other repositories after writing to the local database.
  Future<void> trackChange({
    required String tableName,
    required String recordId,
    bool isDeleted = false,
  }) async {
    final metadataId = '${tableName}_${recordId}_$_deviceId';
    await _localDatabase.syncDao.upsertSyncMetadata(
      SyncMetadataCompanion(
        id: Value(metadataId),
        syncTableName: Value(tableName),
        recordId: Value(recordId),
        lastModified: Value(_clock()),
        isDeleted: Value(isDeleted),
        deviceId: Value(_deviceId),
        syncStatus: const Value(SyncMetadataStatus.pending),
      ),
    );
    final count = await getPendingChangeCount();
    _emitStatus(_status.copyWith(pendingChanges: count));
  }

  /// Triggers an immediate full sync cycle: push then pull.
  ///
  /// Returns silently if a sync is already in progress or disposed.
  Future<void> syncNow() async {
    if (_isSyncing || _isDisposed) return;
    _isSyncing = true;

    _emitStatus(
      _status.copyWith(state: SyncState.syncing, errorMessage: null),
    );

    try {
      // Capture the pull timestamp before starting, so changes that
      // arrive during sync are not missed on the next pull.
      final pullSince =
          _status.lastSyncedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

      await _pushPendingChanges();
      await _pullRemoteChanges(since: pullSince);
      await _purgeDeletedRecords();

      final pendingCount = await getPendingChangeCount();
      _emitStatus(
        _status.copyWith(
          state: pendingCount > 0 ? SyncState.idle : SyncState.synced,
          pendingChanges: pendingCount,
          lastSyncedAt: _clock(),
        ),
      );
    } on SyncException catch (e) {
      _emitStatus(
        _status.copyWith(
          state: SyncState.error,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      _emitStatus(
        _status.copyWith(
          state: SyncState.error,
          errorMessage: 'Sync failed: $e',
        ),
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Returns the number of pending changes awaiting sync.
  Future<int> getPendingChangeCount() async {
    final pending = await _localDatabase.syncDao.getPendingSyncMetadata();
    return pending.length;
  }

  /// Stream of pending change count updates.
  Stream<int> watchPendingChangeCount() {
    return _localDatabase.syncDao.watchPendingSyncMetadata().map(
      (items) => items.length,
    );
  }

  /// Resolves a sync conflict for a specific record.
  ///
  /// [resolution] must be either `'local'` or `'remote'`.
  Future<void> resolveConflict({
    required String recordId,
    required String resolution,
  }) async {
    final metadata = await _localDatabase.syncDao.getSyncMetadataById(recordId);

    if (metadata == null) {
      throw const SyncConflictException(
        'No sync metadata found for record.',
      );
    }

    if (resolution == 'local') {
      // Keep local version — mark as pending so it gets pushed
      await _localDatabase.syncDao.upsertSyncMetadata(
        SyncMetadataCompanion(
          id: Value(metadata.id),
          syncTableName: Value(metadata.syncTableName),
          recordId: Value(metadata.recordId),
          lastModified: Value(_clock()),
          isDeleted: Value(metadata.isDeleted),
          deviceId: Value(metadata.deviceId),
          syncStatus: const Value(SyncMetadataStatus.pending),
        ),
      );
    } else if (resolution == 'remote') {
      // Accept remote version — fetch the single record and apply it
      final delegate = _delegates[metadata.syncTableName];
      if (delegate != null) {
        final remoteRecord = await delegate.getRemoteRecord(metadata.recordId);
        if (remoteRecord != null) {
          await delegate.writeToLocal(remoteRecord);
        }
      }
      await _markSynced(metadata.id);
    } else {
      throw const SyncConflictException(
        "Resolution must be 'local' or 'remote'.",
      );
    }
  }

  /// Cleans up resources.
  Future<void> dispose() async {
    _isDisposed = true;
    await _statusController.close();
  }

  // -- Private helpers --

  void _emitStatus(SyncStatus status) {
    _status = status;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  Future<void> _pushPendingChanges() async {
    final pendingItems = await _localDatabase.syncDao.getPendingSyncMetadata();

    for (final item in pendingItems) {
      final delegate = _delegates[item.syncTableName];
      if (delegate == null) continue;

      try {
        if (item.isDeleted) {
          await delegate.deleteFromRemote(item.recordId);
        } else {
          final localRecord = await delegate.getLocalRecord(item.recordId);
          if (localRecord == null) continue;
          await delegate.pushToRemote(localRecord);
        }
        await _markSynced(item.id);
      } on Exception catch (e) {
        // Mark the individual record as errored and continue
        await _markError(
          item.id,
          'Push failed: $e',
        );
      }
    }
  }

  Future<void> _pullRemoteChanges({required DateTime since}) async {
    for (final delegate in _delegates.values) {
      try {
        final remoteRecords = await delegate.pullFromRemote(since);

        for (final record in remoteRecords) {
          final recordId = record['id'] as String?;
          if (recordId == null) continue;

          await _applyRemoteRecord(
            delegate: delegate,
            record: record,
            recordId: recordId,
          );
        }
      } on Exception catch (e) {
        // Log the error but continue pulling from other delegates
        _emitStatus(
          _status.copyWith(
            errorMessage:
                'Pull warning for '
                '${delegate.tableName}: $e',
          ),
        );
      }
    }
  }

  Future<void> _applyRemoteRecord({
    required SyncDelegate delegate,
    required Map<String, dynamic> record,
    required String recordId,
  }) async {
    final metadataId = '${delegate.tableName}_${recordId}_$_deviceId';
    final localMeta = await _localDatabase.syncDao.getSyncMetadataById(
      metadataId,
    );

    if (localMeta != null &&
        localMeta.syncStatus == SyncMetadataStatus.pending) {
      // Conflict: both local and remote changed since last sync.
      // Last-write-wins using timestamps.
      final remoteUpdatedAt = _parseTimestamp(record['updated_at']);

      if (remoteUpdatedAt.isAfter(localMeta.lastModified)) {
        // Remote wins — overwrite local
        await _applyRemoteToLocal(delegate, record, recordId);
        await _markSynced(localMeta.id);
      } else if (remoteUpdatedAt.isAtSameMomentAs(
        localMeta.lastModified,
      )) {
        // Exact same timestamp — mark as conflict for manual resolution
        await _markConflict(localMeta.id);
      }
      // Otherwise local wins — pending change stays, pushed next sync
    } else {
      // No conflict — apply remote change and track as synced
      await _applyRemoteToLocal(delegate, record, recordId);
      await _trackSyncedRecord(
        tableName: delegate.tableName,
        recordId: recordId,
        isDeleted: record['is_deleted'] == true,
      );
    }
  }

  Future<void> _applyRemoteToLocal(
    SyncDelegate delegate,
    Map<String, dynamic> record,
    String recordId,
  ) async {
    final isDeleted = record['is_deleted'] == true;
    if (isDeleted) {
      await delegate.deleteFromLocal(recordId);
    } else {
      await delegate.writeToLocal(record);
    }
  }

  DateTime _parseTimestamp(Object? value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  Future<void> _purgeDeletedRecords() async {
    final allMetadata = await _localDatabase.syncDao.getAllSyncMetadata();
    final syncedDeletes = allMetadata.where(
      (m) => m.isDeleted && m.syncStatus == SyncMetadataStatus.synced,
    );

    for (final meta in syncedDeletes) {
      final delegate = _delegates[meta.syncTableName];
      if (delegate != null) {
        await delegate.deleteFromLocal(meta.recordId);
      }
      await _localDatabase.syncDao.deleteSyncMetadata(meta.id);
    }
  }

  Future<void> _markSynced(String metadataId) async {
    final existing = await _localDatabase.syncDao.getSyncMetadataById(
      metadataId,
    );
    if (existing == null) return;

    await _localDatabase.syncDao.upsertSyncMetadata(
      SyncMetadataCompanion(
        id: Value(existing.id),
        syncTableName: Value(existing.syncTableName),
        recordId: Value(existing.recordId),
        lastModified: Value(existing.lastModified),
        isDeleted: Value(existing.isDeleted),
        deviceId: Value(existing.deviceId),
        syncStatus: const Value(SyncMetadataStatus.synced),
      ),
    );
  }

  Future<void> _markConflict(String metadataId) async {
    final existing = await _localDatabase.syncDao.getSyncMetadataById(
      metadataId,
    );
    if (existing == null) return;

    await _localDatabase.syncDao.upsertSyncMetadata(
      SyncMetadataCompanion(
        id: Value(existing.id),
        syncTableName: Value(existing.syncTableName),
        recordId: Value(existing.recordId),
        lastModified: Value(existing.lastModified),
        isDeleted: Value(existing.isDeleted),
        deviceId: Value(existing.deviceId),
        syncStatus: const Value(SyncMetadataStatus.conflict),
      ),
    );
  }

  Future<void> _markError(String metadataId, String message) async {
    final existing = await _localDatabase.syncDao.getSyncMetadataById(
      metadataId,
    );
    if (existing == null) return;

    // Keep as pending so it retries on next sync
    await _localDatabase.syncDao.upsertSyncMetadata(
      SyncMetadataCompanion(
        id: Value(existing.id),
        syncTableName: Value(existing.syncTableName),
        recordId: Value(existing.recordId),
        lastModified: Value(existing.lastModified),
        isDeleted: Value(existing.isDeleted),
        deviceId: Value(existing.deviceId),
        syncStatus: const Value(SyncMetadataStatus.pending),
      ),
    );
  }

  Future<void> _trackSyncedRecord({
    required String tableName,
    required String recordId,
    required bool isDeleted,
  }) async {
    final metadataId = '${tableName}_${recordId}_$_deviceId';
    await _localDatabase.syncDao.upsertSyncMetadata(
      SyncMetadataCompanion(
        id: Value(metadataId),
        syncTableName: Value(tableName),
        recordId: Value(recordId),
        lastModified: Value(_clock()),
        isDeleted: Value(isDeleted),
        deviceId: Value(_deviceId),
        syncStatus: const Value(SyncMetadataStatus.synced),
      ),
    );
  }
}
