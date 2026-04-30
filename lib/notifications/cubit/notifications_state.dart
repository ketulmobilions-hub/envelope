import 'package:equatable/equatable.dart';
import 'package:notification_repository/notification_repository.dart';

enum NotificationsStatus { initial, loading, loaded, error }

/// Sentinel used to explicitly set a nullable field to null in [copyWith].
const _sentinel = Object();

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.preferences,
    this.errorMessage,
    this.saveErrorMessage,
  });

  final NotificationsStatus status;
  final NotificationPreferences? preferences;
  final String? errorMessage;

  /// Non-null when a toggle save failed (e.g. offline). Used to trigger a
  /// snackbar without replacing the loaded preferences view with an error screen.
  final String? saveErrorMessage;

  NotificationsState copyWith({
    NotificationsStatus? status,
    NotificationPreferences? preferences,
    Object? errorMessage = _sentinel,
    Object? saveErrorMessage = _sentinel,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      saveErrorMessage: identical(saveErrorMessage, _sentinel)
          ? this.saveErrorMessage
          : saveErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    preferences,
    errorMessage,
    saveErrorMessage,
  ];
}
