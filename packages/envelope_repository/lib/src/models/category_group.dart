import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_group.freezed.dart';
part 'category_group.g.dart';

@freezed
abstract class CategoryGroup with _$CategoryGroup {
  const factory CategoryGroup({
    required String id,
    required String budgetId,
    required String name,
    required DateTime createdAt,
    @Default(0) int sortOrder,
    @Default(false) bool isDefault,
    @Default(false) bool isArchived,
  }) = _CategoryGroup;

  factory CategoryGroup.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupFromJson(json);
}
