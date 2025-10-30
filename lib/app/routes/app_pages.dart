import 'package:get/get.dart';

import '../../features/admin/shell/admin_shell_binding.dart';
import '../../features/admin/shell/views/admin_shell_view.dart';
import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/permissions_view.dart';
import '../../features/employee/shell/employee_shell_binding.dart';
import '../../features/employee/shell/views/employee_shell_view.dart';
import '../../features/root/bindings/root_binding.dart';
import '../../features/root/views/root_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.login, page: () => const LoginView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.permissions, page: () => const PermissionsView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.root, page: () => const RootView(), binding: RootBinding()),
    GetPage(name: AppRoutes.employeeShell, page: () => const EmployeeShellView(), binding: EmployeeShellBinding()),
    GetPage(name: AppRoutes.adminShell, page: () => const AdminShellView(), binding: AdminShellBinding()),
  ];
}
