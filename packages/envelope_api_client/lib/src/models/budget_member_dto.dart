import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_member_dto.freezed.dart';
part 'budget_member_dto.g.dart';

/// Data transfer object for the `budget_members` table.
@freezed
abstract class BudgetMemberDto with _$BudgetMemberDto {
  const factory BudgetMemberDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'invited_via') required String invitedVia,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default('viewer') String role,
    @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
  }) = _BudgetMemberDto;

  factory BudgetMemberDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetMemberDtoFromJson(json);
}
