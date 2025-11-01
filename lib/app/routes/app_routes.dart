/// नामित रूट्स की परिभाषा ताकि पूरे एप में समान नाम प्रयुक्त हों।
abstract class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String organization = '/organization';
  static const String permissions = '/permissions';
  static const String employeeShell = '/employee';
  static const String adminShell = '/admin';
  static const String markAttendance = '/mark-attendance';
  static const String calendar = '/calendar';
  static const String requests = '/requests';
  static const String reports = '/reports';
  static const String profile = '/profile';
}
