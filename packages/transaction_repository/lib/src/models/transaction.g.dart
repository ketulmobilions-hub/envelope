// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: json['id'] as String,
  budgetId: json['budgetId'] as String,
  accountId: json['accountId'] as String,
  type: json['type'] as String,
  amount: (json['amount'] as num).toInt(),
  currency: json['currency'] as String,
  date: DateTime.parse(json['date'] as String),
  createdBy: json['createdBy'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  envelopeId: json['envelopeId'] as String?,
  exchangeRate: (json['exchangeRate'] as num?)?.toDouble() ?? 1.0,
  baseCurrencyAmount: (json['baseCurrencyAmount'] as num?)?.toInt() ?? 0,
  payee: json['payee'] as String?,
  notes: json['notes'] as String?,
  isReconciled: json['isReconciled'] as bool? ?? false,
  recurringRuleId: json['recurringRuleId'] as String?,
  transferPairId: json['transferPairId'] as String?,
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'accountId': instance.accountId,
      'type': instance.type,
      'amount': instance.amount,
      'currency': instance.currency,
      'date': instance.date.toIso8601String(),
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'envelopeId': instance.envelopeId,
      'exchangeRate': instance.exchangeRate,
      'baseCurrencyAmount': instance.baseCurrencyAmount,
      'payee': instance.payee,
      'notes': instance.notes,
      'isReconciled': instance.isReconciled,
      'recurringRuleId': instance.recurringRuleId,
      'transferPairId': instance.transferPairId,
    };
