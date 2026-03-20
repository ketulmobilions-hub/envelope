/// Exception thrown when a goal operation fails.
class GoalException implements Exception {
  /// Creates a [GoalException].
  const GoalException(this.message, {this.error});

  /// The error message.
  final String message;

  /// The original error, if available.
  final Object? error;

  @override
  String toString() =>
      'GoalException: $message${error != null ? ' ($error)' : ''}';
}
