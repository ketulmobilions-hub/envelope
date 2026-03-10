// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_metadata_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncMetadataDto _$SyncMetadataDtoFromJson(Map<String, dynamic> json) =>
    _SyncMetadataDto(
      id: json['id'] as String,
      tableName: json['table_name'] as String,
      recordId: json['record_id'] as String,
      lastModified: DateTime.parse(json['last_modified'] as String),
      deviceId: json['device_id'] as String,
      isDeleted: json['is_deleted'] as bool? ?? false,
      syncStatus: json['sync_status'] as String? ?? 'pending',
    );

Map<String, dynamic> _$SyncMetadataDtoToJson(_SyncMetadataDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'table_name': instance.tableName,
      'record_id': instance.recordId,
      'last_modified': instance.lastModified.toIso8601String(),
      'device_id': instance.deviceId,
      'is_deleted': instance.isDeleted,
      'sync_status': instance.syncStatus,
    };
