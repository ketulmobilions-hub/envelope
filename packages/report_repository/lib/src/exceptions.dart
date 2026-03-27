class ReportException implements Exception {
  const ReportException(this.message, {this.error});

  final String message;
  final Object? error;

  @override
  String toString() =>
      'ReportException: $message${error != null ? ' ($error)' : ''}';
}
