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

    /// Legacy seed cash plus pre-#82 historical period income (folded by
    /// migration 00041). Set during onboarding and never overwritten by the
    /// periodic account-balance refresh. Folds directly into Ready-to-Assign
    /// alongside [accountSeedBalance].
    @Default(0) int openingBalance,

    /// Cached sum of on-budget account starting balances (clamped at zero),
    /// kept in sync by `BudgetRepository.refreshOpeningBalanceForBudget`
    /// whenever an account's starting balance changes. Distinct from
    /// [openingBalance] so the legacy seed and migrated historical income
    /// survive routine account edits.
    @Default(0) int accountSeedBalance,

    /// Date the opening balance is anchored to.
    DateTime? openingDate,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}
