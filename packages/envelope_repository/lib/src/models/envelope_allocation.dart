import 'package:freezed_annotation/freezed_annotation.dart';

part 'envelope_allocation.freezed.dart';
part 'envelope_allocation.g.dart';

@freezed
abstract class EnvelopeAllocation with _$EnvelopeAllocation {
  const factory EnvelopeAllocation({
    required String id,
    required String envelopeId,
    required String budgetPeriodId,
    required DateTime createdAt,
    @Default(0) int allocatedAmount,
    @Default(0) int spentAmount,
    @Default(0) int rolloverAmount,
  }) = _EnvelopeAllocation;

  factory EnvelopeAllocation.fromJson(Map<String, dynamic> json) =>
      _$EnvelopeAllocationFromJson(json);
}
