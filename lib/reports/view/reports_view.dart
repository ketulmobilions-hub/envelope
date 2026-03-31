import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/reports/bloc/bloc.dart';
import 'package:envelope/reports/view/budget_vs_actual_report_page.dart';
import 'package:envelope/reports/view/export_report_page.dart';
import 'package:envelope/reports/view/net_worth_report_page.dart';
import 'package:envelope/reports/view/spending_report_page.dart';
import 'package:envelope/reports/view/trends_report_page.dart';
import 'package:envelope/reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<ReportsBloc, ReportsState>(
      listenWhen: (prev, curr) =>
          prev.error != curr.error && curr.error != null,
      listener: (context, state) {
        final message = switch (state.error!) {
          ReportsError.loadFailed => l10n.reportsErrorLoad,
          ReportsError.exportFailed => l10n.reportsErrorExport,
          ReportsError.snapshotFailed => l10n.reportsErrorLoad,
        };
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.reportsTitle)),
        body: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            if (state.status == ReportsStatus.initial ||
                (state.status == ReportsStatus.loading &&
                    state.budgetPeriods.isEmpty)) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.reportsSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                const SizedBox(height: 16),
                _ReportsGrid(budgetId: budgetId),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ReportsGrid extends StatelessWidget {
  const _ReportsGrid({required this.budgetId});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<ReportsBloc>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ReportCard(
                icon: Icons.pie_chart,
                title: l10n.reportsSpendingTitle,
                subtitle: l10n.reportsSpendingSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider.value(
                      value: bloc,
                      child: const SpendingReportPage(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ReportCard(
                icon: Icons.trending_up,
                title: l10n.reportsTrendsTitle,
                subtitle: l10n.reportsTrendsSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider.value(
                      value: bloc,
                      child: const TrendsReportPage(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ReportCard(
                icon: Icons.compare_arrows,
                title: l10n.reportsBudgetVsActualTitle,
                subtitle: l10n.reportsBudgetVsActualSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider.value(
                      value: bloc,
                      child: const BudgetVsActualReportPage(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ReportCard(
                icon: Icons.account_balance,
                title: l10n.reportsNetWorthTitle,
                subtitle: l10n.reportsNetWorthSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider.value(
                      value: bloc,
                      child: const NetWorthReportPage(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ReportCard(
          icon: Icons.file_download,
          title: l10n.reportsExportTitle,
          subtitle: l10n.reportsExportSubtitle,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => BlocProvider.value(
                value: bloc,
                child: const ExportReportPage(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
