import 'dart:io';

import 'package:envelope/reports/bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Platform file writer for mobile/desktop.
ExportFileWriter? get platformExportFileWriter => _writeExportFile;

/// Platform file sharer for mobile/desktop.
FileSharer? get platformFileSharer => _shareFile;

Future<String> _writeExportFile({
  required String fileName,
  String? content,
  List<int>? bytes,
}) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$fileName');
  if (bytes != null) {
    await file.writeAsBytes(bytes);
  } else if (content != null) {
    await file.writeAsString(content);
  }
  return file.path;
}

Future<void> _shareFile(String filePath) async {
  await Share.shareXFiles([XFile(filePath)]);
}
