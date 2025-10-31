import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mvc/models/attendance_record_model.dart';
import '../mvc/models/employee_model.dart';

/// यह सर्विस SharedPreferences के माध्यम से लोकल डाटा को सेव व लोड करने का काम करती है।
class StorageService extends GetxService {
  /// कर्मचारियों की सूची को सुरक्षित करने के लिए प्रयुक्त की-वर्ड।
  static const String _employeesKey = 'employees_storage_key';

  /// हाज़िरी रिकॉर्ड सूची को सुरक्षित करने के लिए प्रयुक्त की-वर्ड।
  static const String _attendanceKey = 'attendance_storage_key';

  late SharedPreferences _preferences;

  /// एप स्टार्ट होने पर SharedPreferences को तैयार करने वाली विधि।
  Future<StorageService> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  /// सेव की गयी कर्मचारियों की JSON सूची को मॉडल सूची में बदलने वाली सहायता विधि।
  List<EmployeeModel> readEmployees() {
    final jsonString = _preferences.getString(_employeesKey);
    if (jsonString == null) {
      return <EmployeeModel>[];
    }
    final List<dynamic> rawList = jsonDecode(jsonString) as List<dynamic>;
    return rawList
        .map((dynamic item) =>
            EmployeeModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// कर्मचारियों की नई सूची को SharedPreferences में सुरक्षित करने वाली विधि।
  Future<void> writeEmployees(List<EmployeeModel> employees) async {
    final List<Map<String, dynamic>> jsonList =
        employees.map((employee) => employee.toJson()).toList();
    await _preferences.setString(_employeesKey, jsonEncode(jsonList));
  }

  /// सेव किये हुए हाज़िरी रिकॉर्ड को पढ़ने की विधि।
  List<AttendanceRecordModel> readAttendance() {
    final jsonString = _preferences.getString(_attendanceKey);
    if (jsonString == null) {
      return <AttendanceRecordModel>[];
    }
    final List<dynamic> rawList = jsonDecode(jsonString) as List<dynamic>;
    return rawList
        .map((dynamic item) => AttendanceRecordModel.fromJson(
            item as Map<String, dynamic>))
        .toList();
  }

  /// नई हाज़िरी सूची को SharedPreferences में सेव करने वाली विधि।
  Future<void> writeAttendance(List<AttendanceRecordModel> records) async {
    final List<Map<String, dynamic>> jsonList =
        records.map((record) => record.toJson()).toList();
    await _preferences.setString(_attendanceKey, jsonEncode(jsonList));
  }
}
