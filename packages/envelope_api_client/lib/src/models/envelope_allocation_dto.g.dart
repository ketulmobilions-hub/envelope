// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envelope_allocation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnvelopeAllocationDto _$EnvelopeAllocationDtoFromJson(
  Map<String, dynamic> json,
) => _EnvelopeAllocationDto(
  id: json['id'] as String,
  envelopeId: json['envelope_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  allocatedAmount: (json['allocated_amount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EnvelopeAllocationDtoToJson(
  _EnvelopeAllocationDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'envelope_id': instance.envelopeId,
  'created_at': instance.createdAt.toIso8601String(),
  'allocated_amount': instance.allocatedAmount,
};
