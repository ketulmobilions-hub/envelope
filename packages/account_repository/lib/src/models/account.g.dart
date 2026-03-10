// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  id: json['id'] as String,
  budgetId: json['budgetId'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  currency: json['currency'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  startingBalance: (json['startingBalance'] as num?)?.toInt() ?? 0,
  currentBalance: (json['currentBalance'] as num?)?.toInt() ?? 0,
  isArchived: json['isArchived'] as bool? ?? false,
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id,
  'budgetId': instance.budgetId,
  'name': instance.name,
  'type': instance.type,
  'currency': instance.currency,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'startingBalance': instance.startingBalance,
  'currentBalance': instance.currentBalance,
  'isArchived': instance.isArchived,
};
