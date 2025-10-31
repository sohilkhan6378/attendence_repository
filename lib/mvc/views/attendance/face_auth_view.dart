import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/attendance_controller.dart';
import '../../controllers/employee_controller.dart';
import '../../models/employee_model.dart';
import '../../models/face_capture_result.dart';
import '../widgets/primary_button.dart';
import 'face_capture_view.dart';

/// FaceAuthView लाइव कैमरा के माध्यम से चेहरा पहचान कर हाज़िरी दर्ज करती है।
class FaceAuthView extends StatefulWidget {
  const FaceAuthView({super.key});

  @override
  State<FaceAuthView> createState() => _FaceAuthViewState();
}

class _FaceAuthViewState extends State<FaceAuthView> {
  EmployeeModel? _selectedEmployee;

  EmployeeController get _employeeController => Get.find<EmployeeController>();
  AttendanceController get _attendanceController =>
      Get.find<AttendanceController>();

  /// ड्रॉपडाउन से चयनित कर्मचारी की फेस पहचान प्रक्रिया।
  Future<void> _startFaceAuthentication() async {
    final EmployeeModel? employee = _selectedEmployee;
    if (employee == null) {
      Get.snackbar('कर्मचारी चुनें', 'पहले किसी कर्मचारी का चयन करें।');
      return;
    }
    if (employee.faceTemplate == null) {
      Get.snackbar('फेस डाटा अनुपलब्ध', 'इस कर्मचारी के लिए चेहरा सेव नहीं किया गया है।');
      return;
    }
    final FaceCaptureResult? result = await Get.to<FaceCaptureResult>(
      () => FaceCaptureView(
        persistCapture: false,
        ownerId: employee.id,
      ),
    );
    if (result != null) {
      final bool success = await _attendanceController.markWithFace(
        employee: employee,
        capturedTemplate: result.template,
      );
      if (success) {
        Get.snackbar('हाज़िरी दर्ज', '${employee.name} की उपस्थिति मार्क कर दी गयी।');
      } else {
        Get.snackbar('मेल नहीं', 'चेहरा पहचान में असफल रहा, कृपया पुनः प्रयास करें।');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('चेहरे से हाज़िरी'),
      ),
      body: Obx(
        () {
          if (_employeeController.employees.isEmpty) {
            return Center(
              child: Text(
                'कृपया पहले कर्मचारी जोड़ें, तभी फेस प्रमाणीकरण संभव है।',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                'जिस कर्मचारी की उपस्थिति लेनी है उसे चुनें, फिर कैमरा से चेहरा स्कैन करें।',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<EmployeeModel>(
                decoration: const InputDecoration(
                  labelText: 'कर्मचारी चुनें',
                ),
                items: _employeeController.employees
                    .map(
                      (EmployeeModel employee) => DropdownMenuItem<EmployeeModel>(
                        value: employee,
                        child: Text(employee.name),
                      ),
                    )
                    .toList(),
                onChanged: (EmployeeModel? value) {
                  setState(() {
                    _selectedEmployee = value;
                  });
                },
                value: _selectedEmployee,
              ),
              const SizedBox(height: 20),
              if (_selectedEmployee != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: _selectedEmployee!.faceImagePath != null
                              ? FileImage(File(_selectedEmployee!.faceImagePath!))
                              : null,
                          child: _selectedEmployee!.faceImagePath == null
                              ? const Icon(Icons.person_outline, size: 32)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _selectedEmployee!.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedEmployee!.designation,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'फेस सिग्नेचर उपलब्ध',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const Spacer(),
              PrimaryButton(
                text: 'फेस स्कैन शुरू करें',
                icon: Icons.camera_front,
                onPressed: _attendanceController.isProcessing.value
                    ? null
                    : _startFaceAuthentication,
                isLoading: _attendanceController.isProcessing.value,
              ),
              const SizedBox(height: 12),
              Text(
                _attendanceController.statusMessage.value,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          );
        },
      ),
    );
  }
}
