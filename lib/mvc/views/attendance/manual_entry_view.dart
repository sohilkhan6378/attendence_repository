import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/attendance_controller.dart';
import '../../controllers/employee_controller.dart';
import '../../models/attendance_record_model.dart';
import '../../models/employee_model.dart';
import '../widgets/primary_button.dart';

/// ManualEntryView विशेष परिस्थितियों में मैनुअल हाज़िरी दर्ज करने की सुविधा देती है।
class ManualEntryView extends StatefulWidget {
  const ManualEntryView({super.key});

  @override
  State<ManualEntryView> createState() => _ManualEntryViewState();
}

class _ManualEntryViewState extends State<ManualEntryView> {
  final TextEditingController _noteController = TextEditingController();
  AttendanceStatus _status = AttendanceStatus.present;
  EmployeeModel? _selectedEmployee;

  EmployeeController get _employeeController => Get.find<EmployeeController>();
  AttendanceController get _attendanceController =>
      Get.find<AttendanceController>();

  /// मैनुअल प्रविष्टि को सेव करने वाली विधि।
  Future<void> _saveManualEntry() async {
    if (_selectedEmployee == null) {
      Get.snackbar('कर्मचारी चुनें', 'मैनुअल प्रविष्टि से पहले कर्मचारी चुनना आवश्यक है।');
      return;
    }
    await _attendanceController.markManual(
      employee: _selectedEmployee!,
      status: _status,
      note: _noteController.text.trim().isEmpty
          ? 'मैनुअल प्रविष्टि'
          : _noteController.text.trim(),
    );
    if (!mounted) return;
    Get.snackbar('सहेजा गया', 'मैनुअल हाज़िरी रिकॉर्ड सेव कर लिया गया है।');
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('मैनुअल हाज़िरी प्रविष्टि'),
      ),
      body: Obx(
        () {
          if (_employeeController.employees.isEmpty) {
            return Center(
              child: Text(
                'कम से कम एक कर्मचारी जोड़ना आवश्यक है।',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                const SizedBox(height: 20),
                Text(
                  'स्थिति चुनें',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ToggleButtons(
                  isSelected: <bool>[
                    _status == AttendanceStatus.present,
                    _status == AttendanceStatus.absent,
                  ],
                  onPressed: (int index) {
                    setState(() {
                      _status = index == 0
                          ? AttendanceStatus.present
                          : AttendanceStatus.absent;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  children: const <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Text('उपस्थित'),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Text('अनुपस्थित'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'टिप्पणी (वैकल्पिक)',
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'मैनुअल हाज़िरी सेव करें',
                  icon: Icons.save_alt,
                  onPressed: _saveManualEntry,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
