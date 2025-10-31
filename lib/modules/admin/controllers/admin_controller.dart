import 'package:get/get.dart';

import '../../attendance/controllers/attendance_controller.dart';
import '../../attendance/models/attendance_models.dart';

/// AdminController एडमिन डैशबोर्ड के लिए मीट्रिक्स कैलकुलेट करता है।
class AdminController extends GetxController {
  final AttendanceController attendanceController = Get.find<AttendanceController>();

  List<AttendanceDay> get todayRecords =>
      attendanceController.attendanceForDate(DateTime.now());

  int get presentCount => todayRecords
      .where((record) => record.status == AttendanceStatus.present)
      .length;
  int get lateCount => todayRecords
      .where((record) => record.status == AttendanceStatus.late)
      .length;
  int get onBreakCount => todayRecords
      .where((record) => record.breaks.isNotEmpty && record.breaks.last.end == null)
      .length;
}
