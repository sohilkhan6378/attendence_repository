import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/repositories/attendance_repository.dart';
import '../../core/repositories/local/local_attendance_repository.dart';
import '../../core/services/policy_engine.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceRepository>(LocalAttendanceRepository.new, fenix: true);
    Get.put(
      const PolicyEngine(
        config: PolicyEngineConfig(
          halfDayCutoff: TimeOfDay(hour: 10, minute: 30),
          graceDuration: Duration(minutes: 10),
          autoCheckoutTime: TimeOfDay(hour: 20, minute: 0),
          allowOvertime: true,
        ),
      ),
      permanent: true,
    );
  }
}
