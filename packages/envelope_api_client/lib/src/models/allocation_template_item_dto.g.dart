// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_template_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AllocationTemplateItemDto _$AllocationTemplateItemDtoFromJson(
  Map<String, dynamic> json,
) => _AllocationTemplateItemDto(
  id: json['id'] as String,
  templateId: json['template_id'] as String,
  envelopeId: json['envelope_id'] as String,
  percentage: (json['percentage'] as num).toDouble(),
);

Map<String, dynamic> _$AllocationTemplateItemDtoToJson(
  _AllocationTemplateItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'template_id': instance.templateId,
  'envelope_id': instance.envelopeId,
  'percentage': instance.percentage,
};
