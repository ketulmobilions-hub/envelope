// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_worth_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NetWorthSnapshot _$NetWorthSnapshotFromJson(Map<String, dynamic> json) =>
    _NetWorthSnapshot(
      id: json['id'] as String,
      budgetId: json['budgetId'] as String,
      date: DateTime.parse(json['date'] as String),
      assets: (json['assets'] as num).toInt(),
      liabilities: (json['liabilities'] as num).toInt(),
      netWorth: (json['netWorth'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NetWorthSnapshotToJson(_NetWorthSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'date': instance.date.toIso8601String(),
      'assets': instance.assets,
      'liabilities': instance.liabilities,
      'netWorth': instance.netWorth,
      'createdAt': instance.createdAt.toIso8601String(),
    };
