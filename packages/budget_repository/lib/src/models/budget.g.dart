// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Budget _$BudgetFromJson(Map<String, dynamic> json) => _Budget(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  name: json['name'] as String,
  baseCurrency: json['baseCurrency'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  periodType: json['periodType'] as String? ?? 'monthly',
  periodStartDay: (json['periodStartDay'] as num?)?.toInt() ?? 1,
  isArchived: json['isArchived'] as bool? ?? false,
  openingBalance: (json['openingBalance'] as num?)?.toInt() ?? 0,
  accountSeedBalance: (json['accountSeedBalance'] as num?)?.toInt() ?? 0,
  openingDate: json['openingDate'] == null
      ? null
      : DateTime.parse(json['openingDate'] as String),
);

Map<String, dynamic> _$BudgetToJson(_Budget instance) => <String, dynamic>{
  'id': instance.id,
  'ownerId': instance.ownerId,
  'name': instance.name,
  'baseCurrency': instance.baseCurrency,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'periodType': instance.periodType,
  'periodStartDay': instance.periodStartDay,
  'isArchived': instance.isArchived,
  'openingBalance': instance.openingBalance,
  'accountSeedBalance': instance.accountSeedBalance,
  'openingDate': instance.openingDate?.toIso8601String(),
};
