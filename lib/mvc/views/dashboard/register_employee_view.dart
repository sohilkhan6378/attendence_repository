import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/employee_controller.dart';
import '../../models/face_capture_result.dart';
import '../attendance/face_capture_view.dart';
import '../widgets/primary_button.dart';

/// RegisterEmployeeView नए कर्मचारी को सिस्टम में जोड़ने की स्क्रीन है।
class RegisterEmployeeView extends StatefulWidget {
  const RegisterEmployeeView({super.key});

  @override
  State<RegisterEmployeeView> createState() => _RegisterEmployeeViewState();
}

class _RegisterEmployeeViewState extends State<RegisterEmployeeView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  bool _fingerprintEnabled = true;
  FaceCaptureResult? _faceResult;
  late String _draftEmployeeId;

  EmployeeController get _employeeController => Get.find<EmployeeController>();

  @override
  void initState() {
    super.initState();
    _draftEmployeeId = const Uuid().v4();
  }

  /// चेहरे का डेटा कैप्चर करने वाली विधि।
  Future<void> _captureFace() async {
    final FaceCaptureResult? result = await Get.to<FaceCaptureResult>(
      () => FaceCaptureView(
        persistCapture: true,
        ownerId: _draftEmployeeId,
      ),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 400),
    );
    if (result != null) {
      setState(() {
        _faceResult = result;
      });
    }
  }

  /// फॉर्म सेव करने वाली विधि।
  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_faceResult == null) {
      Get.snackbar('चेहरा आवश्यक', 'कर्मचारी को जोड़ने से पहले चेहरा कैप्चर करें।');
      return;
    }
    await _employeeController.addEmployee(
      name: _nameController.text.trim(),
      department: _departmentController.text.trim(),
      designation: _designationController.text.trim(),
      fingerprintRegistered: _fingerprintEnabled,
      template: _faceResult?.template,
      faceImagePath: _faceResult?.imagePath,
      id: _draftEmployeeId,
    );
    if (!mounted) return;
    Get.snackbar('सफलता', 'कर्मचारी सफलतापूर्वक जोड़ दिया गया।');
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('नया कर्मचारी जोड़ें'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'कर्मचारी विवरण',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'पूरा नाम',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'नाम दर्ज करना आवश्यक है।';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'विभाग',
                  prefixIcon: Icon(Icons.apartment_rounded),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'विभाग दर्ज करें।';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _designationController,
                decoration: const InputDecoration(
                  labelText: 'पदनाम',
                  prefixIcon: Icon(Icons.work_outline_rounded),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'पदनाम आवश्यक है।';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'फिंगरप्रिंट सक्षम करें',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'सिस्टम बायोमेट्रिक प्रमाणीकरण के लिए डिवाइस सेंसर का उपयोग करेगा।',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _fingerprintEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _fingerprintEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.face_retouching_natural_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'चेहरा प्रमाणीकरण सेटअप',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'कैमरा से चेहरा कैप्चर करके उच्च सटीकता वाला फेस टेम्पलेट सेव करें। यह भविष्य की हाज़िरी के लिए आवश्यक है।',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      if (_faceResult?.imagePath != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_faceResult!.imagePath!),
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'अभी तक कोई चेहरा सेव नहीं हुआ है।',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: _faceResult == null ? 'चेहरा कैप्चर करें' : 'चेहरा पुनः कैप्चर करें',
                        icon: Icons.photo_camera_front_rounded,
                        onPressed: _captureFace,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => PrimaryButton(
                  text: 'कर्मचारी सेव करें',
                  icon: Icons.save_rounded,
                  onPressed:
                      _employeeController.isBusy.value ? null : _saveEmployee,
                  isLoading: _employeeController.isBusy.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
