// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_split.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionSplit _$TransactionSplitFromJson(Map<String, dynamic> json) =>
    _TransactionSplit(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      envelopeId: json['envelopeId'] as String,
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionSplitToJson(_TransactionSplit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'envelopeId': instance.envelopeId,
      'amount': instance.amount,
    };
