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
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}
