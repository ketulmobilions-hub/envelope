part of 'goal_form_cubit.dart';

enum GoalFormStatus { initial, submitting, success, failure }

const Object _unset = Object();

final class GoalFormState extends Equatable {
  const GoalFormState({
    this.status = GoalFormStatus.initial,
    this.errorMessage,
    this.envelopeId,
    this.envelopes = const [],
    this.envelopesLoading = true,
  });

  final GoalFormStatus status;
  final String? errorMessage;
  final String? envelopeId;
  final List<Envelope> envelopes;
  final bool envelopesLoading;

  GoalFormState copyWith({
    GoalFormStatus? status,
    String? errorMessage,
    Object? envelopeId = _unset,
    List<Envelope>? envelopes,
    bool? envelopesLoading,
  }) {
    return GoalFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      envelopeId: identical(envelopeId, _unset)
          ? this.envelopeId
          : envelopeId as String?,
      envelopes: envelopes ?? this.envelopes,
      envelopesLoading: envelopesLoading ?? this.envelopesLoading,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    envelopeId,
    envelopes,
    envelopesLoading,
  ];
}
