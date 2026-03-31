// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushTokenDto _$PushTokenDtoFromJson(Map<String, dynamic> json) =>
    _PushTokenDto(
      userId: json['user_id'] as String,
      token: json['token'] as String,
      platform: json['platform'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$PushTokenDtoToJson(_PushTokenDto instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'token': instance.token,
      'platform': instance.platform,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'id': ?instance.id,
    };
