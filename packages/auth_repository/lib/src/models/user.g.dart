// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  baseCurrency: json['baseCurrency'] as String? ?? 'USD',
  themeMode: json['themeMode'] as String? ?? 'system',
  accentColor: json['accentColor'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'baseCurrency': instance.baseCurrency,
  'themeMode': instance.themeMode,
  'accentColor': instance.accentColor,
};
