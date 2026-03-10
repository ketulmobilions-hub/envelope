import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_account.freezed.dart';
part 'debt_account.g.dart';

@freezed
abstract class DebtAccount with _$DebtAccount {
  const factory DebtAccount({
    required String accountId,
    required double interestRate,
    required int minimumPayment,
    required int originalBalance,
    String? payoffStrategy,
  }) = _DebtAccount;

  factory DebtAccount.fromJson(Map<String, dynamic> json) =>
      _$DebtAccountFromJson(json);
}
