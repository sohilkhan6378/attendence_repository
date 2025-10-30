import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:attendence_management_software/core/models/attendance_models.dart';
import 'package:attendence_management_software/core/services/policy_engine.dart';

void main() {
  group('PolicyEngine', () {
    final config = PolicyEngineConfig(
      halfDayCutoff: const TimeOfDay(hour: 10, minute: 30),
      graceDuration: const Duration(minutes: 10),
      autoCheckoutTime: const TimeOfDay(hour: 20, minute: 0),
      allowOvertime: true,
    );
    final engine = PolicyEngine(config: config);
    final shift = ShiftModel(
      name: 'Day Shift',
      startTime: const TimeOfDay(hour: 9, minute: 30),
      endTime: const TimeOfDay(hour: 18, minute: 30),
      graceMinutes: 10,
      autoCheckout: const TimeOfDay(hour: 20, minute: 0),
      allowOvertime: true,
    );

    test('marks half day when check-in is after cutoff', () {
      final record = AttendanceRecordModel(
        date: DateTime(2024, 8, 12),
        shift: shift,
        checkIn: DateTime(2024, 8, 12, 11, 0),
      );
      final result = engine.evaluate(today: record, now: record.checkIn);
      expect(result.triggersHalfDay, isTrue);
      expect(result.status, AttendanceStatus.halfDay);
    });

    test('within grace but not half day', () {
      final record = AttendanceRecordModel(
        date: DateTime(2024, 8, 12),
        shift: shift,
        checkIn: DateTime(2024, 8, 12, 9, 36),
      );
      final result = engine.evaluate(today: record, now: record.checkIn);
      expect(result.withinGrace, isTrue);
      expect(result.status, AttendanceStatus.late);
    });

    test('computes overtime when checkout after shift end', () {
      final record = AttendanceRecordModel(
        date: DateTime(2024, 8, 12),
        shift: shift,
        checkIn: DateTime(2024, 8, 12, 9, 20),
        checkOut: DateTime(2024, 8, 12, 19, 45),
      );
      final result = engine.evaluate(today: record, now: record.checkOut!);
      expect(result.overtimeDuration, const Duration(hours: 1, minutes: 15));
    });
  });
}
