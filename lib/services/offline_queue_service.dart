import 'dart:convert';

import 'package:get/get.dart';

import '../modules/attendance/models/attendance_models.dart';
import 'storage_service.dart';

/// OfflineQueueService पेंडिंग उपस्थिति इवेंट्स को सिंक के लिए होल्ड करता है।
class OfflineQueueService extends GetxService {
  OfflineQueueService(this._storageService);

  final StorageService _storageService;
  static const String _queueKey = 'pending_queue';
  final RxList<Map<String, dynamic>> _queue = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get queue => _queue;

  Future<OfflineQueueService> init() async {
    final raw = _storageService.preferences.getString(_queueKey);
    if (raw != null) {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      _queue.assignAll(List<Map<String, dynamic>>.from(list));
    }
    return this;
  }

  /// किसी इवेंट को कतार में जोड़ना।
  Future<void> enqueueAttendanceEvent({
    required String employeeId,
    required AttendanceDay day,
  }) async {
    _queue.add({
      'employeeId': employeeId,
      'payload': day.toJson(),
    });
    await _persist();
  }

  /// सिंक होने के बाद आइटम हटाएँ।
  Future<void> clearQueue() async {
    _queue.clear();
    await _persist();
  }

  Future<void> _persist() async {
    await _storageService.preferences
        .setString(_queueKey, jsonEncode(_queue.toList()));
  }
}
