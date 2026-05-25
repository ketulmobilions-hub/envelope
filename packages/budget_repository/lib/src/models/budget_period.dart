import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_period.freezed.dart';
part 'budget_period.g.dart';

@freezed
abstract class BudgetPeriod with _$BudgetPeriod {
  const factory BudgetPeriod({
    required String id,
    required String budgetId,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime createdAt,
    @Default(0) int totalIncome,
    @Default(0) int totalAllocated,
    @Default(0) int carriedRta,
    @Default(false) bool isClosed,
  }) = _BudgetPeriod;

  factory BudgetPeriod.fromJson(Map<String, dynamic> json) =>
      _$BudgetPeriodFromJson(json);
}
