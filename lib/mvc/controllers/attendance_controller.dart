import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../services/biometric_service.dart';
import '../../services/storage_service.dart';
import '../models/attendance_record_model.dart';
import '../models/employee_model.dart';

/// AttendanceController हाज़िरी से जुड़ी सभी गतिविधियों को नियंत्रित करता है।
class AttendanceController extends GetxController {
  AttendanceController(this._storageService, this._biometricService);

  final StorageService _storageService;
  final BiometricService _biometricService;

  /// सभी हाज़िरी रिकॉर्ड की सूची।
  final RxList<AttendanceRecordModel> records = <AttendanceRecordModel>[].obs;

  /// UI के लिए स्टेटस संदेश।
  final RxString statusMessage = ''.obs;

  /// फेस मैच के लिए अनुमन्य थ्रेसहोल्ड।
  final double faceMatchThreshold = 0.22;

  /// लोडिंग दर्शाने हेतु फ़्लैग।
  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendance();
  }

  /// लोकल स्टोरेज से हाज़िरी डेटा लोड करता है।
  void loadAttendance() {
    final List<AttendanceRecordModel> stored =
        _storageService.readAttendance();
    records.assignAll(stored);
  }

  /// फेस टेम्पलेट के आधार पर उपस्थित दर्ज करने का प्रयास।
  Future<bool> markWithFace({
    required EmployeeModel employee,
    required FaceTemplate capturedTemplate,
  }) async {
    if (employee.faceTemplate == null) {
      statusMessage.value = 'इस कर्मचारी के लिए चेहरा सहेजा नहीं गया है।';
      return false;
    }
    isProcessing.value = true;
    final double difference = employee.faceTemplate!.difference(capturedTemplate);
    final bool isMatched = difference <= faceMatchThreshold;
    if (isMatched) {
      await _registerRecord(
        employee: employee,
        method: AttendanceMethod.face,
        status: AttendanceStatus.present,
        note: 'चेहरा सफलतापूर्वक सत्यापित हुआ।',
      );
      statusMessage.value = 'फेस प्रमाणीकरण सफल रहा।';
    } else {
      await _registerRecord(
        employee: employee,
        method: AttendanceMethod.face,
        status: AttendanceStatus.absent,
        note:
            'फेस सिग्नेचर मेल नहीं खाया (डेल्टा: ${difference.toStringAsFixed(2)}).',
      );
      statusMessage.value = 'फेस सिग्नेचर मेल नहीं खाया।';
    }
    isProcessing.value = false;
    return isMatched;
  }

  /// फिंगरप्रिंट/बायोमेट्रिक प्रमाणीकरण के आधार पर उपस्थिति दर्ज करता है।
  Future<bool> markWithFingerprint({
    required EmployeeModel employee,
  }) async {
    if (!employee.fingerprintRegistered) {
      statusMessage.value = 'इस कर्मचारी के लिए फिंगरप्रिंट सक्षम नहीं है।';
      return false;
    }
    isProcessing.value = true;
    final bool success = await _biometricService.authenticate(
      reason: '${employee.name} की हाज़िरी दर्ज करें',
    );
    await _registerRecord(
      employee: employee,
      method: AttendanceMethod.fingerprint,
      status: success ? AttendanceStatus.present : AttendanceStatus.absent,
      note: success
          ? 'बायोमेट्रिक सत्यापन सफल रहा।'
          : 'बायोमेट्रिक सत्यापन विफल या रद्द हुआ।',
    );
    statusMessage.value = success
        ? 'बायोमेट्रिक सफलतापूर्वक सत्यापित हुआ।'
        : 'बायोमेट्रिक सत्यापन विफल रहा।';
    isProcessing.value = false;
    return success;
  }

  /// मैनुअली उपस्थिति दर्ज करने की सुविधा।
  Future<void> markManual({
    required EmployeeModel employee,
    required AttendanceStatus status,
    String note = 'मैनुअल प्रविष्टि',
  }) async {
    await _registerRecord(
      employee: employee,
      method: AttendanceMethod.manual,
      status: status,
      note: note,
    );
    statusMessage.value =
        'मैनुअल प्रविष्टि सफलतापूर्वक सुरक्षित की गयी।';
  }

  /// सभी रिकॉर्ड लोकल स्टोरेज में सेव करने वाली निजी विधि।
  Future<void> _persistRecords() async {
    await _storageService.writeAttendance(records.toList());
  }

  /// नई हाज़िरी प्रविष्टि बनाकर सूची में जोड़ने वाला हेल्पर।
  Future<void> _registerRecord({
    required EmployeeModel employee,
    required AttendanceMethod method,
    required AttendanceStatus status,
    required String note,
  }) async {
    final AttendanceRecordModel record = AttendanceRecordModel(
      id: const Uuid().v4(),
      employeeId: employee.id,
      employeeName: employee.name,
      timestamp: DateTime.now(),
      method: method,
      status: status,
      note: note,
    );
    records.add(record);
    await _persistRecords();
  }
}
