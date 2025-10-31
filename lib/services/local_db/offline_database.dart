import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../modules/attendance/models/attendance_models.dart';

/// Drift आधारित लोकल डेटाबेस जो ऑफ़लाइन पेंडिंग इवेंट्स को स्टोर करता है।
class OfflineDatabase {
  OfflineDatabase._(this._executor);

  final QueryExecutor _executor;

  /// डिफ़ॉल्ट फ़ाइल आधारित डेटाबेस खोलना।
  static Future<OfflineDatabase> open() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dir.path, 'attendance_offline.sqlite'));
    final QueryExecutor executor = NativeDatabase(file, logStatements: false);
    final OfflineDatabase database = OfflineDatabase._(executor);
    await database._createSchema();
    return database;
  }

  /// इन-मेमोरी डेटाबेस जो यूनिट टेस्ट में सहायक है।
  static Future<OfflineDatabase> openInMemory() async {
    final QueryExecutor executor = NativeDatabase.memory(logStatements: false);
    final OfflineDatabase database = OfflineDatabase._(executor);
    await database._createSchema();
    return database;
  }

  Future<void> _createSchema() async {
    await _executor.runCustom('''
      CREATE TABLE IF NOT EXISTS pending_events (
        id TEXT PRIMARY KEY,
        employee_id TEXT NOT NULL,
        payload TEXT NOT NULL,
        created_at INTEGER NOT NULL
      );
    ''');
  }

  /// सभी पेंडिंग इवेंट्स को लोड करें।
  Future<List<PendingAttendanceEvent>> loadPendingEvents() async {
    final List<Map<String, Object?>> rows = await _executor.runSelect(
      'SELECT id, employee_id, payload, created_at FROM pending_events ORDER BY created_at ASC',
      const <Object?>[],
    );
    return rows
        .map((Map<String, Object?> row) => PendingAttendanceEvent(
              id: row['id']! as String,
              employeeId: row['employee_id']! as String,
              day: AttendanceDay.fromJson(
                jsonDecode(row['payload']! as String) as Map<String, dynamic>,
              ),
              createdAt:
                  DateTime.fromMillisecondsSinceEpoch(row['created_at']! as int),
            ))
        .toList();
  }

  /// किसी इवेंट को सुरक्षित करें।
  Future<void> insertEvent(PendingAttendanceEvent event) async {
    await _executor.runInsert(
      'INSERT OR REPLACE INTO pending_events (id, employee_id, payload, created_at) VALUES (?, ?, ?, ?)',
      <Object?>[
        event.id,
        event.employeeId,
        jsonEncode(event.day.toJson()),
        event.createdAt.millisecondsSinceEpoch,
      ],
    );
  }

  /// पूरे क्यू को साफ़ करें।
  Future<void> clearEvents() async {
    await _executor.runDelete(
      'DELETE FROM pending_events',
      const <Object?>[],
    );
  }

  Future<void> close() async {
    await _executor.close();
  }
}
