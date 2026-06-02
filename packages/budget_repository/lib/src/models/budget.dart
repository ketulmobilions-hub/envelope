import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String ownerId,
    required String name,
    required String baseCurrency,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('monthly') String periodType,
    @Default(1) int periodStartDay,
    @Default(false) bool isArchived,

    /// Sum of on-budget account starting balances in cents.
    ///
    /// Added to "Ready to Assign" in whichever period contains
    /// [openingDate] and propagates forward via `carriedRta`. This decouples
    /// seed cash from the onboarding month so backdated transactions can be
    /// covered by allocations.
    @Default(0) int openingBalance,

    /// Date the opening balance is anchored to. Shifts earlier when a
    /// period is backfilled before it.
    DateTime? openingDate,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}
