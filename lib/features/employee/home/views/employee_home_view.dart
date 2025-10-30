import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../app/themes/app_theme.dart';
import '../../../../core/models/attendance_models.dart';
import '../../../../core/services/policy_engine.dart';
import '../../shell/controllers/employee_shell_controller.dart';

class EmployeeHomeView extends GetView<EmployeeShellController> {
  const EmployeeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = DesignTokens.of(context);
    return Obx(
      () {
        final today = controller.todayRecord.value;
        final policy = controller.policy.value;
        return CustomScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          slivers: [
            SliverToBoxAdapter(
              child: _HeaderSection(profile: controller.profile.value, policy: policy),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: _PrimaryCard(today: today, policy: policy, tokens: tokens),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: _QuickStats(today: today, policy: policy),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: _SmartAlerts(policy: policy),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: _RecentActivityList(records: controller.monthlyRecords.take(5).toList()),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.profile, required this.policy});

  final EmployeeProfileModel? profile;
  final PolicyEngineResult? policy;

  @override
  Widget build(BuildContext context) {
    final tokens = DesignTokens.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: tokens.color.primary.withOpacity(.12),
          child: Text(profile?.name.substring(0, 1) ?? 'U', style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile?.name ?? '—', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('${profile?.employeeCode ?? ''} · ${profile?.department ?? ''}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        if (policy != null)
          Chip(
            label: Text(policy.status.label),
            backgroundColor: policy.status.color.withOpacity(.12),
            avatar: Icon(Icons.verified, color: policy.status.color, size: 18),
          ),
      ],
    );
  }
}

class _PrimaryCard extends StatelessWidget {
  const _PrimaryCard({required this.today, required this.policy, required this.tokens});

  final AttendanceRecordModel? today;
  final PolicyEngineResult? policy;
  final DesignTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today · ${_dateString(DateTime.now())}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('${today?.shift.startTime.format(context) ?? '--:--'} – ${today?.shift.endTime.format(context) ?? '--:--'}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                if (policy?.triggersHalfDay ?? false)
                  Chip(
                    label: const Text('Half Day'),
                    backgroundColor: tokens.color.error.withOpacity(.12),
                    avatar: Icon(Icons.warning_amber_rounded, color: tokens.color.error, size: 18),
                  )
                else if (policy?.status == AttendanceStatus.late)
                  Chip(
                    label: const Text('Late'),
                    backgroundColor: tokens.color.warning.withOpacity(.12),
                    avatar: Icon(Icons.history_toggle_off, color: tokens.color.warning, size: 18),
                  )
                else
                  Chip(
                    label: const Text('On Time'),
                    backgroundColor: tokens.color.success.withOpacity(.12),
                    avatar: Icon(Icons.check_circle_outline, color: tokens.color.success, size: 18),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (today == null)
              _PreCheckIn(policy: policy)
            else ...[
              _PostCheckIn(today: today, tokens: tokens),
            ],
          ],
        ),
      ),
    );
  }

  String _dateString(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _PreCheckIn extends StatelessWidget {
  const _PreCheckIn({required this.policy});

  final PolicyEngineResult? policy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You have not checked in yet.', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Text('Late after 10:30 AM → Half Day', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        if (policy?.withinGrace ?? false)
          Chip(
            label: Text('graceWindow'.tr),
            avatar: const Icon(Icons.security, size: 18),
          ),
      ],
    );
  }
}

class _PostCheckIn extends StatelessWidget {
  const _PostCheckIn({required this.today, required this.tokens});

  final AttendanceRecordModel today;
  final DesignTokens tokens;

  @override
  Widget build(BuildContext context) {
    BreakSessionModel? activeBreak;
    for (final brk in today.breaks) {
      if (brk.end == null) {
        activeBreak = brk;
        break;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _TimeTile(
              icon: Icons.login,
              label: 'Check-in',
              value: _formatTime(today.checkIn),
            ),
            const SizedBox(width: 16),
            _TimeTile(
              icon: Icons.timer_outlined,
              label: 'Elapsed',
              value: _elapsed(today.checkIn, today.checkOut),
            ),
            if (today.checkOut != null) ...[
              const SizedBox(width: 16),
              _TimeTile(
                icon: Icons.logout,
                label: 'Check-out',
                value: _formatTime(today.checkOut!),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        if (activeBreak != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tokens.color.info.withOpacity(.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_cafe_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Break running', style: Theme.of(context).textTheme.titleMedium),
                      Text('Type: ${activeBreak.type.name} · ${_elapsed(activeBreak.start, DateTime.now())}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Chip(
                  label: const Text('Live'),
                  backgroundColor: tokens.color.info,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatTime(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _elapsed(DateTime start, DateTime? end) {
    final duration = (end ?? DateTime.now()).difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.today, required this.policy});

  final AttendanceRecordModel? today;
  final PolicyEngineResult? policy;

  @override
  Widget build(BuildContext context) {
    final total = today?.workedDuration ?? Duration.zero;
    final breaks = today?.breakDuration ?? Duration.zero;
    final overtime = policy?.overtimeDuration ?? Duration.zero;
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.3,
      ),
      children: [
        _StatCard(title: 'Total time', value: _duration(total), icon: 'assets/icons/check_in.svg'),
        _StatCard(title: 'Breaks', value: _duration(breaks), icon: 'assets/icons/auto_checkout.svg'),
        _StatCard(title: 'OT', value: _duration(overtime), icon: 'assets/icons/policy.svg'),
        _StatCard(title: 'Status', value: policy?.status.label ?? '--', icon: 'assets/icons/check_in.svg'),
      ],
    );
  }

  String _duration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SvgPicture.asset(icon, height: 32, width: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodySmall),
                  Text(value, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmartAlerts extends StatelessWidget {
  const _SmartAlerts({required this.policy});

  final PolicyEngineResult? policy;

  @override
  Widget build(BuildContext context) {
    if (policy == null) {
      return const SizedBox.shrink();
    }
    final alerts = <String>[];
    if (policy.triggersHalfDay) {
      alerts.add('Half Day applied — submit regularization if approved by manager.');
    } else if (policy.status == AttendanceStatus.late) {
      alerts.add('You\'re nearing the 10:30 AM cutoff.');
    }
    if (policy.requiresCheckout) {
      alerts.add('Remember to checkout before auto checkout at 8:00 PM.');
    }
    if (alerts.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Smart alerts', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...alerts.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications_active, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(child: Text(e)),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList({required this.records});

  final List<AttendanceRecordModel> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent activity', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          const ListTile(
            leading: Icon(Icons.hourglass_empty_outlined),
            title: Text('No punches yet'),
            subtitle: Text('Your actions appear here for quick audit.'),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent activity', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...records.map(
          (record) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: record.status.color.withOpacity(.12),
                child: Icon(Icons.access_time, color: record.status.color),
              ),
              title: Text('${record.date.day}/${record.date.month} · ${record.status.label}'),
              subtitle: Text('In ${record.checkIn.hour}:${record.checkIn.minute.toString().padLeft(2, '0')}  ·  Out ${record.checkOut?.hour ?? '--'}:${record.checkOut?.minute.toString().padLeft(2, '0') ?? '--'}'),
              trailing: record.autoCheckout != null
                  ? Chip(
                      label: Text('autoCheckout'.tr),
                      avatar: const Icon(Icons.flash_on, size: 16),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
