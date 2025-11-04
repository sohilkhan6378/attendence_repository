import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../modules/attendance/models/attendance_models.dart';

part 'offline_database.g.dart';

/// Drift आधारित लोकल डेटाबेस जो ऑफ़लाइन पेंडिंग इवेंट्स को संभालता है।
class PendingEvents extends Table {
  TextColumn get id => text()();

  TextColumn get employeeId => text()();

  TextColumn get payload => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}

@DriftDatabase(tables: <Type>[PendingEvents])
class OfflineDatabase extends _$OfflineDatabase {
  OfflineDatabase._(super.executor);

  /// फ़ाइल आधारित डेटाबेस खोलना जो प्रोडक्शन ऐप में इस्तेमाल होगा।
  static Future<OfflineDatabase> open() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dir.path, 'attendance_offline.sqlite'));
    final OfflineDatabase database = OfflineDatabase._(
      NativeDatabase(
        file,
        logStatements: false,
      ),
    );
    // ensureOpen कॉल करने से LazyInitialization जैसी समस्याएँ खत्म हो जाती हैं।
    await database.customSelect('SELECT 1').get();
    return database;
  }

  /// इन-मेमोरी डेटाबेस जो यूनिट टेस्ट में उपयोगी है।
  static Future<OfflineDatabase> openInMemory() async {
    final OfflineDatabase database = OfflineDatabase._(
      NativeDatabase.memory(logStatements: false),
    );
    await database.customSelect('SELECT 1').get();
    return database;
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator migrator) => migrator.createAll(),
      );

  /// सभी पेंडिंग इवेंट्स को समय क्रम में लोड करें।
  Future<List<PendingAttendanceEvent>> loadPendingEvents() async {
    final List<PendingEvent> rows = await (select(pendingEvents)
          ..orderBy([
            (PendingEvents table) => OrderingTerm(
                  expression: table.createdAt,
                  mode: OrderingMode.asc,
                ),
          ]))
        .get();
    return rows
        .map((PendingEvent row) => PendingAttendanceEvent(
              id: row.id,
              employeeId: row.employeeId,
              day: AttendanceDay.fromJson(
                jsonDecode(row.payload) as Map<String, dynamic>,
              ),
              createdAt: row.createdAt,
            ))
        .toList();
  }

  /// किसी नए इवेंट को क्यू में जोड़ना।
  Future<void> insertEvent(PendingAttendanceEvent event) async {
    await into(pendingEvents).insertOnConflictUpdate(
      PendingEventsCompanion(
        id: Value<String>(event.id),
        employeeId: Value<String>(event.employeeId),
        payload: Value<String>(jsonEncode(event.day.toJson())),
        createdAt: Value<DateTime>(event.createdAt),
      ),
    );
  }

  /// सभी इवेंट्स हटाएँ।
  Future<void> clearEvents() => delete(pendingEvents).go();
}
