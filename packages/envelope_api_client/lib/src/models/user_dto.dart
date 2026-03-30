import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// Data transfer object for the `users` table.
@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'base_currency') @Default('USD') String baseCurrency,
    @JsonKey(name: 'theme_mode') @Default('system') String themeMode,
    @JsonKey(name: 'accent_color') String? accentColor,
    @JsonKey(name: 'privacy_accepted_at') DateTime? privacyAcceptedAt,
    @JsonKey(name: 'terms_accepted_at') DateTime? termsAcceptedAt,
    @JsonKey(name: 'consent_version') String? consentVersion,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
