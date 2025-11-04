import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../attendance/controllers/attendance_controller.dart';
import '../../attendance/models/attendance_models.dart';
import '../controllers/admin_controller.dart';

/// AdminShellView डेस्कटॉप/टैबलेट के लिए बेसिक एडमिन पैनल तैयार करता है।
class AdminShellView extends StatelessWidget {
  AdminShellView({super.key});

  final RxInt _index = 0.obs;

  @override
  Widget build(BuildContext context) {
    Get.put(AdminController());
    final AdminController adminController = Get.find<AdminController>();
    final AttendanceController attendanceController =
        Get.find<AttendanceController>();
    return Obx(
      () => Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: MediaQuery.of(context).size.width > 1000,
              selectedIndex: _index.value,
              onDestinationSelected: (value) => _index.value = value,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.group_outlined),
                  label: Text('Team'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.request_page_outlined),
                  label: Text('Requests'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.policy_outlined),
                  label: Text('Policies'),
                ),
              ],
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildPage(
                  context,
                  adminController,
                  attendanceController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, AdminController adminController,
      AttendanceController attendanceController) {
    switch (_index.value) {
      case 0:
        return _DashboardView(controller: adminController);
      case 1:
        return _TeamView(attendanceController: attendanceController);
      case 2:
        return _RequestsView();
      case 3:
        return _PoliciesView(attendanceController: attendanceController);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({required this.controller});

  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _DashboardCard(
        title: 'Present now',
        value: controller.presentCount.toString(),
        icon: Icons.verified_user_outlined,
      ),
      _DashboardCard(
        title: 'Late arrivals',
        value: controller.lateCount.toString(),
        icon: Icons.timelapse_outlined,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      _DashboardCard(
        title: 'On break',
        value: controller.onBreakCount.toString(),
        icon: Icons.free_breakfast_outlined,
        color: Theme.of(context).colorScheme.secondary,
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Realtime KPIs',
              style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: cards,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today’s punches',
                      style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.todayRecords.length,
                      itemBuilder: (context, index) {
                        final record = controller.todayRecords[index];
                        return ListTile(
                          leading: const Icon(Icons.badge_outlined),
                          title: Text('Employee ${index + 1}'),
                          subtitle: Text(
                              'In: ${record.checkIn?.toIso8601String() ?? '-'} | Out: ${record.checkOut?.toIso8601String() ?? '-'}'),
                          trailing: Text(record.status.name),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamView extends StatelessWidget {
  const _TeamView({required this.attendanceController});

  final AttendanceController attendanceController;

  @override
  Widget build(BuildContext context) {
    final records = attendanceController.attendanceForMonth(DateTime.now());
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Team overview',
              style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 16),
          Expanded(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Day')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Work (h)')),
                DataColumn(label: Text('Break (m)')),
              ],
              rows: records
                  .map(
                    (e) => DataRow(cells: [
                      DataCell(Text(DateFormat('dd MMM').format(e.date))),
                      DataCell(Text(e.status.name)),
                      DataCell(Text(e.totalWorkDuration.inHours.toString())),
                      DataCell(Text(e.totalBreakDuration.inMinutes.toString())),
                    ]),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Use employee mobile to raise regularization requests.\nManager approvals दिखेंगी।'),
    );
  }
}

class _PoliciesView extends StatelessWidget {
  const _PoliciesView({required this.attendanceController});

  final AttendanceController attendanceController;

  @override
  Widget build(BuildContext context) {
    final policy = attendanceController.primaryEmployee?.shift.breakPolicy ??
        const BreakPolicy();
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Policy configuration',
              style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.access_alarm_outlined),
            title: const Text('Half-day cutoff'),
            subtitle: const Text('10:30 AM → Half Day'),
          ),
          ListTile(
            leading: const Icon(Icons.breakfast_dining_outlined),
            title: const Text('Break policy'),
            subtitle:
                Text('Max ${policy.maxBreaks} breaks • Paid ${policy.paidBreaks}'),
          ),
          ListTile(
            leading: const Icon(Icons.my_location_outlined),
            title: const Text('Geo fence'),
            subtitle: const Text('100m radius (configurable)'),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = color ?? colorScheme.primary;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cardColor),
          const SizedBox(height: 12),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: cardColor)),
        ],
      ),
    );
  }
}
