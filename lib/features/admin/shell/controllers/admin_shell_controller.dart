import 'package:get/get.dart';

import '../../../../core/models/attendance_models.dart';

class AdminShellController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxBool compactMode = false.obs;

  final RxList<AdminTeamMember> team = <AdminTeamMember>[].obs;
  final RxList<RequestModel> approvalQueue = <RequestModel>[].obs;
  final RxList<ShiftPolicy> shifts = <ShiftPolicy>[].obs;

  @override
  void onInit() {
    super.onInit();
    _seed();
  }

  void setIndex(int index) {
    currentIndex.value = index;
  }

  void toggleCompact() {
    compactMode.toggle();
  }

  void _seed() {
    team.assignAll([
      AdminTeamMember('Ayesha Patel', 'Product Designer', '9:30 AM', '6:30 PM', AttendanceStatus.onTime, 'HQ Floor 5'),
      AdminTeamMember('Michael Lee', 'Sales Lead', '10:45 AM', '--', AttendanceStatus.halfDay, 'Remote'),
      AdminTeamMember('Li Wei', 'Engineering Manager', '9:40 AM', '7:12 PM', AttendanceStatus.late, 'HQ Floor 3'),
      AdminTeamMember('Sara Khan', 'HR Partner', '9:20 AM', '6:05 PM', AttendanceStatus.onTime, 'HQ Floor 2'),
    ]);
    approvalQueue.assignAll([
      RequestModel(
        id: 'R-1',
        type: RequestType.missingPunch,
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: RequestStatus.pending,
        reason: 'Missed check-out, request regularization.',
      ),
      RequestModel(
        id: 'R-2',
        type: RequestType.breakAdjustment,
        date: DateTime.now(),
        status: RequestStatus.pending,
        reason: 'Extend paid break for client meeting.',
      ),
    ]);
    shifts.assignAll([
      const ShiftPolicy(
        name: 'Day Shift',
        start: '09:30',
        end: '18:30',
        grace: '10 mins',
        autoCheckout: '20:00',
        breaks: '1 paid · 1 unpaid',
      ),
      const ShiftPolicy(
        name: 'Support Shift',
        start: '13:00',
        end: '22:00',
        grace: '15 mins',
        autoCheckout: '22:30',
        breaks: '2 paid',
      ),
    ]);
  }
}

class AdminTeamMember {
  const AdminTeamMember(this.name, this.role, this.firstPunch, this.lastPunch, this.status, this.location);

  final String name;
  final String role;
  final String firstPunch;
  final String lastPunch;
  final AttendanceStatus status;
  final String location;
}

class ShiftPolicy {
  const ShiftPolicy({
    required this.name,
    required this.start,
    required this.end,
    required this.grace,
    required this.autoCheckout,
    required this.breaks,
  });

  final String name;
  final String start;
  final String end;
  final String grace;
  final String autoCheckout;
  final String breaks;
}
