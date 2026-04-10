part of 'goal_detail_cubit.dart';

enum GoalDetailStatus {
  idle,
  submitting,
  completed,
  contributed,
  deleted,
  failure,
}

final class GoalDetailState extends Equatable {
  const GoalDetailState({
    required this.goal,
    this.status = GoalDetailStatus.idle,
    this.contributions = const [],
    this.errorMessage,
  });

  final Goal goal;
  final GoalDetailStatus status;
  final List<GoalContribution> contributions;
  final String? errorMessage;

  GoalDetailState copyWith({
    Goal? goal,
    GoalDetailStatus? status,
    List<GoalContribution>? contributions,
    Object? errorMessage = _sentinel,
  }) {
    return GoalDetailState(
      goal: goal ?? this.goal,
      status: status ?? this.status,
      contributions: contributions ?? this.contributions,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [goal, status, contributions, errorMessage];
}
