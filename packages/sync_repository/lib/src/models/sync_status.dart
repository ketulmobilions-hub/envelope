import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_status.freezed.dart';
part 'sync_status.g.dart';

enum SyncState {
  idle,
  syncing,
  error,
}

@freezed
abstract class SyncStatus with _$SyncStatus {
  const factory SyncStatus({
    @Default(SyncState.idle) SyncState state,
    @Default(0) int pendingChanges,
    DateTime? lastSyncedAt,
    String? errorMessage,
  }) = _SyncStatus;

  factory SyncStatus.fromJson(Map<String, dynamic> json) =>
      _$SyncStatusFromJson(json);
}
