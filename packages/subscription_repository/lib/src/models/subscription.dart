import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

enum SubscriptionTier {
  free,
  premium,
}

@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({
    required String userId,
    required DateTime createdAt,
    @Default(SubscriptionTier.free) SubscriptionTier tier,
    DateTime? expiresAt,
    @Default(false) bool isActive,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}
