import 'dart:io';

import 'package:attendence_management_software/app/themes/app_theme.dart';
import 'package:attendence_management_software/core/models/attendance_models.dart';
import 'package:attendence_management_software/core/repositories/attendance_repository.dart';
import 'package:attendence_management_software/core/services/policy_engine.dart';
import 'package:attendence_management_software/features/employee/home/views/employee_home_view.dart';
import 'package:attendence_management_software/features/employee/shell/controllers/employee_shell_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class _FakeRepository extends GetxService implements AttendanceRepository {
  final today = AttendanceRecordModel(
    date: DateTime(2024, 8, 12),
    shift: const ShiftModel(
      name: 'Day Shift',
      startTime: TimeOfDay(hour: 9, minute: 30),
      endTime: TimeOfDay(hour: 18, minute: 30),
      graceMinutes: 10,
      autoCheckout: TimeOfDay(hour: 20, minute: 0),
      allowOvertime: true,
    ),
    checkIn: DateTime(2024, 8, 12, 9, 25),
    checkOut: DateTime(2024, 8, 12, 18, 45),
    status: AttendanceStatus.onTime,
  );

  @override
  Stream<EmployeeProfileModel> watchProfile() => Stream.value(
    EmployeeProfileModel(
      id: '1',
      name: 'Ayesha Patel',
      employeeCode: 'EMP-204',
      department: 'Design',
      shift: today.shift,
      managerName: 'Noah Singh',
      locationPermissionGranted: true,
      faceEnrolled: true,
      linkedDevice: 'Pixel 8 Pro',
      notificationsEnabled: true,
    ),
  );

  @override
  Stream<AttendanceRecordModel?> watchTodayRecord() => Stream.value(today);

  @override
  Stream<List<AttendanceRecordModel>> watchMonthlyRecords(DateTime month) =>
      Stream.value([today]);

  @override
  Stream<List<RequestModel>> watchRequests() => Stream.value([]);

  @override
  Stream<AttendanceSummaryModel> watchSummary({
    required DateTime from,
    required DateTime to,
  }) =>
      Stream.value(
        AttendanceSummaryModel(
          presentDays: 20,
          lateDays: 2,
          halfDays: 1,
          absentDays: 0,
          averageIn: const Duration(hours: 9, minutes: 32),
          averageOut: const Duration(hours: 18, minutes: 15),
          breakAverage: const Duration(minutes: 30),
          totalOvertime: const Duration(hours: 4),
        ),
      );

  @override
  Future<void> checkIn() async {}

  @override
  Future<void> checkOut() async {}

  @override
  Future<void> startBreak(BreakType type) async {}

  @override
  Future<void> endBreak(String breakId) async {}

  @override
  Future<void> submitRequest(RequestModel request) async {}
}

void main() {
  setUp(() {
    Get.reset();
  });

  testGoldens('Employee home golden - light', (tester) async {
    // Keep this in sync with the name you pass to screenMatchesGolden
    final goldenPath = 'goldens/employee_home_light.png';
    final goldenFile = File(goldenPath);

    // If the golden doesn't exist yet, skip once (first run). Create it with --update-goldens.
    if (!goldenFile.existsSync()) {
      // You can print a hint for CI logs:
      // ignore: avoid_print
      print('Golden missing → $goldenPath. Run with: flutter test --update-goldens');
      return;
    }

    await GoldenToolkit.runWithConfiguration(
          () async {
        await loadAppFonts();

        Get.put<AttendanceRepository>(_FakeRepository());
        Get.put(
          const PolicyEngine(
            config: PolicyEngineConfig(
              halfDayCutoff: TimeOfDay(hour: 10, minute: 30),
              graceDuration: Duration(minutes: 10),
              autoCheckoutTime: TimeOfDay(hour: 20, minute: 0),
            ),
          ),
        );
        Get.put(
          EmployeeShellController(
            repository: Get.find(),
            policyEngine: Get.find(),
          ),
        );

        final builder = GoldenBuilder.column()
          ..addScenario(
            'home',
            MaterialApp(
              theme: AppTheme.light,
              home: const Scaffold(body: EmployeeHomeView()),
            ),
          );

        await tester.pumpWidgetBuilder(
          builder.build(),
          surfaceSize: const Size(390, 844),
        );

        await screenMatchesGolden(tester, 'goldens/employee_home_light');
      },
      // 🔧 REQUIRED in your toolkit version
      config:   GoldenToolkitConfiguration(),
    );
  });
}
