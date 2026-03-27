import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/notifications/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.user?.id;
    if (userId == null) return const SizedBox.shrink();

    return BlocProvider(
      create: (context) => NotificationsCubit(
        notificationRepository: context.read<NotificationRepository>(),
        userId: userId,
      )..loadPreferences(),
      child: const NotificationSettingsView(),
    );
  }
}

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationSettingsTitle),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.status == NotificationsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == NotificationsStatus.error) {
            return Center(
              child: Text(l10n.notificationError),
            );
          }

          final prefs = state.preferences;
          if (prefs == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final cubit = context.read<NotificationsCubit>();

          return ListView(
            children: [
              _SectionHeader(title: l10n.notificationPushSectionTitle),
              SwitchListTile(
                title: Text(l10n.notificationPushEnabled),
                value: prefs.pushEnabled,
                onChanged: (v) => cubit.togglePush(enabled: v),
              ),
              if (prefs.pushEnabled) ...[
                SwitchListTile(
                  title: Text(l10n.notificationOverspendAlerts),
                  value: prefs.overspendAlerts,
                  onChanged: (v) => cubit.toggleOverspend(enabled: v),
                ),
                SwitchListTile(
                  title: Text(l10n.notificationBillReminders),
                  value: prefs.billReminders,
                  onChanged: (v) => cubit.toggleBillReminders(enabled: v),
                ),
                SwitchListTile(
                  title: Text(l10n.notificationDailyLoggingReminder),
                  value: prefs.dailyLoggingReminder,
                  onChanged: (v) => cubit.toggleDailyReminder(enabled: v),
                ),
                SwitchListTile(
                  title: Text(l10n.notificationRecurringAlerts),
                  value: prefs.recurringTransactionAlerts,
                  onChanged: (v) => cubit.toggleRecurringAlerts(enabled: v),
                ),
                SwitchListTile(
                  title: Text(l10n.notificationSharedBudgetActivity),
                  value: prefs.sharedBudgetActivity,
                  onChanged: (v) => cubit.toggleSharedActivity(enabled: v),
                ),
              ],
              _SectionHeader(title: l10n.notificationEmailSectionTitle),
              SwitchListTile(
                title: Text(l10n.notificationEmailEnabled),
                value: prefs.emailEnabled,
                onChanged: (v) => cubit.toggleEmail(enabled: v),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
