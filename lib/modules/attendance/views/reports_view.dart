import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../shared/widgets/stat_tile.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_models.dart';

/// ReportsView साप्ताहिक/मासिक उपस्थिति सारांश प्रदर्शित करता है।
class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.find<AttendanceController>();
    final List<AttendanceDay> records = controller.attendanceForMonth(selectedMonth);
    final totalPresent =
        records.where((day) => day.status == AttendanceStatus.present).length;
    final totalLate =
        records.where((day) => day.status == AttendanceStatus.late).length;
    final totalHalf =
        records.where((day) => day.status == AttendanceStatus.halfDay).length;
    final totalAuto =
        records.where((day) => day.status == AttendanceStatus.autoCheckout).length;
    final totalAbsent =
        DateUtils.getDaysInMonth(selectedMonth.year, selectedMonth.month) -
            records.length;

    return Scaffold(
      appBar: AppBar(title: Text('reports'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(DateFormat.yMMMM().format(selectedMonth),
                    style: Theme.of(context).textTheme.displayMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(() {
                    selectedMonth = DateTime(selectedMonth.year,
                        selectedMonth.month - 1, selectedMonth.day);
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() {
                    selectedMonth = DateTime(selectedMonth.year,
                        selectedMonth.month + 1, selectedMonth.day);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    title: 'Present days',
                    value: '$totalPresent',
                    icon: Icons.verified_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    title: 'Late arrivals',
                    value: '$totalLate',
                    icon: Icons.schedule_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    title: 'Half Day count',
                    value: '$totalHalf',
                    icon: Icons.timelapse,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    title: 'Auto checkout',
                    value: '$totalAuto',
                    icon: Icons.power_settings_new,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StatTile(
              title: 'Absent days',
              value: '$totalAbsent',
              icon: Icons.block,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final day = records[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: Text('${day.date.day}'),
                    ),
                    title: Text(DateFormat('EEE, dd MMM').format(day.date)),
                    subtitle: Text(
                        'Work: ${_formatDuration(day.totalWorkDuration)} • Break: ${_formatDuration(day.totalBreakDuration)}'),
                    trailing: Text(day.status.name.toUpperCase()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}
