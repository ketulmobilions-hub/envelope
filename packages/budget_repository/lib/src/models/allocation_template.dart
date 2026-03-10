import 'package:freezed_annotation/freezed_annotation.dart';

part 'allocation_template.freezed.dart';
part 'allocation_template.g.dart';

@freezed
abstract class AllocationTemplate with _$AllocationTemplate {
  const factory AllocationTemplate({
    required String id,
    required String budgetId,
    required String name,
    required DateTime createdAt,
    @Default(<AllocationTemplateItem>[]) List<AllocationTemplateItem> items,
  }) = _AllocationTemplate;

  factory AllocationTemplate.fromJson(Map<String, dynamic> json) =>
      _$AllocationTemplateFromJson(json);
}

@freezed
abstract class AllocationTemplateItem with _$AllocationTemplateItem {
  const factory AllocationTemplateItem({
    required String id,
    required String templateId,
    required String envelopeId,
    required double percentage,
  }) = _AllocationTemplateItem;

  factory AllocationTemplateItem.fromJson(Map<String, dynamic> json) =>
      _$AllocationTemplateItemFromJson(json);
}
