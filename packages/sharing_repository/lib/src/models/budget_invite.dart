import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_invite.freezed.dart';
part 'budget_invite.g.dart';

@freezed
abstract class BudgetInvite with _$BudgetInvite {
  const factory BudgetInvite({
    required String id,
    required String budgetId,
    required String role,
    required String createdBy,
    required DateTime expiresAt,
    DateTime? redeemedAt,
    String? redeemedBy,
    required DateTime createdAt,
  }) = _BudgetInvite;

  factory BudgetInvite.fromJson(Map<String, dynamic> json) =>
      _$BudgetInviteFromJson(json);
}
