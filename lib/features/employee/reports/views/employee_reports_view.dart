import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/attendance_models.dart';
import '../../shell/controllers/employee_shell_controller.dart';

class EmployeeReportsView extends GetView<EmployeeShellController> {
  const EmployeeReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.ios_share_outlined),
              label: const Text('Export PDF'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined),
              label: const Text('Export Excel'),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          final summary = controller.summary.value;
          if (summary == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final profile = controller.profile.value;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ReportCard(title: 'Working days', value: summary.presentDays.toString()),
                  _ReportCard(title: 'Late arrivals', value: summary.lateDays.toString(), tone: Tone.warning),
                  _ReportCard(title: 'Half days', value: summary.halfDays.toString(), tone: Tone.error),
                  _ReportCard(title: 'Absences', value: summary.absentDays.toString(), tone: Tone.info),
                  _ReportCard(title: 'Avg check-in', value: _time(summary.averageIn)),
                  _ReportCard(title: 'Avg check-out', value: _time(summary.averageOut)),
                  _ReportCard(title: 'Break avg', value: _time(summary.breakAverage)),
                  _ReportCard(title: 'OT accrued', value: _time(summary.totalOvertime), tone: Tone.success),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Insights', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      _InsightRow(
                        icon: Icons.trending_up,
                        color: Colors.blue,
                        title: 'You are 8% faster on average check-in than last month.',
                      ),
                      _InsightRow(
                        icon: Icons.timer_off_outlined,
                        color: Colors.orange,
                        title: 'Break duration exceeds policy on 2 days — keep an eye.',
                      ),
                      _InsightRow(
                        icon: Icons.shield_moon_outlined,
                        color: Colors.green,
                        title: 'No policy breaches on geo or device controls this week.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (profile != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Device & Permissions', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        _PermissionRow(
                          label: 'Location',
                          value: profile.locationPermissionGranted ? 'Active' : 'Disabled',
                          enabled: profile.locationPermissionGranted,
                        ),
                        _PermissionRow(
                          label: 'Face ID',
                          value: profile.faceEnrolled ? 'Enrolled' : 'Pending',
                          enabled: profile.faceEnrolled,
                        ),
                        _PermissionRow(
                          label: 'Linked device',
                          value: profile.linkedDevice ?? 'Not linked',
                          enabled: profile.linkedDevice != null,
                        ),
                        _PermissionRow(
                          label: 'Notifications',
                          value: profile.notificationsEnabled ? 'Enabled' : 'Muted',
                          enabled: profile.notificationsEnabled,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _time(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
  }
}

enum Tone { neutral, warning, error, info, success }

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.title, required this.value, this.tone = Tone.neutral});

  final String title;
  final String value;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      Tone.warning => const Color(0xFFFFB020),
      Tone.error => const Color(0xFFE04444),
      Tone.info => const Color(0xFF3B82F6),
      Tone.success => const Color(0xFF2FB344),
      Tone.neutral => Theme.of(context).colorScheme.primary,
    };
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.icon, required this.color, required this.title});

  final IconData icon;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: color.withOpacity(.12), child: Icon(icon, color: color)),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({required this.label, required this.value, required this.enabled});

  final String label;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Chip(
            label: Text(value),
            backgroundColor: enabled ? const Color(0xFFE7F8EF) : const Color(0xFFF1F5F9),
            labelStyle: TextStyle(color: enabled ? const Color(0xFF2FB344) : Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
