import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mvc/controllers/attendance_controller.dart';
import 'mvc/controllers/auth_controller.dart';
import 'mvc/controllers/employee_controller.dart';
import 'mvc/controllers/theme_controller.dart';
import 'mvc/views/auth/login_view.dart';
import 'services/biometric_service.dart';
import 'services/face_recognition_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

/// मुख्य फ़ंक्शन जहां से एप का निष्पादन शुरू होता है।
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// लोकल स्टोरेज सर्विस को तैयार करें।
  final StorageService storageService = await StorageService().init();
  Get.put<StorageService>(storageService);

  /// आवश्यक सर्विसेज को डिपेंडेंसी इंजेक्शन के माध्यम से उपलब्ध कराना।
  Get.put<BiometricService>(BiometricService());
  Get.put<FaceRecognitionService>(FaceRecognitionService());

  /// कंट्रोलर रजिस्ट्रेशन।
  Get.put<ThemeController>(ThemeController());
  Get.put<AuthController>(AuthController());
  Get.put<EmployeeController>(EmployeeController(storageService));
  Get.put<AttendanceController>(
    AttendanceController(storageService, Get.find<BiometricService>()),
  );

  runApp(const AttendanceApp());
}

/// AttendanceApp पूरा एप्लिकेशन रूट विजेट है।
class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (ThemeController controller) {
        return GetMaterialApp(
          title: 'PulseTime Attendance',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: controller.themeMode.value,
          home: const LoginView(),
        );
      },
    );
  }
}
