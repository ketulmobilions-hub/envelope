// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtAccount _$DebtAccountFromJson(Map<String, dynamic> json) => _DebtAccount(
  accountId: json['accountId'] as String,
  interestRate: (json['interestRate'] as num).toDouble(),
  minimumPayment: (json['minimumPayment'] as num).toInt(),
  originalBalance: (json['originalBalance'] as num).toInt(),
  payoffStrategy: json['payoffStrategy'] as String?,
);

Map<String, dynamic> _$DebtAccountToJson(_DebtAccount instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'interestRate': instance.interestRate,
      'minimumPayment': instance.minimumPayment,
      'originalBalance': instance.originalBalance,
      'payoffStrategy': instance.payoffStrategy,
    };
