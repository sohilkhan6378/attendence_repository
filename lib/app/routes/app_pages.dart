import 'package:get/get.dart';

import '../../modules/admin/views/admin_shell_view.dart';
import '../../modules/attendance/views/calendar_view.dart';
import '../../modules/attendance/views/employee_home_view.dart';
import '../../modules/attendance/views/mark_attendance_sheet.dart';
import '../../modules/attendance/views/requests_view.dart';
import '../../modules/attendance/views/reports_view.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/organization_select_view.dart';
import '../../modules/auth/views/permissions_view.dart';
import '../../modules/profile/views/profile_view.dart';
import 'app_routes.dart';

/// रूट कॉन्फ़िगरेशन जो GetX नेविगेशन के माध्यम से स्क्रीन जोड़ता है।
class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.login, page: LoginView.new),
    GetPage(name: AppRoutes.organization, page: OrganizationSelectView.new),
    GetPage(name: AppRoutes.permissions, page: PermissionsView.new),
    GetPage(name: AppRoutes.employeeShell, page: EmployeeHomeView.new),
    GetPage(name: AppRoutes.markAttendance, page: MarkAttendanceSheet.new),
    GetPage(name: AppRoutes.calendar, page: CalendarView.new),
    GetPage(name: AppRoutes.requests, page: RequestsView.new),
    GetPage(name: AppRoutes.reports, page: ReportsView.new),
    GetPage(name: AppRoutes.profile, page: ProfileView.new),
    GetPage(name: AppRoutes.adminShell, page: AdminShellView.new),
  ];
}
