import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_dto.freezed.dart';
part 'tag_dto.g.dart';

/// Data transfer object for the `tags` table.
@freezed
abstract class TagDto with _$TagDto {
  const factory TagDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    required String name,
  }) = _TagDto;

  factory TagDto.fromJson(Map<String, dynamic> json) => _$TagDtoFromJson(json);
}
