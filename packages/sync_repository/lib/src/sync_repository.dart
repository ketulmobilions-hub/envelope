// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart';
import 'package:sync_repository/src/models/models.dart';

/// Repository for data synchronization.
class SyncRepository {
  const SyncRepository({
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;

  /// Stream of the current sync status.
  Stream<SyncStatus> get syncStatus {
    // TODO(envelope): Implement sync status stream
    throw UnimplementedError();
  }

  /// Triggers an immediate sync.
  Future<void> syncNow() async {
    // TODO(envelope): Implement sync now
    throw UnimplementedError();
  }

  /// Resolves a sync conflict for a specific record.
  Future<void> resolveConflict({
    required String recordId,
    required String resolution,
  }) async {
    // TODO(envelope): Implement resolve conflict
    throw UnimplementedError();
  }

  /// Gets the number of pending changes awaiting sync.
  Future<int> getPendingChangeCount() async {
    // TODO(envelope): Implement get pending change count
    throw UnimplementedError();
  }
}
