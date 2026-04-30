import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/shared_budget/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

/// Page for inviting members by email or shareable link.
class InvitePage extends StatefulWidget {
  const InvitePage({
    required this.budgetId,
    required this.sharedBudgetBloc,
    super.key,
  });

  final String budgetId;
  final SharedBudgetBloc sharedBudgetBloc;

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  final _emailController = TextEditingController();
  String _emailRole = MemberRole.viewer;
  String _linkRole = MemberRole.viewer;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider.value(
      value: widget.sharedBudgetBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<SharedBudgetBloc, SharedBudgetState>(
            listenWhen: (prev, curr) =>
                curr.status == SharedBudgetStatus.error && curr.error != null,
            listener: (context, state) {
              final message = switch (state.error!) {
                SharedBudgetError.inviteFailed =>
                  l10n.sharedBudgetErrorInviteFailed,
                SharedBudgetError.memberLimitReached =>
                  l10n.sharedBudgetErrorMemberLimit,
                _ => l10n.sharedBudgetErrorInviteFailed,
              };
              showAppSnackBar(context, SnackBar(content: Text(message)));
            },
          ),
          BlocListener<SharedBudgetBloc, SharedBudgetState>(
            listenWhen: (prev, curr) =>
                prev.success != curr.success && curr.success != null,
            listener: (context, state) {
              showAppSnackBar(
                context,
                SnackBar(
                  content: Text(l10n.sharedBudgetInviteSent),
                ),
              );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(title: Text(l10n.sharedBudgetInvite)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // -- Email Invite Section --
              Text(
                l10n.sharedBudgetInviteByEmail,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.sharedBudgetEmailLabel,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _RoleDropdown(
                value: _emailRole,
                onChanged: (role) => setState(() => _emailRole = role),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _sendEmailInvite,
                child: Text(l10n.sharedBudgetSendInvite),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // -- Link Invite Section --
              Text(
                l10n.sharedBudgetInviteByLink,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _RoleDropdown(
                value: _linkRole,
                onChanged: (role) {
                  setState(() => _linkRole = role);
                  widget.sharedBudgetBloc.add(
                    const SharedBudgetInviteLinkCleared(),
                  );
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _generateAndShareLink,
                child: Text(l10n.sharedBudgetGenerateLink),
              ),
              BlocBuilder<SharedBudgetBloc, SharedBudgetState>(
                buildWhen: (prev, curr) =>
                    prev.generatedInviteLink != curr.generatedInviteLink,
                builder: (context, state) {
                  if (state.generatedInviteLink == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: FilledButton.icon(
                      onPressed: () => _shareLink(state.generatedInviteLink!),
                      icon: const Icon(Icons.share),
                      label: Text(l10n.sharedBudgetShareLink),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // -- Pending Invites Section --
              BlocBuilder<SharedBudgetBloc, SharedBudgetState>(
                buildWhen: (prev, curr) =>
                    prev.pendingInvites != curr.pendingInvites,
                builder: (context, state) {
                  if (state.pendingInvites.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final dateFormat = DateFormat.yMMMd();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.invitePendingSection,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...state.pendingInvites.map(
                        (invite) => ListTile(
                          leading: const Icon(Icons.link),
                          title: Text(invite.role),
                          subtitle: Text(
                            l10n.inviteExpires(
                              dateFormat.format(invite.expiresAt),
                            ),
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              widget.sharedBudgetBloc.add(
                                SharedBudgetInviteRevoked(invite.id),
                              );
                              showAppSnackBar(
                                context,
                                SnackBar(
                                  content: Text(l10n.inviteRevoked),
                                ),
                              );
                            },
                            child: Text(
                              l10n.inviteRevoke,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  void _sendEmailInvite() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    if (!_emailRegex.hasMatch(email)) {
      final l10n = context.l10n;
      showAppSnackBar(
        context,
        SnackBar(content: Text(l10n.sharedBudgetInvalidEmail)),
      );
      return;
    }

    widget.sharedBudgetBloc.add(
      SharedBudgetMemberInvited(email: email, role: _emailRole),
    );

    _emailController.clear();
  }

  void _generateAndShareLink() {
    widget.sharedBudgetBloc.add(
      SharedBudgetInviteLinkRequested(role: _linkRole),
    );
  }

  Future<void> _shareLink(String inviteId) async {
    final link = 'https://envelope.app/invite/$inviteId';
    await Share.share(link);

    if (mounted) {
      final l10n = context.l10n;
      showAppSnackBar(
        context,
        SnackBar(content: Text(l10n.sharedBudgetLinkCopied)),
      );
    }
  }
}

class _RoleDropdown extends StatelessWidget {
  const _RoleDropdown({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: l10n.sharedBudgetRoleLabel,
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(
          value: MemberRole.editor,
          child: Text(l10n.sharedBudgetRoleEditor),
        ),
        DropdownMenuItem(
          value: MemberRole.viewer,
          child: Text(l10n.sharedBudgetRoleViewer),
        ),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
