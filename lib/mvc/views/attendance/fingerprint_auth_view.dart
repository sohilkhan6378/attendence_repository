import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/attendance_controller.dart';
import '../../controllers/employee_controller.dart';
import '../../models/employee_model.dart';
import '../widgets/primary_button.dart';

/// FingerprintAuthView डिवाइस के बायोमेट्रिक सेंसर से हाज़िरी दर्ज करती है।
class FingerprintAuthView extends StatefulWidget {
  const FingerprintAuthView({super.key});

  @override
  State<FingerprintAuthView> createState() => _FingerprintAuthViewState();
}

class _FingerprintAuthViewState extends State<FingerprintAuthView> {
  EmployeeModel? _selectedEmployee;

  EmployeeController get _employeeController => Get.find<EmployeeController>();
  AttendanceController get _attendanceController =>
      Get.find<AttendanceController>();

  /// चयनित कर्मचारी के लिए बायोमेट्रिक प्रमाणीकरण।
  Future<void> _authenticate() async {
    final EmployeeModel? employee = _selectedEmployee;
    if (employee == null) {
      Get.snackbar('कर्मचारी चुनें', 'पहले सूची से कर्मचारी चुनें।');
      return;
    }
    final bool success = await _attendanceController.markWithFingerprint(
      employee: employee,
    );
    if (success) {
      Get.snackbar('उपस्थिति दर्ज', '${employee.name} का बायोमेट्रिक सफल रहा।');
    } else {
      Get.snackbar('प्रमाणीकरण विफल', 'बायोमेट्रिक सेंसर से सत्यापन संभव नहीं हुआ।');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('फिंगरप्रिंट से हाज़िरी'),
      ),
      body: Obx(
        () {
          if (_employeeController.employees.isEmpty) {
            return Center(
              child: Text(
                'कृपया पहले कर्मचारी जोड़ें।',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'डिवाइस के फिंगरप्रिंट सेंसर पर उंगली रखें और हाज़िरी दर्ज करें।',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<EmployeeModel>(
                  decoration: const InputDecoration(
                    labelText: 'कर्मचारी चुनें',
                  ),
                  value: _selectedEmployee,
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
                ),
                const SizedBox(height: 24),
                if (_selectedEmployee != null)
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          _selectedEmployee!.fingerprintRegistered
                              ? Icons.fingerprint
                              : Icons.gpp_bad,
                        ),
                      ),
                      title: Text(_selectedEmployee!.name),
                      subtitle: Text(
                        _selectedEmployee!.fingerprintRegistered
                            ? 'फिंगरप्रिंट पहले से रजिस्टर है।'
                            : 'कर्मचारी के लिए फिंगरप्रिंट सक्षम नहीं है।',
                      ),
                    ),
                  ),
                const Spacer(),
                PrimaryButton(
                  text: 'बायोमेट्रिक सत्यापित करें',
                  icon: Icons.fingerprint,
                  onPressed: _attendanceController.isProcessing.value
                      ? null
                      : _authenticate,
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
            ),
          );
        },
      ),
    );
  }
}
