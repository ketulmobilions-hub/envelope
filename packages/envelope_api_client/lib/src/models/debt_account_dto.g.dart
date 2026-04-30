// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtAccountDto _$DebtAccountDtoFromJson(Map<String, dynamic> json) =>
    _DebtAccountDto(
      accountId: json['account_id'] as String,
      interestRate: (json['interest_rate'] as num).toDouble(),
      minimumPayment: (json['minimum_payment'] as num).toInt(),
      originalBalance: (json['original_balance'] as num).toInt(),
      payoffStrategy: json['payoff_strategy'] as String?,
      creditLimit: (json['credit_limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DebtAccountDtoToJson(_DebtAccountDto instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'interest_rate': instance.interestRate,
      'minimum_payment': instance.minimumPayment,
      'original_balance': instance.originalBalance,
      'payoff_strategy': instance.payoffStrategy,
      'credit_limit': ?instance.creditLimit,
    };
