part of 'envelope_form_cubit.dart';

enum EnvelopeFormStatus { initial, submitting, success, failure }

final class EnvelopeFormState extends Equatable {
  const EnvelopeFormState({
    this.status = EnvelopeFormStatus.initial,
    this.errorMessage,
  });

  final EnvelopeFormStatus status;
  final String? errorMessage;

  EnvelopeFormState copyWith({
    EnvelopeFormStatus? status,
    String? errorMessage,
  }) {
    return EnvelopeFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
