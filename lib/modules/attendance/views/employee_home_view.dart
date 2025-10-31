import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/stat_tile.dart';
import '../../shared/widgets/status_chip.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_models.dart';

/// EmployeeHomeView कर्मचारी को आज की उपस्थिति स्थिति दिखाता है।
class EmployeeHomeView extends StatelessWidget {
  EmployeeHomeView({super.key});

  final RxInt _navIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.find<AttendanceController>();
    return Obx(
      () {
        final employee = controller.primaryEmployee;
        final day = controller.todayRecord;
        return Scaffold(
          appBar: AppBar(
            title: Text('home_today'.tr),
            actions: [
              IconButton(
                icon: const Icon(Icons.cloud_sync_outlined),
                onPressed: controller.queueForSync,
              ),
              IconButton(
                icon: const Icon(Icons.file_download_outlined),
                onPressed: () async {
                  final bytes = await controller.downloadMisReport();
                  if (bytes != null) {
                    Get.snackbar('Excel', 'MIS फाइल तैयार है (डेमो)।');
                  }
                },
              ),
            ],
          ),
          bottomNavigationBar: Obx(
            () => NavigationBar(
              selectedIndex: _navIndex.value,
              onDestinationSelected: (index) {
                _navIndex.value = index;
                switch (index) {
                  case 0:
                    break;
                  case 1:
                    Get.toNamed(AppRoutes.calendar);
                    break;
                  case 2:
                    Get.toNamed(AppRoutes.requests);
                    break;
                  case 3:
                    Get.toNamed(AppRoutes.reports);
                    break;
                  case 4:
                    Get.toNamed(AppRoutes.profile);
                    break;
                }
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.calendar_today_outlined), label: 'Calendar'),
                NavigationDestination(
                    icon: Icon(Icons.inbox_outlined), label: 'Requests'),
                NavigationDestination(
                    icon: Icon(Icons.bar_chart_outlined), label: 'Reports'),
                NavigationDestination(
                    icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (employee != null)
                    _buildHeader(context, employee, day),
                  const SizedBox(height: 24),
                  _buildActionCard(context, controller, day),
                  const SizedBox(height: 24),
                  _buildStatsRow(context, controller),
                  const SizedBox(height: 24),
                  _buildAlerts(context, controller),
                  const SizedBox(height: 24),
                  _buildRecentActivity(context, controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    EmployeeModel employee,
    AttendanceDay? day,
  ) {
    final status = day?.status ?? AttendanceStatus.absent;
    final statusColor = switch (status) {
      AttendanceStatus.present => Theme.of(context).colorScheme.primary,
      AttendanceStatus.late => Theme.of(context).colorScheme.tertiary,
      AttendanceStatus.halfDay => Theme.of(context).colorScheme.error,
      AttendanceStatus.autoCheckout => Theme.of(context).colorScheme.tertiary,
      AttendanceStatus.absent => Theme.of(context).colorScheme.error,
    };
    final statusLabel = switch (status) {
      AttendanceStatus.present => 'On Time',
      AttendanceStatus.late => 'Late',
      AttendanceStatus.halfDay => 'Half Day',
      AttendanceStatus.autoCheckout => 'Auto Checkout',
      AttendanceStatus.absent => 'Not Marked',
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(employee.name.characters.first),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                Text('${employee.department} • ${employee.role}',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 6),
                StatusChip(label: statusLabel, color: statusColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    AttendanceController controller,
    AttendanceDay? day,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                day?.checkIn != null
                    ? 'Check-in: ${TimeOfDay.fromDateTime(day!.checkIn!).format(context)}'
                    : 'Check-in pending',
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: day?.checkIn == null ? 'check_in'.tr : 'start_break'.tr,
                  onPressed: () {
                    if (day?.checkIn == null) {
                      controller.performCheckIn();
                    } else {
                      controller.startBreak();
                    }
                  },
                  icon: Icons.login,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: day?.checkOut == null
                      ? (day?.breaks.isNotEmpty == true &&
                              day?.breaks.last.end == null
                          ? 'end_break'.tr
                          : 'check_out'.tr)
                      : 'check_out'.tr,
                  onPressed: () {
                    if (day == null) {
                      controller.performCheckIn();
                    } else if (day.breaks.isNotEmpty && day.breaks.last.end == null) {
                      controller.endBreak();
                    } else if (day.checkOut == null) {
                      controller.performCheckOut();
                    }
                  },
                  icon: Icons.logout,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'half_day_after'.tr,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colorScheme.tertiary),
          ),
          if (day?.autoCheckoutApplied == true) ...[
            const SizedBox(height: 8),
            Text('auto_checkout_info'.tr,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    AttendanceController controller,
  ) {
    final day = controller.todayRecord;
    final totalWork = day?.totalWorkDuration ?? Duration.zero;
    final totalBreak = day?.totalBreakDuration ?? Duration.zero;
    return Row(
      children: [
        Expanded(
          child: StatTile(
            title: 'Total Work',
            value:
                '${totalWork.inHours}h ${(totalWork.inMinutes % 60).toString().padLeft(2, '0')}m',
            icon: Icons.timer_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatTile(
            title: 'Break Time',
            value:
                '${totalBreak.inHours}h ${(totalBreak.inMinutes % 60).toString().padLeft(2, '0')}m',
            icon: Icons.free_breakfast_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAlerts(BuildContext context, AttendanceController controller) {
    final day = controller.todayRecord;
    final now = TimeOfDay.now();
    final cutoff = controller.primaryEmployee?.shift.start;
    final bool nearCutoff = cutoff != null &&
        now.hour == cutoff.hour &&
        now.minute >= cutoff.minute - 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Smart Alerts',
            style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 12),
        if (day?.checkIn == null && nearCutoff)
          _alertCard(context,
              icon: Icons.alarm, message: 'You’re nearing 10:30 AM cutoff.'),
        if (day?.checkOut == null)
          _alertCard(context,
              icon: Icons.logout, message: 'Remember to check-out before 8:00 PM.'),
      ],
    );
  }

  Widget _alertCard(BuildContext context,
      {required IconData icon, required String message}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.tertiary),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(
      BuildContext context, AttendanceController controller) {
    final day = controller.todayRecord;
    final checkIn = day?.checkIn;
    final checkOut = day?.checkOut;
    final breaks = day?.breaks ?? <BreakPeriod>[];
    final items = <String>[
      if (checkIn != null)
        'Check-in ${TimeOfDay.fromDateTime(checkIn).format(context)}',
      if (breaks.isNotEmpty) 'Breaks: ${breaks.length} entries',
      if (checkOut != null)
        'Check-out ${TimeOfDay.fromDateTime(checkOut).format(context)}',
    ];
    if (items.isEmpty) {
      items.add('No activity logged today.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity',
            style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 12),
        ...items.map(
          (item) => ListTile(
            leading: const Icon(Icons.fiber_manual_record, size: 12),
            title: Text(item),
          ),
        ),
      ],
    );
  }
}
