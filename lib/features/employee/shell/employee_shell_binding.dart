import 'package:get/get.dart';

import '../../../core/repositories/attendance_repository.dart';
import '../../../core/services/policy_engine.dart';
import 'controllers/employee_shell_controller.dart';

class EmployeeShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      EmployeeShellController(
        repository: Get.find<AttendanceRepository>(),
        policyEngine: Get.find<PolicyEngine>(),
      ),
    );
  }
}
