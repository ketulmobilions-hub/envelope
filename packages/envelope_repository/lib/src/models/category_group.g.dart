// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryGroup _$CategoryGroupFromJson(Map<String, dynamic> json) =>
    _CategoryGroup(
      id: json['id'] as String,
      budgetId: json['budgetId'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isDefault: json['isDefault'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
    );

Map<String, dynamic> _$CategoryGroupToJson(_CategoryGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'sortOrder': instance.sortOrder,
      'isDefault': instance.isDefault,
      'isArchived': instance.isArchived,
    };
