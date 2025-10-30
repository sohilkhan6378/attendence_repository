import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/attendance_models.dart';
import '../attendance_repository.dart';

class LocalAttendanceRepository implements AttendanceRepository {
  LocalAttendanceRepository()
      : _todayRecordController = StreamController<AttendanceRecordModel?>.broadcast(),
        _monthlyRecordsController = StreamController<List<AttendanceRecordModel>>.broadcast(),
        _requestsController = StreamController<List<RequestModel>>.broadcast(),
        _summaryController = StreamController<AttendanceSummaryModel>.broadcast(),
        _profileController = StreamController<EmployeeProfileModel>.broadcast() {
    _seed();
  }

  final _uuid = const Uuid();
  final StreamController<AttendanceRecordModel?> _todayRecordController;
  final StreamController<List<AttendanceRecordModel>> _monthlyRecordsController;
  final StreamController<List<RequestModel>> _requestsController;
  final StreamController<AttendanceSummaryModel> _summaryController;
  final StreamController<EmployeeProfileModel> _profileController;

  AttendanceRecordModel? _today;
  late List<AttendanceRecordModel> _currentMonth;
  late List<RequestModel> _requests;

  void _seed() {
    final now = DateTime.now();
    final shift = ShiftModel(
      name: 'Default Shift',
      startTime: const TimeOfDay(hour: 9, minute: 30),
      endTime: const TimeOfDay(hour: 18, minute: 30),
      graceMinutes: 10,
      autoCheckout: const TimeOfDay(hour: 20, minute: 0),
      allowOvertime: true,
    );
    _today = AttendanceRecordModel(
      date: DateTime(now.year, now.month, now.day),
      shift: shift,
      checkIn: DateTime(now.year, now.month, now.day, 9, 24),
      checkOut: now.isAfter(DateTime(now.year, now.month, now.day, 18, 30))
          ? DateTime(now.year, now.month, now.day, 18, 45)
          : null,
      status: AttendanceStatus.onTime,
      breaks: [
        BreakSessionModel(
          id: _uuid.v4(),
          start: DateTime(now.year, now.month, now.day, 13),
          end: DateTime(now.year, now.month, now.day, 13, 30),
          type: BreakType.paid,
        ),
      ],
      notes: 'Smart alerts enabled',
    );
    _currentMonth = List<AttendanceRecordModel>.generate(14, (index) {
      final date = DateTime(now.year, now.month, index + 1);
      final checkInTime = DateTime(now.year, now.month, index + 1, 9, 30 + index % 5);
      final status = index % 5 == 3
          ? AttendanceStatus.halfDay
          : index % 5 == 1
              ? AttendanceStatus.late
              : AttendanceStatus.onTime;
      return AttendanceRecordModel(
        date: date,
        shift: shift,
        checkIn: checkInTime,
        checkOut: checkInTime.add(const Duration(hours: 8)),
        status: status,
        breaks: [
          BreakSessionModel(
            id: _uuid.v4(),
            start: checkInTime.add(const Duration(hours: 4)),
            end: checkInTime.add(const Duration(hours: 4, minutes: 30)),
            type: index.isEven ? BreakType.paid : BreakType.unpaid,
          ),
        ],
      );
    });
    _requests = [
      RequestModel(
        id: _uuid.v4(),
        type: RequestType.missingPunch,
        date: now.subtract(const Duration(days: 2)),
        status: RequestStatus.pending,
        reason: 'Forgot to checkout, please regularize.',
      ),
      RequestModel(
        id: _uuid.v4(),
        type: RequestType.wrongTime,
        date: now.subtract(const Duration(days: 5)),
        status: RequestStatus.approved,
        reason: 'Corrected late check-in approved by manager.',
        approverComments: 'Approved - within grace.',
      ),
    ];

    _emitAll();
  }

  void _emitAll() {
    _todayRecordController.add(_today);
    _monthlyRecordsController.add(_currentMonth);
    _requestsController.add(List<RequestModel>.unmodifiable(_requests));
    _summaryController.add(
      AttendanceSummaryModel(
        presentDays: _currentMonth.where((e) => e.status != AttendanceStatus.absent).length,
        lateDays: _currentMonth.where((e) => e.status == AttendanceStatus.late).length,
        halfDays: _currentMonth.where((e) => e.status == AttendanceStatus.halfDay).length,
        absentDays: _currentMonth.where((e) => e.status == AttendanceStatus.absent).length,
        averageIn: const Duration(hours: 9, minutes: 36),
        averageOut: const Duration(hours: 18, minutes: 12),
        breakAverage: const Duration(minutes: 32),
        totalOvertime: const Duration(hours: 6, minutes: 45),
      ),
    );
    _profileController.add(
      EmployeeProfileModel(
        id: 'E-12021',
        name: 'Ayesha Patel',
        employeeCode: 'EMP-204',
        department: 'People Ops',
        shift: _today!.shift,
        managerName: 'Noah Singh',
        locationPermissionGranted: true,
        faceEnrolled: true,
        linkedDevice: 'Pixel 8 Pro',
        notificationsEnabled: true,
      ),
    );
  }

  @override
  Stream<AttendanceRecordModel?> watchTodayRecord() => _todayRecordController.stream;

  @override
  Stream<List<AttendanceRecordModel>> watchMonthlyRecords(DateTime month) =>
      _monthlyRecordsController.stream;

  @override
  Stream<List<RequestModel>> watchRequests() => _requestsController.stream;

  @override
  Stream<AttendanceSummaryModel> watchSummary({required DateTime from, required DateTime to}) =>
      _summaryController.stream;

  @override
  Stream<EmployeeProfileModel> watchProfile() => _profileController.stream;

  @override
  Future<void> checkIn() async {
    if (_today == null) {
      final now = DateTime.now();
      _today = AttendanceRecordModel(
        date: DateTime(now.year, now.month, now.day),
        shift: _currentMonth.first.shift,
        checkIn: now,
      );
    }
    _emitAll();
  }

  @override
  Future<void> checkOut() async {
    if (_today == null) return;
    _today = AttendanceRecordModel(
      date: _today!.date,
      shift: _today!.shift,
      checkIn: _today!.checkIn,
      checkOut: DateTime.now(),
      status: _today!.status,
      breaks: _today!.breaks,
      autoCheckout: _today!.autoCheckout,
      notes: _today!.notes,
    );
    _emitAll();
  }

  @override
  Future<void> startBreak(BreakType type) async {
    if (_today == null) return;
    final breakSession = BreakSessionModel(
      id: _uuid.v4(),
      start: DateTime.now(),
      type: type,
    );
    _today = AttendanceRecordModel(
      date: _today!.date,
      shift: _today!.shift,
      checkIn: _today!.checkIn,
      checkOut: _today!.checkOut,
      status: _today!.status,
      breaks: [..._today!.breaks, breakSession],
      autoCheckout: _today!.autoCheckout,
      notes: _today!.notes,
    );
    _emitAll();
  }

  @override
  Future<void> endBreak(String breakId) async {
    if (_today == null) return;
    final updatedBreaks = _today!.breaks.map((e) {
      if (e.id == breakId) {
        return BreakSessionModel(
          id: e.id,
          start: e.start,
          type: e.type,
          end: DateTime.now(),
        );
      }
      return e;
    }).toList();
    _today = AttendanceRecordModel(
      date: _today!.date,
      shift: _today!.shift,
      checkIn: _today!.checkIn,
      checkOut: _today!.checkOut,
      status: _today!.status,
      breaks: updatedBreaks,
      autoCheckout: _today!.autoCheckout,
      notes: _today!.notes,
    );
    _emitAll();
  }

  @override
  Future<void> submitRequest(RequestModel request) async {
    _requests = [_requests.firstWhere((r) => r.id == request.id, orElse: () => request), ..._requests];
    _requestsController.add(List<RequestModel>.unmodifiable(_requests));
  }
}
