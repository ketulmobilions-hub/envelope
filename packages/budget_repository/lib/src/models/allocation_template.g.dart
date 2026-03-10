// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AllocationTemplate _$AllocationTemplateFromJson(Map<String, dynamic> json) =>
    _AllocationTemplate(
      id: json['id'] as String,
      budgetId: json['budgetId'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) =>
                    AllocationTemplateItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <AllocationTemplateItem>[],
    );

Map<String, dynamic> _$AllocationTemplateToJson(_AllocationTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'items': instance.items,
    };

_AllocationTemplateItem _$AllocationTemplateItemFromJson(
  Map<String, dynamic> json,
) => _AllocationTemplateItem(
  id: json['id'] as String,
  templateId: json['templateId'] as String,
  envelopeId: json['envelopeId'] as String,
  percentage: (json['percentage'] as num).toDouble(),
);

Map<String, dynamic> _$AllocationTemplateItemToJson(
  _AllocationTemplateItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'templateId': instance.templateId,
  'envelopeId': instance.envelopeId,
  'percentage': instance.percentage,
};
