/// Exception thrown when a sharing operation fails.
class SharingException implements Exception {
  /// Creates a [SharingException].
  const SharingException(this.message, {this.error});

  /// The error message.
  final String message;

  /// The original error, if available.
  final Object? error;

  @override
  String toString() =>
      'SharingException: $message${error != null ? ' ($error)' : ''}';
}
