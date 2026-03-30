part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, success, error }

/// Message keys used by the cubit — mapped to l10n strings in the UI.
abstract final class SettingsMessage {
  static const String displayNameUpdated = 'displayNameUpdated';
  static const String currencyUpdated = 'currencyUpdated';
  static const String passwordChanged = 'passwordChanged';
  static const String updateFailed = 'updateFailed';
  static const String passwordChangeFailed = 'passwordChangeFailed';
  static const String deleteAccountFailed = 'deleteAccountFailed';
}

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.appVersion = '',
    this.errorMessage,
    this.successMessage,
  });

  final SettingsStatus status;
  final String appVersion;
  final String? errorMessage;
  final String? successMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    String? appVersion,
    String? errorMessage,
    String? successMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      appVersion: appVersion ?? this.appVersion,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, appVersion, errorMessage, successMessage];
}
