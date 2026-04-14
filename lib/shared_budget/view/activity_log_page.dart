import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared_budget/bloc/bloc.dart';
import 'package:envelope/shared_budget/widgets/widgets.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharing_repository/sharing_repository.dart';

/// Page displaying budget activity log with filters.
class ActivityLogPage extends StatelessWidget {
  const ActivityLogPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivityLogBloc(
        sharingRepository: context.read<SharingRepository>(),
        budgetId: budgetId,
      )..add(const ActivityLogStarted()),
      child: const _ActivityLogView(),
    );
  }
}

class _ActivityLogView extends StatelessWidget {
  const _ActivityLogView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<ActivityLogBloc, ActivityLogState>(
      listenWhen: (prev, curr) =>
          curr.status == ActivityLogStatus.error && curr.error != null,
      listener: (context, state) {
        showAppSnackBar(
          context,
          SnackBar(content: Text(l10n.activityLogErrorLoadFailed)),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.activityLogTitle),
          actions: [
            BlocBuilder<ActivityLogBloc, ActivityLogState>(
              buildWhen: (prev, curr) =>
                  prev.filterByUserId != curr.filterByUserId ||
                  prev.filterByAction != curr.filterByAction,
              builder: (context, state) {
                final hasFilters = state.filterByUserId != null ||
                    state.filterByAction != null;
                return IconButton(
                  onPressed: () => _showFilterSheet(context),
                  icon: hasFilters
                      ? const Badge(child: Icon(Icons.filter_list))
                      : const Icon(Icons.filter_list),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ActivityLogBloc, ActivityLogState>(
          builder: (context, state) {
            if (state.status == ActivityLogStatus.loading ||
                state.status == ActivityLogStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            final entries = state.filteredEntries;

            if (entries.isEmpty) {
              return Center(
                child: Text(
                  l10n.activityLogEmpty,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<ActivityLogBloc>()
                  ..add(const ActivityLogRefreshRequested());
                await bloc.stream
                    .firstWhere(
                      (s) => s.status == ActivityLogStatus.loaded,
                    )
                    .timeout(const Duration(seconds: 10))
                    .catchError((_) => bloc.state);
              },
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) =>
                    ActivityEntryTile(entry: entries[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    final l10n = context.l10n;
    final bloc = context.read<ActivityLogBloc>();
    final state = bloc.state;

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.activityLogFilterByMember,
              style: Theme.of(sheetContext).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              value: state.filterByUserId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(child: Text(l10n.filterAll)),
                for (final userId in state.uniqueUserIds)
                  DropdownMenuItem(value: userId, child: Text(userId)),
              ],
              onChanged: (value) {
                bloc.add(
                  ActivityLogFilterChanged(
                    userId: value,
                    action: state.filterByAction,
                  ),
                );
                Navigator.of(sheetContext).pop();
              },
            ),
            const SizedBox(height: 16),
            Text(
              l10n.activityLogFilterByAction,
              style: Theme.of(sheetContext).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              value: state.filterByAction,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(child: Text(l10n.filterAll)),
                for (final action in state.uniqueActions)
                  DropdownMenuItem(value: action, child: Text(action)),
              ],
              onChanged: (value) {
                bloc.add(
                  ActivityLogFilterChanged(
                    userId: state.filterByUserId,
                    action: value,
                  ),
                );
                Navigator.of(sheetContext).pop();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
