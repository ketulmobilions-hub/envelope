// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Subscription _$SubscriptionFromJson(Map<String, dynamic> json) =>
    _Subscription(
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      tier:
          $enumDecodeNullable(_$SubscriptionTierEnumMap, json['tier']) ??
          SubscriptionTier.free,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$SubscriptionToJson(_Subscription instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'tier': _$SubscriptionTierEnumMap[instance.tier]!,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isActive': instance.isActive,
    };

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.free: 'free',
  SubscriptionTier.premium: 'premium',
};
