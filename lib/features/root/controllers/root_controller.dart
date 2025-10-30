import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class RootController extends GetxController {
  final RxString currentRole = 'employee'.obs;

  void setRole(String role) {
    currentRole.value = role;
  }

  void launch() {
    if (currentRole.value == 'admin') {
      Get.offAllNamed(AppRoutes.adminShell);
    } else {
      Get.offAllNamed(AppRoutes.employeeShell);
    }
  }
}
