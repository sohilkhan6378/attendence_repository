import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/attendance_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/employee_controller.dart';
import '../../controllers/theme_controller.dart';
import '../attendance/attendance_log_view.dart';
import '../attendance/face_auth_view.dart';
import '../attendance/fingerprint_auth_view.dart';
import '../attendance/manual_entry_view.dart';
import '../auth/login_view.dart';
import 'employee_list_view.dart';
import 'register_employee_view.dart';
import '../widgets/action_card.dart';
import '../widgets/stat_tile.dart';

/// DashboardView एप का मुख्य कंट्रोल सेंटर है।
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final EmployeeController employeeController =
        Get.find<EmployeeController>();
    final AttendanceController attendanceController =
        Get.find<AttendanceController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PulseTime डैशबोर्ड'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.brightness_6_outlined),
            onPressed: () {
              final ThemeMode newMode =
                  themeController.themeMode.value == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
              themeController.updateTheme(newMode);
              Get.changeThemeMode(newMode);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              authController.logout();
              Get.offAll(() => const LoginView());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'स्वागत है, ${authController.currentUserName.value}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'एक ही स्थान पर कर्मचारियों की हाज़िरी, बायोमेट्रिक सत्यापन और रिपोर्ट देखें।',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.6,
                  ),
                  children: <Widget>[
                    StatTile(
                      title: 'कुल कर्मचारी',
                      value: employeeController.totalEmployees.toString(),
                      icon: Icons.people_alt_rounded,
                    ),
                    StatTile(
                      title: 'आज की प्रविष्टियाँ',
                      value: attendanceController.records
                          .where((record) => record.timestamp.day == DateTime.now().day &&
                              record.timestamp.month == DateTime.now().month &&
                              record.timestamp.year == DateTime.now().year)
                          .length
                          .toString(),
                      icon: Icons.calendar_today_rounded,
                      color: Colors.orange,
                    ),
                    StatTile(
                      title: 'फेस सक्षम कर्मचारी',
                      value: employeeController.employees
                          .where((employee) => employee.faceTemplate != null)
                          .length
                          .toString(),
                      icon: Icons.face_retouching_natural,
                      color: Colors.purple,
                    ),
                    StatTile(
                      title: 'फिंगरप्रिंट सक्षम',
                      value: employeeController.employees
                          .where((employee) => employee.fingerprintRegistered)
                          .length
                          .toString(),
                      icon: Icons.fingerprint_rounded,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'त्वरित कार्रवाई',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool isWide = constraints.maxWidth > 700;
                    return GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 3 : 1,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isWide ? 1.5 : 2.6,
                      ),
                      children: <Widget>[
                        ActionCard(
                          title: 'नया कर्मचारी जोड़ें',
                          subtitle: 'चेहरा और फिंगरप्रिंट दोनों सुरक्षित करें।',
                          icon: Icons.person_add_alt_1,
                          onTap: () => Get.to(() => const RegisterEmployeeView()),
                        ),
                        ActionCard(
                          title: 'फेस से हाज़िरी',
                          subtitle: 'लाइव कैमरा से चेहरा सत्यापित करें।',
                          icon: Icons.face_6_outlined,
                          onTap: () => Get.to(() => const FaceAuthView()),
                          color: Colors.purple,
                        ),
                        ActionCard(
                          title: 'फिंगरप्रिंट से हाज़िरी',
                          subtitle: 'डिवाइस के बायोमेट्रिक सेंसर का उपयोग करें।',
                          icon: Icons.fingerprint,
                          onTap: () => Get.to(() => const FingerprintAuthView()),
                          color: Colors.green,
                        ),
                        ActionCard(
                          title: 'मैनुअल प्रविष्टि',
                          subtitle: 'विशेष परिस्थितियों में मैनुअल हाज़िरी दर्ज करें।',
                          icon: Icons.edit_calendar_rounded,
                          onTap: () => Get.to(() => const ManualEntryView()),
                          color: Colors.orange,
                        ),
                        ActionCard(
                          title: 'कर्मचारी सूची',
                          subtitle: 'सभी कर्मचारियों का विवरण देखें।',
                          icon: Icons.list_alt,
                          onTap: () => Get.to(() => const EmployeeListView()),
                          color: Colors.blueAccent,
                        ),
                        ActionCard(
                          title: 'हाज़िरी रिपोर्ट',
                          subtitle: 'दिनवार रिकॉर्ड और स्टेटस देखें।',
                          icon: Icons.bar_chart_rounded,
                          onTap: () => Get.to(() => const AttendanceLogView()),
                          color: Colors.teal,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
