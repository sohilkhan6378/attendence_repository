import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/models/attendance_models.dart';
import '../../../../core/repositories/attendance_repository.dart';
import '../../../../core/services/policy_engine.dart';

class EmployeeShellController extends GetxController {
  EmployeeShellController({required this.repository, required this.policyEngine});

  final AttendanceRepository repository;
  final PolicyEngine policyEngine;

  final RxInt currentIndex = 0.obs;
  final Rx<AttendanceRecordModel?> todayRecord = Rx<AttendanceRecordModel?>(null);
  final RxList<AttendanceRecordModel> monthlyRecords = <AttendanceRecordModel>[].obs;
  final RxList<RequestModel> requests = <RequestModel>[].obs;
  final Rx<AttendanceSummaryModel?> summary = Rx<AttendanceSummaryModel?>(null);
  final Rx<EmployeeProfileModel?> profile = Rx<EmployeeProfileModel?>(null);
  final Rx<PolicyEngineResult?> policy = Rx<PolicyEngineResult?>(null);

  late final StreamSubscription _todaySubscription;
  late final StreamSubscription _monthSubscription;
  late final StreamSubscription _requestSubscription;
  late final StreamSubscription _summarySubscription;
  late final StreamSubscription _profileSubscription;

  @override
  void onInit() {
    super.onInit();
    _todaySubscription = repository.watchTodayRecord().listen((event) {
      todayRecord.value = event;
      policy.value = policyEngine.evaluate(today: event, now: DateTime.now());
    });
    _monthSubscription = repository.watchMonthlyRecords(DateTime.now()).listen((event) {
      monthlyRecords.assignAll(event);
    });
    _requestSubscription = repository.watchRequests().listen(requests.assignAll);
    _summarySubscription = repository
        .watchSummary(from: DateTime.now().subtract(const Duration(days: 7)), to: DateTime.now())
        .listen(summary.call);
    _profileSubscription = repository.watchProfile().listen(profile.call);
  }

  void setIndex(int index) {
    currentIndex.value = index;
  }

  Future<void> checkIn() => repository.checkIn();

  Future<void> checkOut() => repository.checkOut();

  Future<void> startBreak(BreakType type) => repository.startBreak(type);

  Future<void> endBreak(String breakId) => repository.endBreak(breakId);

  Future<void> submitRequest(RequestModel request) => repository.submitRequest(request);

  @override
  void onClose() {
    _todaySubscription.cancel();
    _monthSubscription.cancel();
    _requestSubscription.cancel();
    _summarySubscription.cancel();
    _profileSubscription.cancel();
    super.onClose();
  }
}
