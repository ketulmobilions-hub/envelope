// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncStatus _$SyncStatusFromJson(Map<String, dynamic> json) => _SyncStatus(
  state:
      $enumDecodeNullable(_$SyncStateEnumMap, json['state']) ?? SyncState.idle,
  pendingChanges: (json['pendingChanges'] as num?)?.toInt() ?? 0,
  lastSyncedAt: json['lastSyncedAt'] == null
      ? null
      : DateTime.parse(json['lastSyncedAt'] as String),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$SyncStatusToJson(_SyncStatus instance) =>
    <String, dynamic>{
      'state': _$SyncStateEnumMap[instance.state]!,
      'pendingChanges': instance.pendingChanges,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'errorMessage': instance.errorMessage,
    };

const _$SyncStateEnumMap = {
  SyncState.idle: 'idle',
  SyncState.syncing: 'syncing',
  SyncState.synced: 'synced',
  SyncState.error: 'error',
};
