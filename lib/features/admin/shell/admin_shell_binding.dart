import 'package:get/get.dart';

import 'controllers/admin_shell_controller.dart';

class AdminShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminShellController());
  }
}
