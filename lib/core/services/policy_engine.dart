import 'package:flutter/material.dart';

import '../models/attendance_models.dart';

class PolicyEngineConfig {
  const PolicyEngineConfig({
    required this.halfDayCutoff,
    required this.graceDuration,
    required this.autoCheckoutTime,
    this.allowOvertime = true,
  });

  final TimeOfDay halfDayCutoff;
  final Duration graceDuration;
  final TimeOfDay autoCheckoutTime;
  final bool allowOvertime;
}

class PolicyEngineResult {
  const PolicyEngineResult({
    required this.status,
    required this.withinGrace,
    required this.triggersHalfDay,
    required this.autoCheckoutAt,
    required this.requiresCheckout,
    required this.overtimeDuration,
  });

  final AttendanceStatus status;
  final bool withinGrace;
  final bool triggersHalfDay;
  final DateTime? autoCheckoutAt;
  final bool requiresCheckout;
  final Duration overtimeDuration;
}

class PolicyEngine {
  const PolicyEngine({required this.config});

  final PolicyEngineConfig config;

  PolicyEngineResult evaluate({
    required AttendanceRecordModel? today,
    required DateTime now,
  }) {
    if (today == null) {
      final halfDayTime = _combine(now, config.halfDayCutoff);
      final bool shouldWarn = now.isAfter(halfDayTime.subtract(config.graceDuration));
      return PolicyEngineResult(
        status: shouldWarn ? AttendanceStatus.late : AttendanceStatus.onTime,
        withinGrace: shouldWarn && now.isBefore(halfDayTime),
        triggersHalfDay: false,
        autoCheckoutAt: _combine(now, config.autoCheckoutTime),
        requiresCheckout: false,
        overtimeDuration: Duration.zero,
      );
    }

    final checkIn = today.checkIn;
    final cutoff = _combine(today.date, config.halfDayCutoff);
    final withinGrace = checkIn.isAfter(_combine(today.date, today.shift.startTime)) &&
        checkIn.isBefore(_combine(today.date, today.shift.startTime)
            .add(config.graceDuration));
    final triggersHalfDay = checkIn.isAfter(cutoff);
    AttendanceStatus status = today.status;
    if (triggersHalfDay) {
      status = AttendanceStatus.halfDay;
    } else if (checkIn.isAfter(_combine(today.date, today.shift.startTime))) {
      status = AttendanceStatus.late;
    } else {
      status = AttendanceStatus.onTime;
    }

    final autoCheckoutMoment = _combine(today.date, config.autoCheckoutTime);
    final requiresCheckout = today.checkOut == null && now.isBefore(autoCheckoutMoment);
    final overtimeDuration = (!config.allowOvertime || today.checkOut == null)
        ? Duration.zero
        : today.checkOut!.isAfter(_combine(today.date, today.shift.endTime))
            ? today.checkOut!.difference(_combine(today.date, today.shift.endTime))
            : Duration.zero;

    return PolicyEngineResult(
      status: status,
      withinGrace: withinGrace,
      triggersHalfDay: triggersHalfDay,
      autoCheckoutAt: requiresCheckout ? autoCheckoutMoment : today.autoCheckout,
      requiresCheckout: requiresCheckout,
      overtimeDuration: overtimeDuration,
    );
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
