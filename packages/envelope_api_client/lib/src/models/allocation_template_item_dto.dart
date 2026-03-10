import 'package:freezed_annotation/freezed_annotation.dart';

part 'allocation_template_item_dto.freezed.dart';
part 'allocation_template_item_dto.g.dart';

/// Data transfer object for the `allocation_template_items` table.
@freezed
abstract class AllocationTemplateItemDto with _$AllocationTemplateItemDto {
  const factory AllocationTemplateItemDto({
    required String id,
    @JsonKey(name: 'template_id') required String templateId,
    @JsonKey(name: 'envelope_id') required String envelopeId,
    required double percentage,
  }) = _AllocationTemplateItemDto;

  factory AllocationTemplateItemDto.fromJson(Map<String, dynamic> json) =>
      _$AllocationTemplateItemDtoFromJson(json);
}
