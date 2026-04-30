part of 'goals_bloc.dart';

enum GoalsStatus { initial, loading, refreshing, loaded, error }

/// Error codes for goal operations, translated in the UI layer.
enum GoalsError { loadFailed, updateFailed, deleteFailed }

final class GoalsState extends Equatable {
  const GoalsState({
    this.status = GoalsStatus.initial,
    this.goals = const [],
    this.error,
  });

  final GoalsStatus status;
  final List<Goal> goals;
  final GoalsError? error;

  /// Goals grouped by type.
  Map<String, List<Goal>> get goalsByType {
    final grouped = <String, List<Goal>>{};
    for (final goal in goals) {
      grouped.putIfAbsent(goal.type, () => []).add(goal);
    }
    return grouped;
  }

  /// Non-completed goals.
  List<Goal> get activeGoals => goals.where((g) => !g.isCompleted).toList();

  /// Completed goals.
  List<Goal> get completedGoals => goals.where((g) => g.isCompleted).toList();

  GoalsState copyWith({
    GoalsStatus? status,
    List<Goal>? goals,
    Object? error = _sentinel,
  }) {
    return GoalsState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
      error: error == _sentinel ? this.error : error as GoalsError?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [status, goals, error];
}
