// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  baseCurrency: json['base_currency'] as String? ?? 'USD',
  themeMode: json['theme_mode'] as String? ?? 'system',
  accentColor: json['accent_color'] as String?,
  privacyAcceptedAt: json['privacy_accepted_at'] == null
      ? null
      : DateTime.parse(json['privacy_accepted_at'] as String),
  termsAcceptedAt: json['terms_accepted_at'] == null
      ? null
      : DateTime.parse(json['terms_accepted_at'] as String),
  consentVersion: json['consent_version'] as String?,
);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'display_name': instance.displayName,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'base_currency': instance.baseCurrency,
  'theme_mode': instance.themeMode,
  'accent_color': instance.accentColor,
  'privacy_accepted_at': instance.privacyAcceptedAt?.toIso8601String(),
  'terms_accepted_at': instance.termsAcceptedAt?.toIso8601String(),
  'consent_version': instance.consentVersion,
};
