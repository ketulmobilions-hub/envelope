/// Base exception for sync operations.
sealed class SyncException implements Exception {
  const SyncException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Thrown when pushing local changes to the remote server fails.
class SyncPushException extends SyncException {
  const SyncPushException(super.message);
}

/// Thrown when pulling remote changes fails.
class SyncPullException extends SyncException {
  const SyncPullException(super.message);
}

/// Thrown when a sync conflict cannot be resolved automatically.
class SyncConflictException extends SyncException {
  const SyncConflictException(super.message);
}
