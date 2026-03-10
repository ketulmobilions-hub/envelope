// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_group_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryGroupDto _$CategoryGroupDtoFromJson(Map<String, dynamic> json) =>
    _CategoryGroupDto(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isDefault: json['is_default'] as bool? ?? false,
      isArchived: json['is_archived'] as bool? ?? false,
    );

Map<String, dynamic> _$CategoryGroupDtoToJson(_CategoryGroupDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'name': instance.name,
      'created_at': instance.createdAt.toIso8601String(),
      'sort_order': instance.sortOrder,
      'is_default': instance.isDefault,
      'is_archived': instance.isArchived,
    };
