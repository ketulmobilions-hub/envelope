import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log_entry.freezed.dart';
part 'activity_log_entry.g.dart';

@freezed
abstract class ActivityLogEntry with _$ActivityLogEntry {
  const factory ActivityLogEntry({
    required String id,
    required String budgetId,
    required String userId,
    required String action,
    required String entityType,
    required String entityId,
    required DateTime createdAt,
    String? details,
  }) = _ActivityLogEntry;

  factory ActivityLogEntry.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogEntryFromJson(json);
}
