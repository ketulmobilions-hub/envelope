import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_token_dto.freezed.dart';
part 'push_token_dto.g.dart';

/// Data transfer object for the `push_tokens` table.
@freezed
abstract class PushTokenDto with _$PushTokenDto {
  const factory PushTokenDto({
    @JsonKey(name: 'user_id') required String userId,
    required String token,
    required String platform,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(includeIfNull: false) String? id,
  }) = _PushTokenDto;

  factory PushTokenDto.fromJson(Map<String, dynamic> json) =>
      _$PushTokenDtoFromJson(json);
}
