import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_split_dto.freezed.dart';
part 'transaction_split_dto.g.dart';

/// Data transfer object for the `transaction_splits` table.
@freezed
abstract class TransactionSplitDto with _$TransactionSplitDto {
  const factory TransactionSplitDto({
    required String id,
    @JsonKey(name: 'transaction_id') required String transactionId,
    @JsonKey(name: 'envelope_id') required String envelopeId,
    required double amount,
  }) = _TransactionSplitDto;

  factory TransactionSplitDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionSplitDtoFromJson(json);
}
