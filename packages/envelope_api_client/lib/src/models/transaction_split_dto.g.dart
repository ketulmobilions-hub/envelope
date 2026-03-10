// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_split_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionSplitDto _$TransactionSplitDtoFromJson(Map<String, dynamic> json) =>
    _TransactionSplitDto(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      envelopeId: json['envelope_id'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$TransactionSplitDtoToJson(
  _TransactionSplitDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'transaction_id': instance.transactionId,
  'envelope_id': instance.envelopeId,
  'amount': instance.amount,
};
