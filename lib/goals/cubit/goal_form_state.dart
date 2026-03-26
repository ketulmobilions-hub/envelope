part of 'goal_form_cubit.dart';

enum GoalFormStatus { initial, submitting, success, failure }

final class GoalFormState extends Equatable {
  const GoalFormState({
    this.status = GoalFormStatus.initial,
    this.errorMessage,
  });

  final GoalFormStatus status;
  final String? errorMessage;

  GoalFormState copyWith({
    GoalFormStatus? status,
    String? errorMessage,
  }) {
    return GoalFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
