import 'dart:io';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required AuthRepository authRepository,
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
  })  : _authRepository = authRepository,
        _apiClient = apiClient,
        _localDatabase = localDatabase,
        super(const SettingsState());

  final AuthRepository _authRepository;
  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;

  Future<void> init() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      emit(
        state.copyWith(
          status: SettingsStatus.success,
          appVersion: '${packageInfo.version} (${packageInfo.buildNumber})',
        ),
      );
    } on Exception {
      emit(state.copyWith(status: SettingsStatus.success, appVersion: ''));
    }
  }

  Future<void> updateDisplayName(String name) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      await _authRepository.updateProfile(displayName: name);
      emit(
        state.copyWith(
          status: SettingsStatus.success,
          successMessage: SettingsMessage.displayNameUpdated,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: SettingsMessage.updateFailed,
        ),
      );
    }
  }

  Future<void> updateBaseCurrency(String code) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      await _authRepository.updateProfile(baseCurrency: code);
      emit(
        state.copyWith(
          status: SettingsStatus.success,
          successMessage: SettingsMessage.currencyUpdated,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: SettingsMessage.updateFailed,
        ),
      );
    }
  }

  Future<void> updateThemeMode(String mode) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      await _authRepository.updateProfile(themeMode: mode);
      emit(state.copyWith(status: SettingsStatus.success));
    } on Exception {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: SettingsMessage.updateFailed,
        ),
      );
    }
  }

  Future<void> changePassword(String newPassword) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      await _authRepository.changePassword(newPassword);
      emit(
        state.copyWith(
          status: SettingsStatus.success,
          successMessage: SettingsMessage.passwordChanged,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: SettingsMessage.passwordChangeFailed,
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      await _authRepository.deleteAccount();
      await _localDatabase.clearAllTables();
      emit(state.copyWith(status: SettingsStatus.success));
    } on Exception {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: SettingsMessage.deleteAccountFailed,
        ),
      );
    }
  }

  /// Exports all user data as a JSON file and shares it (GDPR data
  /// portability).
  Future<void> exportAllData(String userId) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final json = await _apiClient.users.exportAllUserData(userId);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/envelope_data_export.json');
      await file.writeAsString(json);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)]),
      );
      emit(
        state.copyWith(
          status: SettingsStatus.success,
          successMessage: SettingsMessage.dataExported,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: SettingsMessage.dataExportFailed,
        ),
      );
    }
  }
}
