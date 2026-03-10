import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_account_dto.freezed.dart';
part 'debt_account_dto.g.dart';

/// Data transfer object for the `debt_accounts` table.
@freezed
abstract class DebtAccountDto with _$DebtAccountDto {
  const factory DebtAccountDto({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'interest_rate') required double interestRate,
    @JsonKey(name: 'minimum_payment') required int minimumPayment,
    @JsonKey(name: 'original_balance') required int originalBalance,
    @JsonKey(name: 'payoff_strategy') String? payoffStrategy,
  }) = _DebtAccountDto;

  factory DebtAccountDto.fromJson(Map<String, dynamic> json) =>
      _$DebtAccountDtoFromJson(json);
}
