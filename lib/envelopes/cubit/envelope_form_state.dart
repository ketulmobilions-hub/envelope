part of 'envelope_form_cubit.dart';

enum EnvelopeFormStatus { initial, submitting, success, failure }

final class EnvelopeFormState extends Equatable {
  const EnvelopeFormState({
    this.status = EnvelopeFormStatus.initial,
    this.errorMessage,
    this.createdEnvelope,
  });

  final EnvelopeFormStatus status;
  final String? errorMessage;

  /// Populated on a successful CREATE so the caller (e.g. the envelope
  /// picker) can auto-select the newly-created envelope. Null on edit.
  final Envelope? createdEnvelope;

  EnvelopeFormState copyWith({
    EnvelopeFormStatus? status,
    String? errorMessage,
    Envelope? createdEnvelope,
  }) {
    return EnvelopeFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      createdEnvelope: createdEnvelope ?? this.createdEnvelope,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, createdEnvelope];
}
