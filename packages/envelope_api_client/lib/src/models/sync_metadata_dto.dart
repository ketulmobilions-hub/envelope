import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_metadata_dto.freezed.dart';
part 'sync_metadata_dto.g.dart';

/// Data transfer object for the `sync_metadata` table.
@freezed
abstract class SyncMetadataDto with _$SyncMetadataDto {
  const factory SyncMetadataDto({
    required String id,
    @JsonKey(name: 'table_name') required String tableName,
    @JsonKey(name: 'record_id') required String recordId,
    @JsonKey(name: 'last_modified') required DateTime lastModified,
    @JsonKey(name: 'device_id') required String deviceId,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'sync_status') @Default('pending') String syncStatus,
  }) = _SyncMetadataDto;

  factory SyncMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataDtoFromJson(json);
}
