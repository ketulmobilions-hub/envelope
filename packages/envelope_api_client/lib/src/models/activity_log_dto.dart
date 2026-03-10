import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log_dto.freezed.dart';
part 'activity_log_dto.g.dart';

/// Data transfer object for the `activity_log` table.
@freezed
abstract class ActivityLogDto with _$ActivityLogDto {
  const factory ActivityLogDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    @JsonKey(name: 'user_id') required String userId,
    required String action,
    @JsonKey(name: 'entity_type') required String entityType,
    @JsonKey(name: 'entity_id') required String entityId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    String? details,
  }) = _ActivityLogDto;

  factory ActivityLogDto.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogDtoFromJson(json);
}
