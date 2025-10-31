import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/attendance/models/attendance_models.dart';

/// SharedPreferences आधारित लोकल स्टोरेज सर्विस।
class StorageService extends GetxService {
  static const String _employeesKey = 'employees';
  static const String _attendanceKey = 'attendance';
  static const String _requestsKey = 'requests';
  static const String _policyKey = 'policies';

  late SharedPreferences _preferences;

  Future<StorageService> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  SharedPreferences get preferences => _preferences;

  /// कर्मचारियों का डेटा पढ़ें।
  List<EmployeeModel> readEmployees() {
    final raw = _preferences.getString(_employeesKey);
    if (raw == null) return <EmployeeModel>[];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((dynamic item) =>
            EmployeeModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> writeEmployees(List<EmployeeModel> employees) async {
    final jsonList = employees.map((e) => e.toJson()).toList();
    await _preferences.setString(_employeesKey, jsonEncode(jsonList));
  }

  /// किसी कर्मचारी के दैनिक उपस्थितिपत्र पढ़ना।
  Map<String, List<AttendanceDay>> readAttendance() {
    final raw = _preferences.getString(_attendanceKey);
    if (raw == null) return <String, List<AttendanceDay>>{};
    final Map<String, dynamic> map =
        jsonDecode(raw) as Map<String, dynamic>;
    return map.map((String key, dynamic value) {
      final List<dynamic> list = value as List<dynamic>;
      return MapEntry<String, List<AttendanceDay>>(
        key,
        list
            .map((dynamic item) =>
                AttendanceDay.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    });
  }

  Future<void> writeAttendance(Map<String, List<AttendanceDay>> data) async {
    final map = data.map((String key, List<AttendanceDay> value) =>
        MapEntry<String, dynamic>(
            key, value.map((e) => e.toJson()).toList()));
    await _preferences.setString(_attendanceKey, jsonEncode(map));
  }

  /// नियमितीकरण अनुरोध पढ़ें।
  List<RegularizationRequest> readRequests() {
    final raw = _preferences.getString(_requestsKey);
    if (raw == null) return <RegularizationRequest>[];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((dynamic item) =>
            RegularizationRequest.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> writeRequests(List<RegularizationRequest> requests) async {
    final jsonList = requests.map((r) => r.toJson()).toList();
    await _preferences.setString(_requestsKey, jsonEncode(jsonList));
  }

  AttendancePolicy? readPolicy() {
    final raw = _preferences.getString(_policyKey);
    if (raw == null) return null;
    return AttendancePolicy.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> writePolicy(AttendancePolicy policy) async {
    await _preferences.setString(_policyKey, jsonEncode(policy.toJson()));
  }

  Future<void> clear() async {
    await _preferences.remove(_employeesKey);
    await _preferences.remove(_attendanceKey);
    await _preferences.remove(_requestsKey);
    await _preferences.remove(_policyKey);
  }
}
