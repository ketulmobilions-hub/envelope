import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared_budget/widgets/role_badge.dart';
import 'package:flutter/material.dart';
import 'package:sharing_repository/sharing_repository.dart';

/// A list tile displaying a budget member with role and actions.
class MemberListTile extends StatelessWidget {
  const MemberListTile({
    required this.member,
    required this.isOwner,
    required this.isCurrentUser,
    this.onChangeRole,
    this.onRemove,
    this.onRevokeInvite,
    super.key,
  });

  final BudgetMember member;
  final bool isOwner;
  final bool isCurrentUser;
  final VoidCallback? onChangeRole;
  final VoidCallback? onRemove;
  final VoidCallback? onRevokeInvite;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isPending = member.acceptedAt == null;
    final showActions = isOwner && !isCurrentUser;

    final displayName = _displayName(member);

    return ListTile(
      leading: CircleAvatar(
        child: Text(
          displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
        ),
      ),
      title: Text(displayName),
      subtitle: Row(
        children: [
          RoleBadge(role: member.role),
          if (isPending) ...[
            const SizedBox(width: 8),
            Text(
              l10n.sharedBudgetPending,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
      trailing: showActions
          ? PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'change_role') {
                  onChangeRole?.call();
                } else if (value == 'remove') {
                  onRemove?.call();
                } else if (value == 'revoke_invite') {
                  onRevokeInvite?.call();
                }
              },
              itemBuilder: (context) => isPending
                  ? [
                      PopupMenuItem(
                        value: 'revoke_invite',
                        child: Text(l10n.inviteRevoke),
                      ),
                    ]
                  : [
                      PopupMenuItem(
                        value: 'change_role',
                        child: Text(l10n.sharedBudgetChangeRole),
                      ),
                      PopupMenuItem(
                        value: 'remove',
                        child: Text(l10n.sharedBudgetRemoveMember),
                      ),
                    ],
            )
          : null,
    );
  }

  /// Show email from `invitedVia` for pending invites, userId otherwise.
  static String _displayName(BudgetMember member) {
    if (member.userId != null) return member.userId!;
    final via = member.invitedVia;
    if (via.startsWith('email:')) return via.substring(6);
    return via;
  }
}
