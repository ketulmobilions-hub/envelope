// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_worth_snapshot_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NetWorthSnapshotDto _$NetWorthSnapshotDtoFromJson(Map<String, dynamic> json) =>
    _NetWorthSnapshotDto(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      date: DateTime.parse(json['date'] as String),
      assets: (json['assets'] as num).toInt(),
      liabilities: (json['liabilities'] as num).toInt(),
      netWorth: (json['net_worth'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NetWorthSnapshotDtoToJson(
  _NetWorthSnapshotDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'budget_id': instance.budgetId,
  'date': instance.date.toIso8601String(),
  'assets': instance.assets,
  'liabilities': instance.liabilities,
  'net_worth': instance.netWorth,
  'created_at': instance.createdAt.toIso8601String(),
};
