import 'dart:async';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../modules/attendance/models/attendance_models.dart';
import 'local_db/offline_database.dart';

/// OfflineQueueService Drift डेटाबेस का उपयोग कर पेंडिंग इवेंट्स को स्टोर करता है।
class OfflineQueueService extends GetxService {
  OfflineQueueService({OfflineDatabase? database})
      : _database = database,
        _ownsDatabase = database == null;

  OfflineDatabase? _database;
  final bool _ownsDatabase;
  final RxList<PendingAttendanceEvent> _queue =
      <PendingAttendanceEvent>[].obs;

  int get queueLength => _queue.length;

  List<PendingAttendanceEvent> get queue => List<PendingAttendanceEvent>.unmodifiable(_queue);

  Future<OfflineQueueService> init() async {
    _database ??= await OfflineDatabase.open();
    final List<PendingAttendanceEvent> stored =
        await _database!.loadPendingEvents();
    _queue.assignAll(stored);
    return this;
  }

  /// किसी इवेंट को कतार में जोड़ना।
  Future<void> enqueueAttendanceEvent({
    required String employeeId,
    required AttendanceDay day,
  }) async {
    final PendingAttendanceEvent event = PendingAttendanceEvent(
      id: const Uuid().v4(),
      employeeId: employeeId,
      day: day,
      createdAt: DateTime.now(),
    );
    await _database!.insertEvent(event);
    _queue.add(event);
  }

  /// सिंक होने के बाद आइटम हटाएँ।
  Future<void> clearQueue() async {
    await _database!.clearEvents();
    _queue.clear();
  }

  @override
  void onClose() {
    if (_ownsDatabase) {
      final Future<void>? closeFuture = _database?.close();
      if (closeFuture != null) {
        unawaited(closeFuture);
      }
    }
    super.onClose();
  }
}
