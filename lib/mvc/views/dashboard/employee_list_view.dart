import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/employee_controller.dart';
import '../../models/face_capture_result.dart';
import '../../models/employee_model.dart';
import '../attendance/face_capture_view.dart';
import '../widgets/primary_button.dart';
import 'register_employee_view.dart';

/// EmployeeListView सभी कर्मचारियों का विस्तृत विवरण दिखाती है।
class EmployeeListView extends StatelessWidget {
  const EmployeeListView({super.key});

  EmployeeController get _controller => Get.find<EmployeeController>();

  /// चेहरा दुबारा कैप्चर करने का कार्य।
  Future<void> _refreshFace(EmployeeModel employee) async {
    final FaceCaptureResult? result = await Get.to<FaceCaptureResult>(
      () => FaceCaptureView(
        persistCapture: true,
        ownerId: employee.id,
      ),
    );
    if (result != null) {
      final EmployeeModel updated = employee.copyWith(
        faceTemplate: result.template,
        faceImagePath: result.imagePath,
      );
      await _controller.updateEmployee(updated);
      Get.snackbar('अपडेट सफल', '${employee.name} का चेहरा पुनः सुरक्षित कर दिया गया।');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('कर्मचारी सूची'),
      ),
      body: Obx(
        () {
          if (_controller.employees.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.sentiment_satisfied, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'अभी तक कोई कर्मचारी नहीं जोड़ा गया है।',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'पहला कर्मचारी जोड़ें',
                    icon: Icons.person_add,
                    onPressed: () => Get.to(() => const RegisterEmployeeView()),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int index) {
              final EmployeeModel employee = _controller.employees[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: employee.faceImagePath != null
                                ? FileImage(File(employee.faceImagePath!))
                                : null,
                            child: employee.faceImagePath == null
                                ? const Icon(Icons.person_outline, size: 32)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  employee.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${employee.designation} · ${employee.department}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  'कर्मचारी कोड: ${employee.employeeCode}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: employee.fingerprintRegistered
                                  ? Colors.green.withOpacity(0.12)
                                  : Colors.orange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  employee.fingerprintRegistered
                                      ? Icons.fingerprint
                                      : Icons.gpp_bad,
                                  color: employee.fingerprintRegistered
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  employee.fingerprintRegistered
                                      ? 'फिंगरप्रिंट ऑन'
                                      : 'फिंगरप्रिंट ऑफ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: <Widget>[
                          OutlinedButton.icon(
                            onPressed: () => _refreshFace(employee),
                            icon: const Icon(Icons.face_retouching_natural),
                            label: const Text('चेहरा अपडेट करें'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              Get.snackbar(
                                'फिंगरप्रिंट स्थिति',
                                employee.fingerprintRegistered
                                    ? 'यह कर्मचारी बायोमेट्रिक प्रमाणीकरण के लिए तैयार है।'
                                    : 'डिवाइस सेटिंग्स से फिंगरप्रिंट सक्षम करें।',
                              );
                            },
                            icon: const Icon(Icons.fingerprint),
                            label: const Text('फिंगरप्रिंट स्थिति'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: _controller.employees.length,
          );
        },
      ),
    );
  }
}
