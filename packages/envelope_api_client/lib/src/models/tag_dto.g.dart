// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TagDto _$TagDtoFromJson(Map<String, dynamic> json) => _TagDto(
  id: json['id'] as String,
  budgetId: json['budget_id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$TagDtoToJson(_TagDto instance) => <String, dynamic>{
  'id': instance.id,
  'budget_id': instance.budgetId,
  'name': instance.name,
};
