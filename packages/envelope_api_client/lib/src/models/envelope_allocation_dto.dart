import 'package:freezed_annotation/freezed_annotation.dart';

part 'envelope_allocation_dto.freezed.dart';
part 'envelope_allocation_dto.g.dart';

/// Data transfer object for the `envelope_allocations` table.
@freezed
abstract class EnvelopeAllocationDto with _$EnvelopeAllocationDto {
  const factory EnvelopeAllocationDto({
    required String id,
    @JsonKey(name: 'envelope_id') required String envelopeId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'allocated_amount') @Default(0) int allocatedAmount,
  }) = _EnvelopeAllocationDto;

  factory EnvelopeAllocationDto.fromJson(Map<String, dynamic> json) =>
      _$EnvelopeAllocationDtoFromJson(json);
}
