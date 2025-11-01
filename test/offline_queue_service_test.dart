import 'package:flutter_test/flutter_test.dart';

import 'package:attendence_management_software/modules/attendance/models/attendance_models.dart';
import 'package:attendence_management_software/services/local_db/offline_database.dart';
import 'package:attendence_management_software/services/offline_queue_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OfflineQueueService persistence', () { // स्थायी स्टोरेज से जुड़े टेस्ट
    late OfflineDatabase database;
    late OfflineQueueService service;

    setUp(() async {
      database = await OfflineDatabase.openInMemory();
      service = OfflineQueueService(database: database);
      await service.init();
    });

    tearDown(() async {
      await database.close();
    });

    test('enqueue stores event and loads back from database', () async {
      final AttendanceDay day = AttendanceDay(
        date: DateTime(2024, 10, 1),
        checkIn: DateTime(2024, 10, 1, 9, 30),
        status: AttendanceStatus.present,
      );

      await service.enqueueAttendanceEvent(employeeId: 'emp-1', day: day);

      expect(service.queue, hasLength(1));
      expect(service.queue.first.employeeId, 'emp-1');

      final OfflineQueueService rehydrated =
          OfflineQueueService(database: database);
      await rehydrated.init();

      expect(rehydrated.queue, hasLength(1));
      expect(rehydrated.queue.first.day.checkIn, day.checkIn);
    });

    test('clearQueue wipes persisted rows', () async {
      final AttendanceDay day = AttendanceDay(
        date: DateTime(2024, 10, 2),
        checkIn: DateTime(2024, 10, 2, 9, 45),
        status: AttendanceStatus.late,
      );

      await service.enqueueAttendanceEvent(employeeId: 'emp-2', day: day);
      expect(service.queue, isNotEmpty);

      await service.clearQueue();
      expect(service.queue, isEmpty);

      final OfflineQueueService rehydrated =
          OfflineQueueService(database: database);
      await rehydrated.init();
      expect(rehydrated.queue, isEmpty);
    });
  });
}
