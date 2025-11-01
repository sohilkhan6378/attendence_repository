import 'package:flutter_test/flutter_test.dart';

import 'package:attendence_management_software/mvc/models/attendance_record_model.dart';
import 'package:attendence_management_software/mvc/models/employee_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('मॉडल सीरियलाइज़ेशन', () {
    test('कर्मचारी मॉडल JSON में सेव होकर वापस सही मान देता है', () {
      final FaceTemplate template = FaceTemplate(
        leftEyeOpenProbability: 0.8,
        rightEyeOpenProbability: 0.82,
        smilingProbability: 0.4,
        boundingBoxWidth: 120,
        boundingBoxHeight: 140,
        headEulerAngleY: 2.4,
        headEulerAngleZ: -1.2,
      );

      final EmployeeModel employee = EmployeeModel(
        id: 'id-1',
        name: 'Test User',
        department: 'QA',
        designation: 'Engineer',
        employeeCode: 'EMP123',
        faceTemplate: template,
        fingerprintRegistered: true,
        faceImagePath: '/tmp/test.jpg',
        createdAt: DateTime.now(),
      );

      final Map<String, dynamic> json = employee.toJson();
      final EmployeeModel parsed = EmployeeModel.fromJson(json);

      expect(parsed.name, employee.name);
      expect(parsed.department, employee.department);
      expect(parsed.designation, employee.designation);
      expect(parsed.faceTemplate?.leftEyeOpenProbability,
          template.leftEyeOpenProbability);
    });

    test('हाज़िरी रिकॉर्ड JSON सीरियलाइज़ेशन', () {
      final AttendanceRecordModel record = AttendanceRecordModel(
        id: 'rec-1',
        employeeId: 'emp-1',
        employeeName: 'Test User',
        timestamp: DateTime.now(),
        method: AttendanceMethod.face,
        status: AttendanceStatus.present,
        note: 'फेस सत्यापन सफल',
      );

      final Map<String, dynamic> json = record.toJson();
      final AttendanceRecordModel parsed =
          AttendanceRecordModel.fromJson(json);

      expect(parsed.employeeName, record.employeeName);
      expect(parsed.method, record.method);
      expect(parsed.status, record.status);
      expect(parsed.note, record.note);
    });
  });
}
