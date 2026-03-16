/// Exception thrown when a transaction operation fails.
class TransactionException implements Exception {
  /// Creates a [TransactionException].
  const TransactionException(this.message, {this.error});

  /// The error message.
  final String message;

  /// The original error, if available.
  final Object? error;

  @override
  String toString() =>
      'TransactionException: $message${error != null ? ' ($error)' : ''}';
}
