import 'package:freezed_annotation/freezed_annotation.dart';

part 'net_worth_snapshot.freezed.dart';
part 'net_worth_snapshot.g.dart';

@freezed
abstract class NetWorthSnapshot with _$NetWorthSnapshot {
  const factory NetWorthSnapshot({
    required String id,
    required String budgetId,
    required DateTime date,
    required int assets,
    required int liabilities,
    required int netWorth,
    required DateTime createdAt,
  }) = _NetWorthSnapshot;

  factory NetWorthSnapshot.fromJson(Map<String, dynamic> json) =>
      _$NetWorthSnapshotFromJson(json);
}
