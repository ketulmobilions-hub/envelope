import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/notifications/cubit/cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notification_repository/notification_repository.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository repository;
  const userId = 'user-1';

  const testPreferences = NotificationPreferences(
    userId: userId,
  );

  setUpAll(() {
    registerFallbackValue(testPreferences);
  });

  setUp(() {
    repository = MockNotificationRepository();
  });

  group('NotificationsCubit', () {
    test('initial state is correct', () {
      final cubit = NotificationsCubit(
        notificationRepository: repository,
        userId: userId,
      );
      expect(cubit.state.status, NotificationsStatus.initial);
      expect(cubit.state.preferences, isNull);
      expect(cubit.state.errorMessage, isNull);
      addTearDown(cubit.close);
    });

    group('loadPreferences', () {
      blocTest<NotificationsCubit, NotificationsState>(
        'emits [loading, loaded] when successful',
        setUp: () {
          when(
            () => repository.getPreferences(userId),
          ).thenAnswer((_) async => testPreferences);
        },
        build: () => NotificationsCubit(
          notificationRepository: repository,
          userId: userId,
        ),
        act: (cubit) => cubit.loadPreferences(),
        expect: () => [
          const NotificationsState(status: NotificationsStatus.loading),
          NotificationsState(
            status: NotificationsStatus.loaded,
            preferences: testPreferences,
          ),
        ],
      );

      blocTest<NotificationsCubit, NotificationsState>(
        'emits [loading, error] when fails',
        setUp: () {
          when(
            () => repository.getPreferences(userId),
          ).thenThrow(Exception('network error'));
        },
        build: () => NotificationsCubit(
          notificationRepository: repository,
          userId: userId,
        ),
        act: (cubit) => cubit.loadPreferences(),
        expect: () => [
          const NotificationsState(status: NotificationsStatus.loading),
          isA<NotificationsState>()
              .having(
                (s) => s.status,
                'status',
                NotificationsStatus.error,
              )
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                isNotNull,
              ),
        ],
      );
    });

    group('togglePush', () {
      blocTest<NotificationsCubit, NotificationsState>(
        'updates push enabled preference',
        setUp: () {
          when(
            () => repository.updatePreferences(any()),
          ).thenAnswer((_) async {});
        },
        build: () => NotificationsCubit(
          notificationRepository: repository,
          userId: userId,
        ),
        seed: () => NotificationsState(
          status: NotificationsStatus.loaded,
          preferences: testPreferences,
        ),
        act: (cubit) => cubit.togglePush(enabled: false),
        expect: () => [
          NotificationsState(
            status: NotificationsStatus.loaded,
            preferences: testPreferences.copyWith(pushEnabled: false),
          ),
        ],
        verify: (_) {
          verify(() => repository.updatePreferences(any())).called(1);
        },
      );
    });

    group('toggleEmail', () {
      blocTest<NotificationsCubit, NotificationsState>(
        'updates email enabled preference',
        setUp: () {
          when(
            () => repository.updatePreferences(any()),
          ).thenAnswer((_) async {});
        },
        build: () => NotificationsCubit(
          notificationRepository: repository,
          userId: userId,
        ),
        seed: () => NotificationsState(
          status: NotificationsStatus.loaded,
          preferences: testPreferences,
        ),
        act: (cubit) => cubit.toggleEmail(enabled: false),
        expect: () => [
          NotificationsState(
            status: NotificationsStatus.loaded,
            preferences: testPreferences.copyWith(emailEnabled: false),
          ),
        ],
      );
    });

    group('toggleOverspend', () {
      blocTest<NotificationsCubit, NotificationsState>(
        'updates overspend alerts preference',
        setUp: () {
          when(
            () => repository.updatePreferences(any()),
          ).thenAnswer((_) async {});
        },
        build: () => NotificationsCubit(
          notificationRepository: repository,
          userId: userId,
        ),
        seed: () => NotificationsState(
          status: NotificationsStatus.loaded,
          preferences: testPreferences,
        ),
        act: (cubit) => cubit.toggleOverspend(enabled: false),
        expect: () => [
          NotificationsState(
            status: NotificationsStatus.loaded,
            preferences: testPreferences.copyWith(overspendAlerts: false),
          ),
        ],
      );
    });

    group('toggleBillReminders', () {
      blocTest<NotificationsCubit, NotificationsState>(
        'updates bill reminders preference',
        setUp: () {
          when(
            () => repository.updatePreferences(any()),
          ).thenAnswer((_) async {});
        },
        build: () => NotificationsCubit(
          notificationRepository: repository,
          userId: userId,
        ),
        seed: () => NotificationsState(
          status: NotificationsStatus.loaded,
          preferences: testPreferences,
        ),
        act: (cubit) => cubit.toggleBillReminders(enabled: false),
        expect: () => [
          NotificationsState(
            status: NotificationsStatus.loaded,
            preferences: testPreferences.copyWith(billReminders: false),
          ),
        ],
      );
    });

    group('toggleDailyReminder', () {
      blocTest<NotificationsCubit, NotificationsState>(
        'updates daily logging reminder preference',
        setUp: () {
          when(
            () => repository.updatePreferences(any()),
          ).thenAnswer((_) async {});
        },
        build: () => NotificationsCubit(
          notificationRepository: repository,
          userId: userId,
        ),
        seed: () => NotificationsState(
          status: NotificationsStatus.loaded,
          preferences: testPreferences,
        ),
        act: (cubit) => cubit.toggleDailyReminder(enabled: false),
        expect: () => [
          NotificationsState(
            status: NotificationsStatus.loaded,
            preferences: testPreferences.copyWith(dailyLoggingReminder: false),
          ),
        ],
      );
    });

    group('toggleRecurringAlerts', () {
      blocTest<NotificationsCubit, NotificationsState>(
        'updates recurring transaction alerts preference',
        setUp: () {
          when(
            () => repository.updatePreferences(any()),
          ).thenAnswer((_) async {});
        },
        build: () => NotificationsCubit(
          notificationRepository: repository,
          userId: userId,
        ),
        seed: () => NotificationsState(
          status: NotificationsStatus.loaded,
          preferences: testPreferences,
        ),
        act: (cubit) => cubit.toggleRecurringAlerts(enabled: false),
        expect: () => [
          NotificationsState(
            status: NotificationsStatus.loaded,
            preferences: testPreferences.copyWith(
              recurringTransactionAlerts: false,
            ),
          ),
        ],
      );
    });

    group('toggleSharedActivity', () {
      blocTest<NotificationsCubit, NotificationsState>(
        'updates shared budget activity preference',
        setUp: () {
          when(
            () => repository.updatePreferences(any()),
          ).thenAnswer((_) async {});
        },
        build: () => NotificationsCubit(
          notificationRepository: repository,
          userId: userId,
        ),
        seed: () => NotificationsState(
          status: NotificationsStatus.loaded,
          preferences: testPreferences,
        ),
        act: (cubit) => cubit.toggleSharedActivity(enabled: false),
        expect: () => [
          NotificationsState(
            status: NotificationsStatus.loaded,
            preferences: testPreferences.copyWith(sharedBudgetActivity: false),
          ),
        ],
      );
    });
  });
}
