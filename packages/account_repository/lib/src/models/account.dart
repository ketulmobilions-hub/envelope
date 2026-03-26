import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,
    required String budgetId,
    required String name,
    required String type,
    required String currency,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int startingBalance,
    @Default(0) int currentBalance,
    @Default(false) bool isArchived,
    @Default(true) bool isOnBudget,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
