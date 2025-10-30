
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/onboarding_screen.dart';
import '../../features/auth/views/splash_screen.dart';
import '../../features/employee/calendar/controllers/calendar_controller.dart';
import '../../features/employee/calendar/views/calendar_screen.dart';
import '../../features/employee/home/controllers/home_controller.dart';
import '../../features/employee/home/views/home_screen.dart';
import '../../features/employee/profile/controllers/profile_controller.dart';
import '../../features/employee/profile/views/profile_screen.dart';
import '../../features/employee/reports/controllers/reports_controller.dart';
import '../../features/employee/reports/views/reports_screen.dart';
import '../../features/employee/requests/controllers/requests_controller.dart';
import '../../features/employee/requests/views/create_request_screen.dart';
import '../../features/employee/requests/views/requests_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
      }),
    ),
    GetPage(
      name: AppRoutes.CALENDAR,
      page: () => const CalendarScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CalendarController());
      }),
    ),
    GetPage(
      name: AppRoutes.REQUESTS,
      page: () => const RequestsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RequestsController());
      }),
    ),
    GetPage(
      name: AppRoutes.CREATE_REQUEST,
      page: () => const CreateRequestScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RequestsController());
      }),
    ),
    GetPage(
      name: AppRoutes.REPORTS,
      page: () => const ReportsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ReportsController());
      }),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProfileController());
      }),
    ),
  ];
}
