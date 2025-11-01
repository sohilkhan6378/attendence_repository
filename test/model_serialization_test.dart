import 'package:attendence_management_software/modules/attendance/models/attendance_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('मॉडल सीरियलाइज़ेशन', () {
    test('कर्मचारी मॉडल JSON में सेव होकर वापस सही मान देता है', () {
      final ShiftModel shift = ShiftModel(
        id: 'shift-1',
        name: 'General',
        start: const TimeOfDay(hour: 9, minute: 30),
        end: const TimeOfDay(hour: 18, minute: 30),
        graceMinutes: 10,
        breakPolicy: const BreakPolicy(maxBreaks: 3, paidBreaks: 2),
        autoCheckoutTime: const TimeOfDay(hour: 20, minute: 0),
      );

      final EmployeeModel employee = EmployeeModel(
        id: 'id-1',
        code: 'EMP123',
        name: 'Test User',
        department: 'QA',
        role: 'Engineer',
        shift: shift,
        managerName: 'Lead One',
        location: 'Noida',
        languageCode: 'en_US',
        themeMode: 'light',
        faceEnrolled: true,
        fingerprintEnrolled: true,
      );

      final Map<String, dynamic> json = employee.toJson();
      final EmployeeModel parsed = EmployeeModel.fromJson(json);

      expect(parsed.name, employee.name);
      expect(parsed.department, employee.department);
      expect(parsed.role, employee.role);
      expect(parsed.shift.name, employee.shift.name);
      expect(parsed.faceEnrolled, isTrue);
      expect(parsed.fingerprintEnrolled, isTrue);
    });

    test('अटेंडेंस डे JSON सीरियलाइज़ेशन', () {
      final AttendanceDay day = AttendanceDay(
        date: DateTime(2024, 6, 10),
        checkIn: DateTime(2024, 6, 10, 9, 45),
        checkOut: DateTime(2024, 6, 10, 18, 15),
        status: AttendanceStatus.present,
        breaks: <BreakPeriod>[
          BreakPeriod(
            start: DateTime(2024, 6, 10, 13, 0),
            end: DateTime(2024, 6, 10, 13, 30),
          ),
          BreakPeriod(
            start: DateTime(2024, 6, 10, 16, 45),
            end: DateTime(2024, 6, 10, 16, 55),
          ),
        ],
        autoCheckoutApplied: false,
        notes: 'सभी प्रक्रियाएँ समय पर पूरी हुईं',
      );

      final Map<String, dynamic> json = day.toJson();
      final AttendanceDay parsed = AttendanceDay.fromJson(json);

      expect(parsed.date, day.date);
      expect(parsed.status, day.status);
      expect(parsed.breaks.length, 2);
      expect(parsed.breaks.first.end, isNotNull);
      expect(parsed.totalBreakDuration.inMinutes, 40);
    });

    test('पेंडिंग अटेंडेंस इवेंट JSON सीरियलाइज़ेशन', () {
      final AttendanceDay day = AttendanceDay(
        date: DateTime(2024, 6, 11),
        checkIn: DateTime(2024, 6, 11, 9, 25),
        status: AttendanceStatus.late,
        notes: 'ग्रेस पीरियड के भीतर चेक-इन',
      );

      final PendingAttendanceEvent event = PendingAttendanceEvent(
        id: 'queue-1',
        employeeId: 'emp-1',
        day: day,
        createdAt: DateTime(2024, 6, 11, 9, 26),
      );

      final Map<String, dynamic> json = event.toJson();
      final PendingAttendanceEvent parsed =
          PendingAttendanceEvent.fromJson(json);

      expect(parsed.id, event.id);
      expect(parsed.employeeId, event.employeeId);
      expect(parsed.day.status, AttendanceStatus.late);
      expect(parsed.day.notes, day.notes);
    });
  });
}
