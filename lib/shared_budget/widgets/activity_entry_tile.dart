import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:sharing_repository/sharing_repository.dart';

/// A list tile displaying an activity log entry.
class ActivityEntryTile extends StatelessWidget {
  const ActivityEntryTile({required this.entry, super.key});

  final ActivityLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: Icon(_iconForAction(entry.action)),
      title: Text(_formatAction(entry, l10n)),
      subtitle: Text(_formatRelativeTime(entry.createdAt, l10n)),
      trailing: entry.details != null
          ? Text(
              entry.details!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            )
          : null,
    );
  }

  static IconData _iconForAction(String action) {
    return switch (action) {
      'invite_member' => Icons.person_add,
      'update_role' => Icons.edit,
      'remove_member' => Icons.remove_circle,
      'accept_invitation' => Icons.check_circle,
      _ => Icons.info_outline,
    };
  }

  static String _formatAction(
    ActivityLogEntry entry,
    AppLocalizations l10n,
  ) {
    return switch (entry.action) {
      'invite_member' =>
        l10n.activityLogInvitedUser(entry.userId),
      'update_role' =>
        l10n.activityLogUpdatedRole(entry.userId),
      'remove_member' =>
        l10n.activityLogRemovedUser(entry.userId),
      'accept_invitation' =>
        l10n.activityLogAcceptedInvitation(entry.userId),
      _ => l10n.activityLogActionByUser(
          entry.action,
          entry.userId,
        ),
    };
  }

  static String _formatRelativeTime(
    DateTime dateTime,
    AppLocalizations l10n,
  ) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return l10n.relativeTimeDaysAgo(diff.inDays);
    if (diff.inHours > 0) {
      return l10n.relativeTimeHoursAgo(diff.inHours);
    }
    if (diff.inMinutes > 0) {
      return l10n.relativeTimeMinutesAgo(diff.inMinutes);
    }
    return l10n.relativeTimeJustNow;
  }
}
