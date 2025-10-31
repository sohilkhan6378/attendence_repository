import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// उपस्थितिपत्र स्थिति के विकल्प।
enum AttendanceStatus { present, late, halfDay, absent, autoCheckout }

/// ब्रेक मॉडल जो प्रत्येक ब्रेक का स्टार्ट व एंड समय कैप्चर करता है।
class BreakPeriod {
  BreakPeriod({required this.start, this.end});

  final DateTime start;
  final DateTime? end;

  Map<String, dynamic> toJson() => {
        'start': start.toIso8601String(),
        'end': end?.toIso8601String(),
      };

  factory BreakPeriod.fromJson(Map<String, dynamic> json) => BreakPeriod(
        start: DateTime.parse(json['start'] as String),
        end: (json['end'] as String?) != null
            ? DateTime.parse(json['end'] as String)
            : null,
      );
}

/// दिन की पूरी अटेंडेंस जानकारी संग्रहित करने वाला मॉडल।
class AttendanceDay {
  AttendanceDay({
    required this.date,
    this.checkIn,
    this.checkOut,
    this.status = AttendanceStatus.absent,
    this.breaks = const <BreakPeriod>[],
    this.autoCheckoutApplied = false,
    this.notes,
  });

  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final List<BreakPeriod> breaks;
  final AttendanceStatus status;
  final bool autoCheckoutApplied;
  final String? notes;

  Duration get totalBreakDuration {
    return breaks.fold(Duration.zero, (Duration acc, BreakPeriod period) {
      if (period.end == null) {
        return acc;
      }
      return acc + period.end!.difference(period.start);
    });
  }

  Duration get totalWorkDuration {
    if (checkIn == null) return Duration.zero;
    final endTime = checkOut ?? DateTime.now();
    return endTime.difference(checkIn!) - totalBreakDuration;
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'checkIn': checkIn?.toIso8601String(),
        'checkOut': checkOut?.toIso8601String(),
        'status': describeEnum(status),
        'autoCheckoutApplied': autoCheckoutApplied,
        'notes': notes,
        'breaks': breaks.map((b) => b.toJson()).toList(),
      };

  factory AttendanceDay.fromJson(Map<String, dynamic> json) {
    return AttendanceDay(
      date: DateTime.parse(json['date'] as String),
      checkIn: json['checkIn'] != null
          ? DateTime.parse(json['checkIn'] as String)
          : null,
      checkOut: json['checkOut'] != null
          ? DateTime.parse(json['checkOut'] as String)
          : null,
      status: AttendanceStatus.values.firstWhere(
        (status) => describeEnum(status) == json['status'],
        orElse: () => AttendanceStatus.absent,
      ),
      autoCheckoutApplied: json['autoCheckoutApplied'] as bool? ?? false,
      notes: json['notes'] as String?,
      breaks: (json['breaks'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) =>
              BreakPeriod.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// शिफ्ट मॉडल जो स्टार्ट एंड टाइम व पॉलिसी जोड़ता है।
class ShiftModel {
  ShiftModel({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    this.graceMinutes = 10,
    this.breakPolicy = const BreakPolicy(),
    this.autoCheckoutTime,
  });

  final String id;
  final String name;
  final TimeOfDay start;
  final TimeOfDay end;
  final int graceMinutes;
  final BreakPolicy breakPolicy;
  final TimeOfDay? autoCheckoutTime;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'start': _encodeTimeOfDay(start),
        'end': _encodeTimeOfDay(end),
        'graceMinutes': graceMinutes,
        'breakPolicy': breakPolicy.toJson(),
        'autoCheckoutTime':
            autoCheckoutTime != null ? _encodeTimeOfDay(autoCheckoutTime!) : null,
      };

  factory ShiftModel.fromJson(Map<String, dynamic> json) => ShiftModel(
        id: json['id'] as String,
        name: json['name'] as String,
        start: _decodeTimeOfDay(json['start'] as String),
        end: _decodeTimeOfDay(json['end'] as String),
        graceMinutes: json['graceMinutes'] as int? ?? 10,
        breakPolicy: BreakPolicy.fromJson(
            json['breakPolicy'] as Map<String, dynamic>? ?? const {}),
        autoCheckoutTime: (json['autoCheckoutTime'] as String?) != null
            ? _decodeTimeOfDay(json['autoCheckoutTime'] as String)
            : null,
      );
}

/// ब्रेक के नियमों का प्रतिनिधित्व करने वाला मॉडल।
class BreakPolicy {
  const BreakPolicy({
    this.maxBreaks = 2,
    this.paidBreaks = 1,
  });

  final int maxBreaks;
  final int paidBreaks;

  Map<String, dynamic> toJson() => {
        'maxBreaks': maxBreaks,
        'paidBreaks': paidBreaks,
      };

  factory BreakPolicy.fromJson(Map<String, dynamic> json) => BreakPolicy(
        maxBreaks: json['maxBreaks'] as int? ?? 2,
        paidBreaks: json['paidBreaks'] as int? ?? 1,
      );
}

/// हाफ-डे, ग्रेस और अन्य नीतियों को संग्रहित करने वाला मॉडल।
class AttendancePolicy {
  AttendancePolicy({
    this.halfDayCutoff = const TimeOfDay(hour: 10, minute: 30),
    this.graceMinutes = 10,
    this.autoCheckoutTime = const TimeOfDay(hour: 20, minute: 0),
    this.geoFenceRadiusMeters = 100,
    this.faceRequired = false,
    this.fingerprintRequired = false,
  });

  final TimeOfDay halfDayCutoff;
  final int graceMinutes;
  final TimeOfDay autoCheckoutTime;
  final int geoFenceRadiusMeters;
  final bool faceRequired;
  final bool fingerprintRequired;

  Map<String, dynamic> toJson() => {
        'halfDayCutoff': _encodeTimeOfDay(halfDayCutoff),
        'graceMinutes': graceMinutes,
        'autoCheckoutTime': _encodeTimeOfDay(autoCheckoutTime),
        'geoFenceRadiusMeters': geoFenceRadiusMeters,
        'faceRequired': faceRequired,
        'fingerprintRequired': fingerprintRequired,
      };

  factory AttendancePolicy.fromJson(Map<String, dynamic> json) => AttendancePolicy(
        halfDayCutoff: json['halfDayCutoff'] != null
            ? _decodeTimeOfDay(json['halfDayCutoff'] as String)
            : const TimeOfDay(hour: 10, minute: 30),
        graceMinutes: json['graceMinutes'] as int? ?? 10,
        autoCheckoutTime: json['autoCheckoutTime'] != null
            ? _decodeTimeOfDay(json['autoCheckoutTime'] as String)
            : const TimeOfDay(hour: 20, minute: 0),
        geoFenceRadiusMeters: json['geoFenceRadiusMeters'] as int? ?? 100,
        faceRequired: json['faceRequired'] as bool? ?? false,
        fingerprintRequired: json['fingerprintRequired'] as bool? ?? false,
      );
}

/// कर्मचारी की बुनियादी प्रोफ़ाइल जानकारी।
class EmployeeModel {
  EmployeeModel({
    required this.id,
    required this.code,
    required this.name,
    required this.department,
    required this.role,
    required this.shift,
    required this.managerName,
    required this.location,
    this.languageCode = 'en_US',
    this.themeMode = 'system',
    this.faceEnrolled = false,
    this.fingerprintEnrolled = false,
  });

  final String id;
  final String code;
  final String name;
  final String department;
  final String role;
  final ShiftModel shift;
  final String managerName;
  final String location;
  final String languageCode;
  final String themeMode;
  final bool faceEnrolled;
  final bool fingerprintEnrolled;

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'department': department,
        'role': role,
        'shift': shift.toJson(),
        'managerName': managerName,
        'location': location,
        'languageCode': languageCode,
        'themeMode': themeMode,
        'faceEnrolled': faceEnrolled,
        'fingerprintEnrolled': fingerprintEnrolled,
      };

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json['id'] as String,
        code: json['code'] as String,
        name: json['name'] as String,
        department: json['department'] as String,
        role: json['role'] as String,
        shift: ShiftModel.fromJson(json['shift'] as Map<String, dynamic>),
        managerName: json['managerName'] as String,
        location: json['location'] as String,
        languageCode: json['languageCode'] as String? ?? 'en_US',
        themeMode: json['themeMode'] as String? ?? 'system',
        faceEnrolled: json['faceEnrolled'] as bool? ?? false,
        fingerprintEnrolled: json['fingerprintEnrolled'] as bool? ?? false,
      );

  EmployeeModel copyWith({
    String? languageCode,
    String? themeMode,
    bool? faceEnrolled,
    bool? fingerprintEnrolled,
  }) {
    return EmployeeModel(
      id: id,
      code: code,
      name: name,
      department: department,
      role: role,
      shift: shift,
      managerName: managerName,
      location: location,
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
      faceEnrolled: faceEnrolled ?? this.faceEnrolled,
      fingerprintEnrolled: fingerprintEnrolled ?? this.fingerprintEnrolled,
    );
  }
}

/// नियमितीकरण अनुरोध मॉडल।
class RegularizationRequest {
  RegularizationRequest({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.type,
    required this.fromTime,
    required this.toTime,
    required this.reason,
    this.evidence,
    this.status = 'pending',
    this.approverNote,
  });

  final String id;
  final String employeeId;
  final DateTime date;
  final String type;
  final DateTime fromTime;
  final DateTime toTime;
  final String reason;
  final String? evidence;
  final String status;
  final String? approverNote;

  Map<String, dynamic> toJson() => {
        'id': id,
        'employeeId': employeeId,
        'date': date.toIso8601String(),
        'type': type,
        'fromTime': fromTime.toIso8601String(),
        'toTime': toTime.toIso8601String(),
        'reason': reason,
        'evidence': evidence,
        'status': status,
        'approverNote': approverNote,
      };

  factory RegularizationRequest.fromJson(Map<String, dynamic> json) =>
      RegularizationRequest(
        id: json['id'] as String,
        employeeId: json['employeeId'] as String,
        date: DateTime.parse(json['date'] as String),
        type: json['type'] as String,
        fromTime: DateTime.parse(json['fromTime'] as String),
        toTime: DateTime.parse(json['toTime'] as String),
        reason: json['reason'] as String,
        evidence: json['evidence'] as String?,
        status: json['status'] as String? ?? 'pending',
        approverNote: json['approverNote'] as String?,
      );
}

String _encodeTimeOfDay(TimeOfDay time) => jsonEncode({'h': time.hour, 'm': time.minute});

TimeOfDay _decodeTimeOfDay(String value) {
  final Map<String, dynamic> map = jsonDecode(value) as Map<String, dynamic>;
  return TimeOfDay(hour: map['h'] as int, minute: map['m'] as int);
}
