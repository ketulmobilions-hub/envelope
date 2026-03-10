import 'package:freezed_annotation/freezed_annotation.dart';

part 'allocation_template_dto.freezed.dart';
part 'allocation_template_dto.g.dart';

/// Data transfer object for the `allocation_templates` table.
@freezed
abstract class AllocationTemplateDto with _$AllocationTemplateDto {
  const factory AllocationTemplateDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AllocationTemplateDto;

  factory AllocationTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$AllocationTemplateDtoFromJson(json);
}
