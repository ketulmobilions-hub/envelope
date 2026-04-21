import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/reports/bloc/bloc.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/reports/widgets/widgets.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report_repository/report_repository.dart';

/// Net worth report page with line chart.
class NetWorthReportPage extends StatefulWidget {
  const NetWorthReportPage({super.key});

  @override
  State<NetWorthReportPage> createState() => _NetWorthReportPageState();
}

class _NetWorthReportPageState extends State<NetWorthReportPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReportsBloc>().add(const NetWorthReportRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsNetWorthTitle)),
      body: BlocListener<ReportsBloc, ReportsState>(
        listenWhen: (prev, curr) =>
            prev.netWorthSnapshots.length < curr.netWorthSnapshots.length &&
            curr.status == ReportsStatus.loaded,
        listener: (context, state) {
          showAppSnackBar(
            context,
            SnackBar(content: Text(l10n.reportsSnapshotRecorded)),
          );
        },
        child: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            final hasData = state.netWorthSnapshots.isNotEmpty;
            final isLoading = state.status == ReportsStatus.loading;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (hasData) ...[
                  // Legend
                  const _NetWorthLegend(),
                  const SizedBox(height: 16),
                  NetWorthLineChart(snapshots: state.netWorthSnapshots),
                  const SizedBox(height: 24),
                  // Latest snapshot summary
                  _LatestSnapshotCard(
                    snapshot: ([...state.netWorthSnapshots]
                          ..sort(
                            (a, b) => b.date.compareTo(a.date),
                          ))
                        .first,
                  ),
                  const SizedBox(height: 16),
                ],
                if (!hasData && !isLoading)
                  const ReportEmptyState(),
                // Record snapshot button — always shown once loaded so users
                // can record their first snapshot from the empty state.
                if (!isLoading &&
                    state.activeReport == ReportType.netWorth) ...[
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<ReportsBloc>().add(
                        const NetWorthSnapshotRequested(),
                      );
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: Text(l10n.reportsRecordSnapshot),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NetWorthLegend extends StatelessWidget {
  const _NetWorthLegend();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendDot(color: AppColors.income, label: l10n.reportsAssets),
        const SizedBox(width: 16),
        _LegendDot(
          color: AppColors.expense,
          label: l10n.reportsLiabilities,
        ),
        const SizedBox(width: 16),
        _LegendDot(color: AppColors.primary, label: l10n.reportsNetWorth),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _LatestSnapshotCard extends StatelessWidget {
  const _LatestSnapshotCard({required this.snapshot});

  final NetWorthSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    l10n.reportsAssets,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                  Text(
                    formatCents(snapshot.assets, symbol: symbol),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.income,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    l10n.reportsLiabilities,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                  Text(
                    formatCents(snapshot.liabilities, symbol: symbol),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.expense,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    l10n.reportsNetWorth,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                  Text(
                    formatCents(snapshot.netWorth, symbol: symbol),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
