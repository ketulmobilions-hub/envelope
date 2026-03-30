import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const SettingsState());

  final AuthRepository _authRepository;

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
}
