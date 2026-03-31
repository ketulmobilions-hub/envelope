import 'package:envelope/reports/bloc/bloc.dart';

/// Export not supported on web.
ExportFileWriter? get platformExportFileWriter => null;

/// Sharing not supported on web.
FileSharer? get platformFileSharer => null;
