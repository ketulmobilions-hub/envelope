import 'package:supabase_flutter/supabase_flutter.dart';

/// Exception thrown by the Envelope API client.
class EnvelopeApiException implements Exception {
  /// Creates an [EnvelopeApiException].
  const EnvelopeApiException(this.message, {this.statusCode, this.error});

  /// Creates an [EnvelopeApiException] from a Supabase [PostgrestException].
  factory EnvelopeApiException.fromPostgrestException(
    Object error,
  ) {
    if (error is PostgrestException) {
      return EnvelopeApiException(
        error.message,
        statusCode: int.tryParse(error.code ?? ''),
        error: error,
      );
    }
    return EnvelopeApiException(
      error.toString(),
      error: error,
    );
  }

  /// The error message.
  final String message;

  /// The HTTP status code, if available.
  final int? statusCode;

  /// The original error, if available.
  final Object? error;

  @override
  String toString() => 'EnvelopeApiException: $message';
}
