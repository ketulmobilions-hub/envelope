// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envelope_allocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnvelopeAllocation _$EnvelopeAllocationFromJson(Map<String, dynamic> json) =>
    _EnvelopeAllocation(
      id: json['id'] as String,
      envelopeId: json['envelopeId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      allocatedAmount: (json['allocatedAmount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$EnvelopeAllocationToJson(_EnvelopeAllocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'envelopeId': instance.envelopeId,
      'createdAt': instance.createdAt.toIso8601String(),
      'allocatedAmount': instance.allocatedAmount,
    };
