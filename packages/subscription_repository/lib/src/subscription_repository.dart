// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:subscription_repository/src/models/models.dart';

/// Repository for subscription management via RevenueCat.
class SubscriptionRepository {
  const SubscriptionRepository({
    required EnvelopeApiClient apiClient,
  }) : _apiClient = apiClient;

  final EnvelopeApiClient _apiClient;

  /// Stream of the current subscription state.
  Stream<Subscription> get subscription {
    // TODO(envelope): Implement subscription stream
    throw UnimplementedError();
  }

  /// Gets the subscription for a user.
  Future<Subscription> getSubscription(String userId) async {
    // TODO(envelope): Implement get subscription
    throw UnimplementedError();
  }

  /// Purchases a premium subscription.
  Future<void> purchasePremium() async {
    // TODO(envelope): Implement purchase premium
    throw UnimplementedError();
  }

  /// Restores previous purchases.
  Future<void> restorePurchases() async {
    // TODO(envelope): Implement restore purchases
    throw UnimplementedError();
  }

  /// Checks if the current user has a premium subscription.
  Future<bool> isPremium() async {
    // TODO(envelope): Implement is premium check
    throw UnimplementedError();
  }
}
