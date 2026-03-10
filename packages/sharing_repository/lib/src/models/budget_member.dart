import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_member.freezed.dart';
part 'budget_member.g.dart';

@freezed
abstract class BudgetMember with _$BudgetMember {
  const factory BudgetMember({
    required String id,
    required String budgetId,
    required String userId,
    required String invitedVia,
    required DateTime createdAt,
    @Default('viewer') String role,
    DateTime? acceptedAt,
  }) = _BudgetMember;

  factory BudgetMember.fromJson(Map<String, dynamic> json) =>
      _$BudgetMemberFromJson(json);
}
