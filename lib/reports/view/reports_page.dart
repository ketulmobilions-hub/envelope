import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/reports/bloc/bloc.dart';
import 'package:envelope/reports/view/export_stub.dart'
    if (dart.library.io) 'package:envelope/reports/view/export_io.dart'
    if (dart.library.html) 'package:envelope/reports/view/export_web.dart';
import 'package:envelope/reports/view/reports_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report_repository/report_repository.dart';

/// Page that provides [ReportsBloc] and displays the reports hub.
class ReportsPage extends StatelessWidget {
  const ReportsPage({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsBloc(
        reportRepository: context.read<ReportRepository>(),
        budgetId: budgetId,
        exportFileWriter: platformExportFileWriter,
        fileSharer: platformFileSharer,
      )..add(const ReportsStarted()),
      child: ReportsView(budgetId: budgetId),
    );
  }
}
