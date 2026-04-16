import 'package:bloc/bloc.dart';
import 'package:envelope/notifications/cubit/notifications_state.dart';
import 'package:notification_repository/notification_repository.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required NotificationRepository notificationRepository,
    required String userId,
  }) : _repository = notificationRepository,
       _userId = userId,
       super(const NotificationsState());

  final NotificationRepository _repository;
  final String _userId;

  Future<void> loadPreferences() async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    try {
      final prefs = await _repository.getPreferences(_userId);
      emit(
        state.copyWith(
          status: NotificationsStatus.loaded,
          preferences: prefs,
          errorMessage: null,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: NotificationsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updatePreference(NotificationPreferences updated) async {
    final previous = state.preferences;
    emit(state.copyWith(preferences: updated));
    try {
      await _repository.updatePreferences(updated);
    } on Exception catch (_) {
      // Revert to previous state locally on failure.
      if (previous != null) {
        emit(state.copyWith(preferences: previous));
      }
    }
  }

  Future<void> togglePush({required bool enabled}) async {
    final prefs = state.preferences;
    if (prefs == null) return;
    await updatePreference(prefs.copyWith(pushEnabled: enabled));
  }

  Future<void> toggleEmail({required bool enabled}) async {
    final prefs = state.preferences;
    if (prefs == null) return;
    await updatePreference(prefs.copyWith(emailEnabled: enabled));
  }

  Future<void> toggleOverspend({required bool enabled}) async {
    final prefs = state.preferences;
    if (prefs == null) return;
    await updatePreference(prefs.copyWith(overspendAlerts: enabled));
  }

  Future<void> toggleBillReminders({required bool enabled}) async {
    final prefs = state.preferences;
    if (prefs == null) return;
    await updatePreference(prefs.copyWith(billReminders: enabled));
  }

  Future<void> toggleEmailBillReminders({required bool enabled}) async {
    final prefs = state.preferences;
    if (prefs == null) return;
    await updatePreference(prefs.copyWith(emailBillReminders: enabled));
  }

  Future<void> toggleDailyReminder({required bool enabled}) async {
    final prefs = state.preferences;
    if (prefs == null) return;
    await updatePreference(prefs.copyWith(dailyLoggingReminder: enabled));
  }

  Future<void> toggleRecurringAlerts({required bool enabled}) async {
    final prefs = state.preferences;
    if (prefs == null) return;
    await updatePreference(
      prefs.copyWith(recurringTransactionAlerts: enabled),
    );
  }

  Future<void> toggleSharedActivity({required bool enabled}) async {
    final prefs = state.preferences;
    if (prefs == null) return;
    await updatePreference(prefs.copyWith(sharedBudgetActivity: enabled));
  }

  Future<void> toggleWeeklySummary({required bool enabled}) async {
    final prefs = state.preferences;
    if (prefs == null) return;
    await updatePreference(prefs.copyWith(weeklySummary: enabled));
  }
}
