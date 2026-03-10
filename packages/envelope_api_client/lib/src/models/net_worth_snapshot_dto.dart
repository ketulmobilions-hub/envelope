import 'package:freezed_annotation/freezed_annotation.dart';

part 'net_worth_snapshot_dto.freezed.dart';
part 'net_worth_snapshot_dto.g.dart';

/// Data transfer object for the `net_worth_snapshots` table.
@freezed
abstract class NetWorthSnapshotDto with _$NetWorthSnapshotDto {
  const factory NetWorthSnapshotDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    required DateTime date,
    required int assets,
    required int liabilities,
    @JsonKey(name: 'net_worth') required int netWorth,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _NetWorthSnapshotDto;

  factory NetWorthSnapshotDto.fromJson(Map<String, dynamic> json) =>
      _$NetWorthSnapshotDtoFromJson(json);
}
