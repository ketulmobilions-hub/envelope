// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_template_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AllocationTemplateDto _$AllocationTemplateDtoFromJson(
  Map<String, dynamic> json,
) => _AllocationTemplateDto(
  id: json['id'] as String,
  budgetId: json['budget_id'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AllocationTemplateDtoToJson(
  _AllocationTemplateDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'budget_id': instance.budgetId,
  'name': instance.name,
  'created_at': instance.createdAt.toIso8601String(),
};
