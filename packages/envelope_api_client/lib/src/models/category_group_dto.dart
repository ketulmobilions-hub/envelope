import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_group_dto.freezed.dart';
part 'category_group_dto.g.dart';

/// Data transfer object for the `category_groups` table.
@freezed
abstract class CategoryGroupDto with _$CategoryGroupDto {
  const factory CategoryGroupDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
  }) = _CategoryGroupDto;

  factory CategoryGroupDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupDtoFromJson(json);
}
