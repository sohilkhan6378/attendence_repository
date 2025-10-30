import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AttendanceStatus {
  onTime,
  late,
  halfDay,
  absent,
}

enum BreakType {
  paid,
  unpaid,
}

enum RequestStatus {
  pending,
  approved,
  rejected,
}

enum RequestType {
  missingPunch,
  wrongTime,
  breakAdjustment,
}

class ShiftModel {
  const ShiftModel({
    required this.name,
    required this.startTime,
    required this.endTime,
    this.graceMinutes = 10,
    this.autoCheckout,
    this.allowOvertime = false,
  });

  final String name;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int graceMinutes;
  final TimeOfDay? autoCheckout;
  final bool allowOvertime;
}

class BreakSessionModel {
  BreakSessionModel({
    required this.id,
    required this.start,
    required this.type,
    this.end,
  });

  final String id;
  final DateTime start;
  final BreakType type;
  DateTime? end;

  Duration get duration => (end ?? DateTime.now()).difference(start);
}

class AttendanceRecordModel {
  AttendanceRecordModel({
    required this.date,
    required this.shift,
    required this.checkIn,
    this.checkOut,
    this.status = AttendanceStatus.onTime,
    this.breaks = const <BreakSessionModel>[],
    this.autoCheckout,
    this.notes,
  });

  final DateTime date;
  final ShiftModel shift;
  final DateTime checkIn;
  DateTime? checkOut;
  AttendanceStatus status;
  final List<BreakSessionModel> breaks;
  final DateTime? autoCheckout;
  final String? notes;

  Duration get workedDuration => (checkOut ?? DateTime.now()).difference(checkIn);
  Duration get breakDuration => breaks.fold(Duration.zero, (acc, b) => acc + b.duration);
}

class RequestModel {
  RequestModel({
    required this.id,
    required this.type,
    required this.date,
    required this.status,
    required this.reason,
    this.from,
    this.to,
    this.attachments = const [],
    this.approverComments,
  });

  final String id;
  final RequestType type;
  final DateTime date;
  RequestStatus status;
  final String reason;
  final DateTime? from;
  final DateTime? to;
  final List<String> attachments;
  final String? approverComments;
}

class EmployeeProfileModel {
  const EmployeeProfileModel({
    required this.id,
    required this.name,
    required this.employeeCode,
    required this.department,
    required this.shift,
    required this.managerName,
    this.locationPermissionGranted = false,
    this.faceEnrolled = false,
    this.linkedDevice,
    this.notificationsEnabled = true,
  });

  final String id;
  final String name;
  final String employeeCode;
  final String department;
  final ShiftModel shift;
  final String managerName;
  final bool locationPermissionGranted;
  final bool faceEnrolled;
  final String? linkedDevice;
  final bool notificationsEnabled;
}

extension AttendanceStatusX on AttendanceStatus {
  String get label => {
        AttendanceStatus.onTime: 'onTime'.tr,
        AttendanceStatus.late: 'late'.tr,
        AttendanceStatus.halfDay: 'halfDay'.tr,
        AttendanceStatus.absent: 'absent'.tr,
      }[this]!;

  Color get color => {
        AttendanceStatus.onTime: const Color(0xFF2FB344),
        AttendanceStatus.late: const Color(0xFFFFB020),
        AttendanceStatus.halfDay: const Color(0xFFE04444),
        AttendanceStatus.absent: const Color(0xFF3B82F6),
      }[this]!;
}

extension RequestStatusX on RequestStatus {
  String get label => {
        RequestStatus.pending: 'pending'.tr,
        RequestStatus.approved: 'approved'.tr,
        RequestStatus.rejected: 'rejected'.tr,
      }[this]!;

  Color get color => {
        RequestStatus.pending: const Color(0xFFFFB020),
        RequestStatus.approved: const Color(0xFF2FB344),
        RequestStatus.rejected: const Color(0xFFE04444),
      }[this]!;
}

class AttendanceSummaryModel {
  AttendanceSummaryModel({
    required this.presentDays,
    required this.lateDays,
    required this.halfDays,
    required this.absentDays,
    required this.averageIn,
    required this.averageOut,
    required this.breakAverage,
    required this.totalOvertime,
  });

  final int presentDays;
  final int lateDays;
  final int halfDays;
  final int absentDays;
  final Duration averageIn;
  final Duration averageOut;
  final Duration breakAverage;
  final Duration totalOvertime;
}
