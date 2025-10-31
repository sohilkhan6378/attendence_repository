import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../attendance/controllers/attendance_controller.dart';
import '../../attendance/models/attendance_models.dart';
import '../controllers/profile_controller.dart';

/// ProfileView यूज़र प्रोफ़ाइल, भाषा व थीम सेटिंग्स संभालता है।
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    final AttendanceController attendanceController =
        Get.find<AttendanceController>();
    return Obx(
      () {
        final EmployeeModel? employee = controller.employee;
        if (employee == null) {
          return Scaffold(
            appBar: AppBar(title: Text('profile'.tr)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text('profile'.tr)),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Text(employee.name.characters.first),
                  ),
                  title: Text(employee.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Text('${employee.department} | ${employee.role}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Emp ID: ${employee.code}'),
                      Text('Manager: ${employee.managerName}'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('settings'.tr,
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: employee.languageCode,
                  items: const [
                    DropdownMenuItem(value: 'en_US', child: Text('English')),
                    DropdownMenuItem(value: 'hi_IN', child: Text('हिंदी')),
                    DropdownMenuItem(value: 'ar_SA', child: Text('Arabic')),
                    DropdownMenuItem(value: 'es_ES', child: Text('Español')),
                  ],
                  onChanged: (value) {
                    if (value != null) controller.updateLanguage(value);
                  },
                  decoration: InputDecoration(labelText: 'language'.tr),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: employee.themeMode,
                  items: const [
                    DropdownMenuItem(value: 'system', child: Text('System')), 
                    DropdownMenuItem(value: 'light', child: Text('Light')),
                    DropdownMenuItem(value: 'dark', child: Text('Dark')),
                  ],
                  onChanged: (value) {
                    if (value != null) controller.updateTheme(value);
                  },
                  decoration: InputDecoration(labelText: 'theme'.tr),
                ),
                const SizedBox(height: 24),
                Text('Biometrics',
                    style: Theme.of(context).textTheme.displaySmall),
                SwitchListTile.adaptive(
                  title: Text('face_auth'.tr),
                  subtitle: const Text('Policy enabled होने पर आवश्यक।'),
                  value: employee.faceEnrolled,
                  onChanged: (value) => controller.markFaceEnrollment(value),
                ),
                SwitchListTile.adaptive(
                  title: Text('finger_auth'.tr),
                  subtitle: const Text('डिवाइस पर सुरक्षित रूप से स्टोर।'),
                  value: employee.fingerprintEnrolled,
                  onChanged: (value) => controller.markFingerprintEnrollment(value),
                ),
                const SizedBox(height: 24),
                ListTile(
                  title: const Text('Queue size'),
                  subtitle: Text(
                      'Pending offline punches: ${attendanceController.pendingQueueLength}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
