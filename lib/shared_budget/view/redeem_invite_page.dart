import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_repository/sharing_repository.dart';

/// Page shown when a user opens an invite link (`/invite/:inviteId`).
///
/// If authenticated, shows accept button. If not, redirects to login.
class RedeemInvitePage extends StatefulWidget {
  const RedeemInvitePage({required this.inviteId, super.key});

  final String inviteId;

  @override
  State<RedeemInvitePage> createState() => _RedeemInvitePageState();
}

class _RedeemInvitePageState extends State<RedeemInvitePage> {
  bool _loading = false;
  String? _error;
  bool _success = false;
  String? _budgetName;

  Future<void> _redeem() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await context.read<SharingRepository>().redeemInvite(
        widget.inviteId,
      );
      setState(() {
        _loading = false;
        _success = true;
        _budgetName = result['budgetName'] as String?;
      });
    } on SharingException catch (e) {
      setState(() {
        _loading = false;
        _error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = context.read<AuthBloc>().state;

    if (authState.status != AuthStatus.authenticated) {
      // Redirect to login — after auth, the router will bring them back.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.redeemInviteTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mail_outline, size: 64),
              const SizedBox(height: 24),
              if (_success) ...[
                Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.redeemInviteSuccess(_budgetName ?? ''),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.go('/home'),
                  child: Text(l10n.redeemInviteGoHome),
                ),
              ] else ...[
                Text(
                  l10n.redeemInviteMessage,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
                if (_loading)
                  const CircularProgressIndicator()
                else
                  FilledButton(
                    onPressed: _redeem,
                    child: Text(l10n.redeemInviteAccept),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
