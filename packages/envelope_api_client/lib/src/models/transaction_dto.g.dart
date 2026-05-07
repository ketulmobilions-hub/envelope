// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionDto _$TransactionDtoFromJson(Map<String, dynamic> json) =>
    _TransactionDto(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      accountId: json['account_id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      date: DateTime.parse(json['date'] as String),
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      exchangeRate: (json['exchange_rate'] as num?)?.toDouble() ?? 1.0,
      baseCurrencyAmount: (json['base_currency_amount'] as num?)?.toInt() ?? 0,
      isReconciled: json['is_reconciled'] as bool? ?? false,
      envelopeId: json['envelope_id'] as String?,
      payee: json['payee'] as String?,
      notes: json['notes'] as String?,
      recurringRuleId: json['recurring_rule_id'] as String?,
      transferPairId: json['transfer_pair_id'] as String?,
    );

Map<String, dynamic> _$TransactionDtoToJson(_TransactionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'account_id': instance.accountId,
      'type': instance.type,
      'amount': instance.amount,
      'currency': instance.currency,
      'date': instance.date.toIso8601String(),
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'exchange_rate': instance.exchangeRate,
      'base_currency_amount': instance.baseCurrencyAmount,
      'is_reconciled': instance.isReconciled,
      'envelope_id': instance.envelopeId,
      'payee': instance.payee,
      'notes': instance.notes,
      'recurring_rule_id': instance.recurringRuleId,
      'transfer_pair_id': instance.transferPairId,
    };
