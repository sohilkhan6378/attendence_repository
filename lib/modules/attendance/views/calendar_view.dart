import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/attendance_controller.dart';
import '../models/attendance_models.dart';

/// CalendarView उपस्थिति को महीने की ग्रिड में दिखाता है।
class CalendarView extends StatelessWidget {
  CalendarView({super.key});

  final DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.find<AttendanceController>();
    final List<AttendanceDay> monthRecords =
        controller.attendanceForMonth(_focusedMonth);

    return Scaffold(
      appBar: AppBar(title: Text('calendar'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.yMMMM().format(_focusedMonth),
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 12),
            _buildLegend(context),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount:
                    DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final dayDate = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month,
                    index + 1,
                  );
                  AttendanceDay? dayRecord;
                  for (final record in monthRecords) {
                    if (record.date.year == dayDate.year &&
                        record.date.month == dayDate.month &&
                        record.date.day == dayDate.day) {
                      dayRecord = record;
                      break;
                    }
                  }
                  final status = dayRecord?.status ?? AttendanceStatus.absent;
                  final color = _statusColor(context, status);
                  return Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.4)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${dayDate.day}',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 4),
                        Text(_statusLabel(status),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 10)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final items = <Map<String, dynamic>>[
      {'label': 'Present', 'color': _statusColor(context, AttendanceStatus.present)},
      {'label': 'Late', 'color': _statusColor(context, AttendanceStatus.late)},
      {
        'label': 'Half Day',
        'color': _statusColor(context, AttendanceStatus.halfDay),
      },
      {
        'label': 'Auto',
        'color': _statusColor(context, AttendanceStatus.autoCheckout),
      },
      {'label': 'Absent', 'color': _statusColor(context, AttendanceStatus.absent)},
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 6),
                Text(item['label'] as String),
              ],
            ),
          )
          .toList(),
    );
  }

  Color _statusColor(BuildContext context, AttendanceStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (status) {
      AttendanceStatus.present => colorScheme.primary,
      AttendanceStatus.late => colorScheme.tertiary,
      AttendanceStatus.halfDay => colorScheme.error,
      AttendanceStatus.autoCheckout => colorScheme.secondary,
      AttendanceStatus.absent => colorScheme.outline,
    };
  }

  String _statusLabel(AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.present => 'On time',
      AttendanceStatus.late => 'Late',
      AttendanceStatus.halfDay => 'Half',
      AttendanceStatus.autoCheckout => 'Auto',
      AttendanceStatus.absent => '—',
    };
  }
}
