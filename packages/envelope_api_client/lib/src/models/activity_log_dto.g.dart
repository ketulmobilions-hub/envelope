// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityLogDto _$ActivityLogDtoFromJson(Map<String, dynamic> json) =>
    _ActivityLogDto(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      userId: json['user_id'] as String,
      action: json['action'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      details: json['details'] as String?,
    );

Map<String, dynamic> _$ActivityLogDtoToJson(_ActivityLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_id': instance.budgetId,
      'user_id': instance.userId,
      'action': instance.action,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'created_at': instance.createdAt.toIso8601String(),
      'details': instance.details,
    };
