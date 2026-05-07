import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String budgetId,
    required String accountId,
    required String type,
    required int amount,
    required String currency,
    required DateTime date,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? envelopeId,
    @Default(1.0) double exchangeRate,
    @Default(0) int baseCurrencyAmount,
    String? payee,
    String? notes,
    @Default(false) bool isReconciled,
    String? recurringRuleId,
    String? transferPairId,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
