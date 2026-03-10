import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/connection/native.dart'
    if (dart.library.js_interop)
        'package:envelope_local_storage/src/database/connection/web.dart'
    as platform;

QueryExecutor openConnection() => platform.openConnection();
