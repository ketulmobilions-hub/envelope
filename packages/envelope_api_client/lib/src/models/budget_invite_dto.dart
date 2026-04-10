import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_invite_dto.freezed.dart';
part 'budget_invite_dto.g.dart';

/// Data transfer object for the `budget_invites` table.
@freezed
abstract class BudgetInviteDto with _$BudgetInviteDto {
  const factory BudgetInviteDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    @Default('viewer') String role,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'redeemed_at') DateTime? redeemedAt,
    @JsonKey(name: 'redeemed_by') String? redeemedBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BudgetInviteDto;

  factory BudgetInviteDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetInviteDtoFromJson(json);
}
