/// Interface that table-specific repositories implement to enable sync.
///
/// Each syncable table in the app (accounts, budgets, envelopes, etc.)
/// provides a `SyncDelegate` so the `SyncRepository` can push local
/// changes to the remote server and pull remote changes to the local
/// database without knowing table-specific schemas.
abstract class SyncDelegate {
  /// The table name this delegate handles (e.g. 'accounts', 'budgets').
  String get tableName;

  /// Fetches a local record by [recordId] as a JSON map.
  ///
  /// Returns `null` if the record does not exist locally.
  Future<Map<String, dynamic>?> getLocalRecord(String recordId);

  /// Fetches a single remote record by [recordId] as a JSON map.
  ///
  /// Returns `null` if the record does not exist remotely.
  Future<Map<String, dynamic>?> getRemoteRecord(String recordId);

  /// Pushes a local record to the remote server.
  Future<void> pushToRemote(Map<String, dynamic> record);

  /// Deletes a record on the remote server.
  Future<void> deleteFromRemote(String recordId);

  /// Fetches remote records modified after [since].
  ///
  /// Returns a list of JSON maps, each containing at minimum
  /// an `id` field and an `updated_at` timestamp.
  Future<List<Map<String, dynamic>>> pullFromRemote(DateTime since);

  /// Writes a remote record to the local database.
  Future<void> writeToLocal(Map<String, dynamic> record);

  /// Deletes a record from the local database.
  Future<void> deleteFromLocal(String recordId);
}
