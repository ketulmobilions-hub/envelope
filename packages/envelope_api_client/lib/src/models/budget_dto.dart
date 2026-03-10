import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_dto.freezed.dart';
part 'budget_dto.g.dart';

/// Data transfer object for the `budgets` table.
@freezed
abstract class BudgetDto with _$BudgetDto {
  const factory BudgetDto({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    @JsonKey(name: 'base_currency') required String baseCurrency,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'period_type') @Default('monthly') String periodType,
    @JsonKey(name: 'period_start_day') @Default(1) int periodStartDay,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
  }) = _BudgetDto;

  factory BudgetDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetDtoFromJson(json);
}
