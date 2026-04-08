import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_contribution_dto.freezed.dart';
part 'goal_contribution_dto.g.dart';

/// Data transfer object for the `goal_contributions` table.
@freezed
abstract class GoalContributionDto with _$GoalContributionDto {
  const factory GoalContributionDto({
    required String id,
    @JsonKey(name: 'goal_id') required String goalId,
    @JsonKey(name: 'amount_cents') required int amountCents,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    String? note,
  }) = _GoalContributionDto;

  factory GoalContributionDto.fromJson(Map<String, dynamic> json) =>
      _$GoalContributionDtoFromJson(json);
}
