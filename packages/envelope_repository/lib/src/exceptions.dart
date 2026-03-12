/// Exception thrown when an envelope operation fails.
class EnvelopeException implements Exception {
  /// Creates an [EnvelopeException].
  const EnvelopeException(this.message, {this.error});

  /// The error message.
  final String message;

  /// The original error, if available.
  final Object? error;

  @override
  String toString() =>
      'EnvelopeException: $message${error != null ? ' ($error)' : ''}';
}
