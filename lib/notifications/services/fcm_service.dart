import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notification_repository/notification_repository.dart';

/// Service that wraps Firebase Cloud Messaging for token management
/// and foreground message handling.
class FcmService {
  FcmService({FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  String? _currentToken;
  String? _currentUserId;
  bool _initializing = false;

  /// Initializes FCM: requests permission, gets token, registers it,
  /// and listens for token refresh events.
  Future<void> initialize({
    required String userId,
    required NotificationRepository repository,
    required String platform,
  }) async {
    // Guard against concurrent calls.
    if (_initializing) return;
    _initializing = true;

    try {
      // Clean up previous subscriptions if re-initializing.
      await _cancelSubscriptions();
      _currentUserId = userId;

      // Request permission.
      final settings = await _messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        log('FCM: notification permission denied');
        return;
      }

      // On iOS, wait for the APNs token before requesting the FCM token.
      if (platform == 'ios') {
        var apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          // APNs token isn't ready yet — wait briefly and retry.
          await Future<void>.delayed(const Duration(seconds: 3));
          apnsToken = await _messaging.getAPNSToken();
          if (apnsToken == null) {
            log('FCM: APNs token not available, skipping registration');
            return;
          }
        }
      }

      // Get and register the current token.
      final token = await _messaging.getToken();
      if (token != null) {
        _currentToken = token;
        try {
          await repository.registerPushToken(
            userId: userId,
            token: token,
            platform: platform,
          );
          log('FCM: token registered');
        } on Exception catch (e) {
          log('FCM: failed to register token: $e');
        }
      }

      // Listen for token refresh.
      _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((
        newToken,
      ) async {
        _currentToken = newToken;
        try {
          await repository.registerPushToken(
            userId: userId,
            token: newToken,
            platform: platform,
          );
        } on Exception catch (e) {
          log('FCM: failed to register refreshed token: $e');
        }
      });

      // Foreground message handler (log for now).
      _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
        log('FCM: foreground message received: ${message.messageId}');
      });
    } finally {
      _initializing = false;
    }
  }

  /// Unregisters the current token and cancels the refresh listener.
  Future<void> unregisterCurrentToken({
    required NotificationRepository repository,
  }) async {
    final userId = _currentUserId;
    final token = _currentToken;

    if (userId != null && token != null) {
      try {
        await repository.unregisterPushToken(
          userId: userId,
          token: token,
        );
      } on Exception catch (e) {
        log('FCM: failed to unregister token: $e');
      }
    }

    _currentToken = null;
    _currentUserId = null;
    await _cancelSubscriptions();
  }

  /// Cancels all subscriptions.
  Future<void> dispose() async {
    await _cancelSubscriptions();
  }

  Future<void> _cancelSubscriptions() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    await _foregroundSubscription?.cancel();
    _foregroundSubscription = null;
  }
}
