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
    this.computedCurrentAmount,
    this.linkedEnvelopeName,
  });

  final Goal goal;
  final GoalDetailStatus status;
  final List<GoalContribution> contributions;
  final String? errorMessage;

  /// Live-derived current amount for goals linked to an envelope.
  /// Null for unlinked goals — UI should fall back to `goal.currentAmount`.
  final int? computedCurrentAmount;

  /// Name of the linked envelope, if any.
  final String? linkedEnvelopeName;

  /// Effective current amount for UI rendering.
  int get effectiveCurrentAmount =>
      computedCurrentAmount ?? goal.currentAmount;

  GoalDetailState copyWith({
    Goal? goal,
    GoalDetailStatus? status,
    List<GoalContribution>? contributions,
    Object? errorMessage = _sentinel,
    Object? computedCurrentAmount = _sentinel,
    Object? linkedEnvelopeName = _sentinel,
  }) {
    return GoalDetailState(
      goal: goal ?? this.goal,
      status: status ?? this.status,
      contributions: contributions ?? this.contributions,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      computedCurrentAmount: computedCurrentAmount == _sentinel
          ? this.computedCurrentAmount
          : computedCurrentAmount as int?,
      linkedEnvelopeName: linkedEnvelopeName == _sentinel
          ? this.linkedEnvelopeName
          : linkedEnvelopeName as String?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [
    goal,
    status,
    contributions,
    errorMessage,
    computedCurrentAmount,
    linkedEnvelopeName,
  ];
}
