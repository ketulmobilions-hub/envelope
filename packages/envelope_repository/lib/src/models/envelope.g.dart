// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Envelope _$EnvelopeFromJson(Map<String, dynamic> json) => _Envelope(
  id: json['id'] as String,
  categoryGroupId: json['categoryGroupId'] as String,
  budgetId: json['budgetId'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  isArchived: json['isArchived'] as bool? ?? false,
);

Map<String, dynamic> _$EnvelopeToJson(_Envelope instance) => <String, dynamic>{
  'id': instance.id,
  'categoryGroupId': instance.categoryGroupId,
  'budgetId': instance.budgetId,
  'name': instance.name,
  'createdAt': instance.createdAt.toIso8601String(),
  'sortOrder': instance.sortOrder,
  'isArchived': instance.isArchived,
};
