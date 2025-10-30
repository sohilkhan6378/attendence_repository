import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/themes/app_theme.dart';
import '../../../../core/models/attendance_models.dart';
import '../../shell/controllers/employee_shell_controller.dart';

class EmployeeCalendarView extends GetView<EmployeeShellController> {
  const EmployeeCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final month = controller.monthlyRecords;
        final today = DateTime.now();
        final daysInMonth = DateUtils.getDaysInMonth(today.year, today.month);
        final items = List.generate(daysInMonth, (index) {
          final date = DateTime(today.year, today.month, index + 1);
          AttendanceRecordModel? record;
          for (final element in month) {
            if (element.date.day == date.day) {
              record = element;
              break;
            }
          }
          return _CalendarDay(date: date, record: record, isToday: DateUtils.isSameDay(date, today));
        });
        return Scaffold(
          appBar: AppBar(title: const Text('Calendar & Logs')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    _LegendChip(color: Color(0xFF2FB344), label: 'Present'),
                    _LegendChip(color: Color(0xFFFFB020), label: 'Late'),
                    _LegendChip(color: Color(0xFFE04444), label: 'Half Day'),
                    _LegendChip(color: Color(0xFF94A3B8), label: 'Absent'),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) => items[index],
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined),
                  label: const Text('Export My Attendance (Excel)'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({required this.date, required this.record, required this.isToday});

  final DateTime date;
  final AttendanceRecordModel? record;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final tokens = DesignTokens.of(context);
    final color = () {
      if (record == null) return tokens.color.muted;
      return record!.status.color;
    }();
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: isToday ? tokens.color.primary.withOpacity(.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(.4)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${date.day}', style: Theme.of(context).textTheme.titleMedium),
              if (record != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    if (record == null) return;
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Timeline · ${record!.date.day}/${record!.date.month}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _TimelineRow(label: 'Check-in', value: _format(record!.checkIn)),
            _TimelineRow(label: 'Check-out', value: record!.checkOut != null ? _format(record!.checkOut!) : '--'),
            _TimelineRow(label: 'Break', value: _duration(record!.breakDuration)),
            _TimelineRow(label: 'Total', value: _duration(record!.workedDuration)),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () {},
              icon: const Icon(Icons.edit_note_outlined),
              label: Text('requestEdit'.tr),
            ),
          ],
        ),
      ),
    );
  }

  String _format(DateTime date) => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  String _duration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 6),
      label: Text(label),
    );
  }
}
