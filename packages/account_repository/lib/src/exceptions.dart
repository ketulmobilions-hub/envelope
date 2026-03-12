/// Exception thrown when an account operation fails.
class AccountException implements Exception {
  /// Creates an [AccountException].
  const AccountException(this.message, {this.error});

  /// The error message.
  final String message;

  /// The original error, if available.
  final Object? error;

  @override
  String toString() =>
      'AccountException: $message${error != null ? ' ($error)' : ''}';
}
