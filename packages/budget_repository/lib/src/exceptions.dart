/// Exception thrown when a budget operation fails.
class BudgetException implements Exception {
  /// Creates a [BudgetException].
  const BudgetException(this.message, {this.error});

  /// The error message.
  final String message;

  /// The original error, if available.
  final Object? error;

  @override
  String toString() =>
      'BudgetException: $message${error != null ? ' ($error)' : ''}';
}
