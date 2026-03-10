// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envelope_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnvelopeDto _$EnvelopeDtoFromJson(Map<String, dynamic> json) => _EnvelopeDto(
  id: json['id'] as String,
  categoryGroupId: json['category_group_id'] as String,
  budgetId: json['budget_id'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  isArchived: json['is_archived'] as bool? ?? false,
);

Map<String, dynamic> _$EnvelopeDtoToJson(_EnvelopeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_group_id': instance.categoryGroupId,
      'budget_id': instance.budgetId,
      'name': instance.name,
      'created_at': instance.createdAt.toIso8601String(),
      'sort_order': instance.sortOrder,
      'is_archived': instance.isArchived,
    };
