import 'package:freezed_annotation/freezed_annotation.dart';

part 'envelope_dto.freezed.dart';
part 'envelope_dto.g.dart';

/// Data transfer object for the `envelopes` table.
@freezed
abstract class EnvelopeDto with _$EnvelopeDto {
  const factory EnvelopeDto({
    required String id,
    @JsonKey(name: 'category_group_id') required String categoryGroupId,
    @JsonKey(name: 'budget_id') required String budgetId,
    required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
    @Default(null) String? color,
    @JsonKey(name: 'linked_account_id') @Default(null) String? linkedAccountId,
  }) = _EnvelopeDto;

  factory EnvelopeDto.fromJson(Map<String, dynamic> json) =>
      _$EnvelopeDtoFromJson(json);
}
