import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_contribution.freezed.dart';

/// A single contribution recorded toward a goal.
@freezed
abstract class GoalContribution with _$GoalContribution {
  const factory GoalContribution({
    required String id,
    required String goalId,
    required int amountCents,
    required DateTime createdAt,
    String? note,
  }) = _GoalContribution;
}
