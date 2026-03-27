import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/notifications/cubit/cubit.dart';
import 'package:envelope/notifications/view/notification_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notification_repository/notification_repository.dart';

import '../../helpers/pump_app.dart';

class MockNotificationsCubit extends MockCubit<NotificationsState>
    implements NotificationsCubit {}

void main() {
  late MockNotificationsCubit cubit;

  const testPreferences = NotificationPreferences(
    userId: 'user-1',
  );

  setUp(() {
    cubit = MockNotificationsCubit();
  });

  group('NotificationSettingsView', () {
    testWidgets('renders loading indicator when loading', (tester) async {
      when(() => cubit.state).thenReturn(
        const NotificationsState(status: NotificationsStatus.loading),
      );

      await tester.pumpApp(
        BlocProvider<NotificationsCubit>.value(
          value: cubit,
          child: const NotificationSettingsView(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error text when error', (tester) async {
      when(() => cubit.state).thenReturn(
        const NotificationsState(
          status: NotificationsStatus.error,
          errorMessage: 'Something went wrong',
        ),
      );

      await tester.pumpApp(
        BlocProvider<NotificationsCubit>.value(
          value: cubit,
          child: const NotificationSettingsView(),
        ),
      );

      expect(
        find.text('Failed to load notification preferences.'),
        findsOneWidget,
      );
    });

    testWidgets('renders all toggles when loaded', (tester) async {
      when(() => cubit.state).thenReturn(
        NotificationsState(
          status: NotificationsStatus.loaded,
          preferences: testPreferences,
        ),
      );

      await tester.pumpApp(
        BlocProvider<NotificationsCubit>.value(
          value: cubit,
          child: const NotificationSettingsView(),
        ),
      );

      expect(find.text('Notification Settings'), findsOneWidget);
      expect(find.text('Push Notifications'), findsOneWidget);
      expect(find.text('Enable Push Notifications'), findsOneWidget);
      expect(find.text('Overspend Alerts'), findsOneWidget);
      expect(find.text('Bill Reminders'), findsOneWidget);
      expect(find.text('Daily Logging Reminder'), findsOneWidget);
      expect(find.text('Recurring Transaction Alerts'), findsOneWidget);
      expect(find.text('Shared Budget Activity'), findsOneWidget);
      expect(find.text('Email Notifications'), findsOneWidget);
      expect(find.text('Enable Email Notifications'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNWidgets(7));
    });

    testWidgets('hides sub-toggles when push is disabled', (tester) async {
      when(() => cubit.state).thenReturn(
        NotificationsState(
          status: NotificationsStatus.loaded,
          preferences: testPreferences.copyWith(pushEnabled: false),
        ),
      );

      await tester.pumpApp(
        BlocProvider<NotificationsCubit>.value(
          value: cubit,
          child: const NotificationSettingsView(),
        ),
      );

      // Only push toggle + email toggle should show (2 total).
      expect(find.byType(SwitchListTile), findsNWidgets(2));
      expect(find.text('Overspend Alerts'), findsNothing);
    });
  });
}
