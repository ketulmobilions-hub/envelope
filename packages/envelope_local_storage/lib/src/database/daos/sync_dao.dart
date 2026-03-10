import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'sync_dao.g.dart';

@DriftAccessor(tables: [SyncMetadata])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.attachedDatabase);

  Future<List<SyncMetadataData>> getAllSyncMetadata() =>
      select(syncMetadata).get();

  Stream<List<SyncMetadataData>> watchAllSyncMetadata() =>
      select(syncMetadata).watch();

  Future<SyncMetadataData?> getSyncMetadataById(String id) =>
      (select(syncMetadata)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<SyncMetadataData>> getSyncMetadataByTableName(
    String tableName,
  ) =>
      (select(syncMetadata)..where((t) => t.syncTableName.equals(tableName)))
          .get();

  Future<List<SyncMetadataData>> getSyncMetadataByStatus(String status) =>
      (select(syncMetadata)..where((t) => t.syncStatus.equals(status))).get();

  Future<List<SyncMetadataData>> getPendingSyncMetadata() =>
      (select(syncMetadata)
            ..where((t) => t.syncStatus.equals('pending')))
          .get();

  Stream<List<SyncMetadataData>> watchPendingSyncMetadata() =>
      (select(syncMetadata)
            ..where((t) => t.syncStatus.equals('pending')))
          .watch();

  Future<int> insertSyncMetadata(SyncMetadataCompanion metadata) =>
      into(syncMetadata).insert(metadata);

  Future<int> upsertSyncMetadata(SyncMetadataCompanion metadata) =>
      into(syncMetadata).insertOnConflictUpdate(metadata);

  Future<bool> updateSyncMetadata(SyncMetadataCompanion metadata) =>
      update(syncMetadata).replace(metadata);

  Future<int> deleteSyncMetadata(String id) =>
      (delete(syncMetadata)..where((t) => t.id.equals(id))).go();

  Future<int> deleteSyncMetadataByRecordId(String recordId) =>
      (delete(syncMetadata)..where((t) => t.recordId.equals(recordId))).go();
}
