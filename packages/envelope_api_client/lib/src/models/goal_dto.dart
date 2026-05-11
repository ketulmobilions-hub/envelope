import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_dto.freezed.dart';
part 'goal_dto.g.dart';

/// Data transfer object for the `goals` table.
@freezed
abstract class GoalDto with _$GoalDto {
  const factory GoalDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    required String type,
    required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'current_amount') @Default(0) int currentAmount,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    @JsonKey(name: 'account_id') String? accountId,
    @JsonKey(name: 'target_amount') int? targetAmount,
    @JsonKey(name: 'target_date') DateTime? targetDate,
    @JsonKey(name: 'monthly_contribution') int? monthlyContribution,
    @JsonKey(name: 'apr_bps') int? aprBps,
    @JsonKey(name: 'min_payment_cents') int? minPaymentCents,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _GoalDto;

  factory GoalDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDtoFromJson(json);
}
