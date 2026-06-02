import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

/// Data transfer object for the `transactions` table.
@freezed
abstract class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    @JsonKey(name: 'account_id') required String accountId,
    required String type,
    required int amount,
    required String currency,
    required DateTime date,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'exchange_rate') @Default(1.0) double exchangeRate,
    @JsonKey(name: 'base_currency_amount') @Default(0) int baseCurrencyAmount,
    @JsonKey(name: 'is_reconciled') @Default(false) bool isReconciled,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    String? payee,
    String? notes,
    @JsonKey(name: 'recurring_rule_id') String? recurringRuleId,
    @JsonKey(name: 'transfer_pair_id') String? transferPairId,
  }) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);
}
