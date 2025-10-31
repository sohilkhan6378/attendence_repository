import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/attendance/models/attendance_models.dart';

/// PolicyService सभी पॉलिसी आधारित गणनाएँ व नियम लागू करता है।
class PolicyService extends GetxService {
  final AttendancePolicy _defaultPolicy = AttendancePolicy();
  final Rx<AttendancePolicy> _policy = AttendancePolicy().obs;

  AttendancePolicy get policy => _policy.value;

  void loadPolicy(AttendancePolicy? savedPolicy) {
    _policy.value = savedPolicy ?? _defaultPolicy;
  }

  void updatePolicy(AttendancePolicy policy) {
    _policy.value = policy;
  }

  /// यह निर्धारित करता है कि किसी चेक-इन को देर या हाफ डे मानना चाहिए या नहीं।
  AttendanceStatus resolveStatus({
    required DateTime checkIn,
    required ShiftModel shift,
  }) {
    final TimeOfDay cutoff = policy.halfDayCutoff;
    final DateTime cutoffDateTime = DateTime(
      checkIn.year,
      checkIn.month,
      checkIn.day,
      cutoff.hour,
      cutoff.minute,
    );

    if (checkIn.isAfter(cutoffDateTime)) {
      return AttendanceStatus.halfDay;
    }

    final graceDuration = Duration(minutes: shift.graceMinutes);
    final scheduledStart = DateTime(
      checkIn.year,
      checkIn.month,
      checkIn.day,
      shift.start.hour,
      shift.start.minute,
    );

    if (checkIn.isAfter(scheduledStart.add(graceDuration))) {
      return AttendanceStatus.late;
    }

    return AttendanceStatus.present;
  }

  /// ऑटो चेकआउट समय के आधार पर स्टेटस अपडेट करें।
  AttendanceDay applyAutoCheckout(AttendanceDay day) {
    if (day.checkIn == null || day.checkOut != null) {
      return day;
    }

    final auto = policy.autoCheckoutTime;
    final scheduled = DateTime(
      day.date.year,
      day.date.month,
      day.date.day,
      auto.hour,
      auto.minute,
    );

    if (DateTime.now().isAfter(scheduled)) {
      return AttendanceDay(
        date: day.date,
        checkIn: day.checkIn,
        checkOut: scheduled,
        status: AttendanceStatus.autoCheckout,
        breaks: day.breaks,
        autoCheckoutApplied: true,
        notes: 'Auto checkout applied',
      );
    }
    return day;
  }
}
