import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_period_dto.freezed.dart';
part 'budget_period_dto.g.dart';

/// Data transfer object for the `budget_periods` table.
@freezed
abstract class BudgetPeriodDto with _$BudgetPeriodDto {
  const factory BudgetPeriodDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'total_income') @Default(0) int totalIncome,
    @JsonKey(name: 'total_allocated') @Default(0) int totalAllocated,
    @JsonKey(name: 'is_closed') @Default(false) bool isClosed,
  }) = _BudgetPeriodDto;

  factory BudgetPeriodDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetPeriodDtoFromJson(json);
}
