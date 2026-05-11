import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

@freezed
abstract class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String budgetId,
    required String type,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? envelopeId,
    String? accountId,
    int? targetAmount,
    DateTime? targetDate,
    int? monthlyContribution,
    @Default(0) int currentAmount,
    @Default(false) bool isCompleted,

    /// Annual percentage rate in basis points (e.g. 1799 = 17.99%).
    /// Only meaningful for `debt_payoff` goals; null for other types.
    int? aprBps,

    /// Lender-required minimum monthly payment in cents.
    /// Only meaningful for `debt_payoff` goals; null for other types.
    int? minPaymentCents,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
