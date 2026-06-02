import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_dto.freezed.dart';
part 'account_dto.g.dart';

/// Data transfer object for the `accounts` table.
@freezed
abstract class AccountDto with _$AccountDto {
  const factory AccountDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    required String name,
    required String type,
    required String currency,
    @JsonKey(name: 'display_fx_rate') @Default(1.0) double displayFxRate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'starting_balance') @Default(0) int startingBalance,
    @JsonKey(name: 'current_balance') @Default(0) int currentBalance,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
    @JsonKey(name: 'is_on_budget') @Default(true) bool isOnBudget,
  }) = _AccountDto;

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);
}
