import '../models/attendance_models.dart';

abstract class AttendanceRepository {
  Stream<AttendanceRecordModel?> watchTodayRecord();

  Stream<List<AttendanceRecordModel>> watchMonthlyRecords(DateTime month);

  Stream<List<RequestModel>> watchRequests();

  Stream<AttendanceSummaryModel> watchSummary({required DateTime from, required DateTime to});

  Stream<EmployeeProfileModel> watchProfile();

  Future<void> checkIn();

  Future<void> checkOut();

  Future<void> startBreak(BreakType type);

  Future<void> endBreak(String breakId);

  Future<void> submitRequest(RequestModel request);
}
