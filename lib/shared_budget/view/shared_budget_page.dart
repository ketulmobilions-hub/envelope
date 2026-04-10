import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared_budget/bloc/bloc.dart';
import 'package:envelope/shared_budget/view/activity_log_page.dart';
import 'package:envelope/shared_budget/view/invite_page.dart';
import 'package:envelope/shared_budget/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharing_repository/sharing_repository.dart';

/// Page that provides [SharedBudgetBloc] and displays the members list.
class SharedBudgetPage extends StatelessWidget {
  const SharedBudgetPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider(
      create: (_) => SharedBudgetBloc(
        sharingRepository: context.read<SharingRepository>(),
        budgetRepository: context.read<BudgetRepository>(),
        budgetId: budgetId,
        currentUserId: user.id,
        currentUserName: user.displayName.isNotEmpty
            ? user.displayName
            : user.email,
      )..add(const SharedBudgetStarted()),
      child: SharedBudgetView(budgetId: budgetId),
    );
  }
}

class SharedBudgetView extends StatelessWidget {
  const SharedBudgetView({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<SharedBudgetBloc, SharedBudgetState>(
      listenWhen: (prev, curr) =>
          curr.status == SharedBudgetStatus.error && curr.error != null,
      listener: (context, state) {
        final message = switch (state.error!) {
          SharedBudgetError.loadFailed => l10n.sharedBudgetErrorLoadFailed,
          SharedBudgetError.inviteFailed => l10n.sharedBudgetErrorInviteFailed,
          SharedBudgetError.updateRoleFailed =>
            l10n.sharedBudgetErrorUpdateRoleFailed,
          SharedBudgetError.removeFailed => l10n.sharedBudgetErrorRemoveFailed,
          SharedBudgetError.memberLimitReached =>
            l10n.sharedBudgetErrorMemberLimit,
        };
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.sharedBudgetTitle),
          actions: [
            IconButton(
              onPressed: () => _openActivityLog(context),
              icon: const Icon(Icons.history),
            ),
            IconButton(
              onPressed: () => _openInvite(context),
              icon: const Icon(Icons.person_add),
            ),
          ],
        ),
        body: BlocBuilder<SharedBudgetBloc, SharedBudgetState>(
          builder: (context, state) {
            if (state.status == SharedBudgetStatus.loading ||
                state.status == SharedBudgetStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.members.isEmpty) {
              return _EmptyState(onInvite: () => _openInvite(context));
            }

            final bloc = context.read<SharedBudgetBloc>();
            final isOwner = bloc.isOwner;

            return Column(
              children: [
                if (!state.canInvite) const MemberLimitBanner(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final b = context.read<SharedBudgetBloc>()
                        ..add(const SharedBudgetRefreshRequested());
                      await b.stream
                          .firstWhere(
                            (s) =>
                                s.status != SharedBudgetStatus.refreshing,
                          )
                          .timeout(const Duration(seconds: 10))
                          .catchError((_) => b.state);
                    },
                    child: ListView.builder(
                      itemCount: state.members.length,
                      itemBuilder: (context, index) {
                        final member = state.members[index];
                        return MemberListTile(
                          member: member,
                          isOwner: isOwner,
                          isCurrentUser:
                              member.userId == bloc.currentUserId,
                          onChangeRole: () =>
                              _showChangeRoleDialog(context, member),
                          onRemove: () =>
                              _showRemoveDialog(context, member),
                          onRevokeInvite: () => context
                              .read<SharedBudgetBloc>()
                              .add(SharedBudgetMemberRemoved(member.id)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openInvite(BuildContext context) async {
    final bloc = context.read<SharedBudgetBloc>();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => InvitePage(
          budgetId: budgetId,
          sharedBudgetBloc: bloc,
        ),
      ),
    );
  }

  Future<void> _openActivityLog(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActivityLogPage(budgetId: budgetId),
      ),
    );
  }

  Future<void> _showChangeRoleDialog(
    BuildContext context,
    BudgetMember member,
  ) async {
    final l10n = context.l10n;
    var selectedRole = member.role;

    final newRole = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.sharedBudgetChangeRole),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final role in [MemberRole.editor, MemberRole.viewer])
                RadioListTile<String>(
                  title: Text(_localizedRole(role, l10n)),
                  value: role,
                  groupValue: selectedRole,
                  onChanged: (value) {
                    setState(() => selectedRole = value!);
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                MaterialLocalizations.of(dialogContext)
                    .cancelButtonLabel,
              ),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(selectedRole),
              child: Text(
                MaterialLocalizations.of(dialogContext)
                    .okButtonLabel,
              ),
            ),
          ],
        ),
      ),
    );

    if (newRole != null && newRole != member.role && context.mounted) {
      context.read<SharedBudgetBloc>().add(
            SharedBudgetMemberRoleUpdated(
              memberId: member.id,
              role: newRole,
            ),
          );
    }
  }

  Future<void> _showRemoveDialog(
    BuildContext context,
    BudgetMember member,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.sharedBudgetRemoveConfirmTitle),
        content: Text(l10n.sharedBudgetRemoveConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              MaterialLocalizations.of(dialogContext)
                  .cancelButtonLabel,
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor:
                  Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.sharedBudgetRemoveMember),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<SharedBudgetBloc>().add(
            SharedBudgetMemberRemoved(member.id),
          );
    }
  }

  static String _localizedRole(String role, AppLocalizations l10n) {
    return switch (role) {
      MemberRole.owner => l10n.sharedBudgetRoleOwner,
      MemberRole.editor => l10n.sharedBudgetRoleEditor,
      _ => l10n.sharedBudgetRoleViewer,
    };
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onInvite});

  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.sharedBudgetEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.sharedBudgetEmptySubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onInvite,
            icon: const Icon(Icons.person_add),
            label: Text(l10n.sharedBudgetInvite),
          ),
        ],
      ),
    );
  }
}
