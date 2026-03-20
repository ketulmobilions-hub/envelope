part of 'goal_detail_cubit.dart';

enum GoalDetailStatus { idle, submitting, completed, deleted, failure }

final class GoalDetailState extends Equatable {
  const GoalDetailState({
    required this.goal,
    this.status = GoalDetailStatus.idle,
    this.errorMessage,
  });

  final Goal goal;
  final GoalDetailStatus status;
  final String? errorMessage;

  GoalDetailState copyWith({
    Goal? goal,
    GoalDetailStatus? status,
    Object? errorMessage = _sentinel,
  }) {
    return GoalDetailState(
      goal: goal ?? this.goal,
      status: status ?? this.status,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [goal, status, errorMessage];
}
