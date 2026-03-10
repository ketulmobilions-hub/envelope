import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_split.freezed.dart';
part 'transaction_split.g.dart';

@freezed
abstract class TransactionSplit with _$TransactionSplit {
  const factory TransactionSplit({
    required String id,
    required String transactionId,
    required String envelopeId,
    required int amount,
  }) = _TransactionSplit;

  factory TransactionSplit.fromJson(Map<String, dynamic> json) =>
      _$TransactionSplitFromJson(json);
}
