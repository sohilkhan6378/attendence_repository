import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString selectedRole = 'employee'.obs;

  void login() async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.permissions, arguments: selectedRole.value);
  }

  void switchRole(String value) {
    selectedRole.value = value;
  }

  void continueToApp() {
    final role = Get.arguments as String? ?? selectedRole.value;
    if (role == 'admin') {
      Get.offAllNamed(AppRoutes.adminShell);
    } else {
      Get.offAllNamed(AppRoutes.employeeShell);
    }
  }
}
