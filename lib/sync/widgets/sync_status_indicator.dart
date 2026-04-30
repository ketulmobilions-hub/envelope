import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/sync/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_repository/sync_repository.dart';

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<SyncBloc, SyncBlocState>(
      builder: (context, state) {
        if (!state.isOnline) {
          return _buildIcon(
            context,
            icon: Icons.cloud_off,
            color: colorScheme.onSurfaceVariant,
            tooltip: context.l10n.syncStatusOffline,
            pendingChanges: state.syncStatus.pendingChanges,
            enabled: false,
          );
        }

        return switch (state.syncStatus.state) {
          SyncState.idle => _buildIcon(
            context,
            icon: Icons.cloud_outlined,
            color: colorScheme.onSurfaceVariant,
            tooltip: null,
            pendingChanges: state.syncStatus.pendingChanges,
          ),
          SyncState.syncing => _buildSyncing(context),
          SyncState.synced => _buildIcon(
            context,
            icon: Icons.cloud_done,
            color: colorScheme.primary,
            tooltip: context.l10n.syncStatusSynced,
            pendingChanges: 0,
          ),
          SyncState.error => _buildIcon(
            context,
            icon: Icons.cloud_off,
            color: colorScheme.error,
            tooltip:
                state.syncStatus.errorMessage ?? context.l10n.syncStatusError,
            pendingChanges: state.syncStatus.pendingChanges,
          ),
        };
      },
    );
  }

  Widget _buildIcon(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String? tooltip,
    required int pendingChanges,
    bool enabled = true,
  }) {
    Widget child = IconButton(
      icon: Icon(icon, color: color),
      tooltip: tooltip,
      onPressed: enabled
          ? () => context.read<SyncBloc>().add(const SyncRequested())
          : null,
    );

    if (pendingChanges > 0) {
      child = Badge(
        label: Text(
          context.l10n.syncPendingChanges(pendingChanges),
        ),
        child: child,
      );
    }

    return child;
  }

  Widget _buildSyncing(BuildContext context) {
    return IconButton(
      icon: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      tooltip: context.l10n.syncStatusSyncing,
      onPressed: null,
    );
  }
}
