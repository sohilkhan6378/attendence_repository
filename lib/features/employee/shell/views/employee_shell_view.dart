import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/themes/app_theme.dart';
import '../../../../core/models/attendance_models.dart';
import '../../calendar/views/employee_calendar_view.dart';
import '../../home/views/employee_home_view.dart';
import '../../profile/views/employee_profile_view.dart';
import '../../reports/views/employee_reports_view.dart';
import '../../requests/views/employee_requests_view.dart';
import '../controllers/employee_shell_controller.dart';

class EmployeeShellView extends GetView<EmployeeShellController> {
  const EmployeeShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = DesignTokens.of(context);
    return Obx(
      () => Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              EmployeeHomeView(),
              EmployeeCalendarView(),
              EmployeeRequestsView(),
              EmployeeReportsView(),
              EmployeeProfileView(),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.setIndex,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Calendar'),
            NavigationDestination(icon: Icon(Icons.pending_actions_outlined), selectedIcon: Icon(Icons.library_books), label: 'Requests'),
            NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Reports'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
        floatingActionButton: controller.currentIndex.value == 0
            ? FloatingActionButton.extended(
                onPressed: () => _showMarkAttendanceSheet(context),
                icon: const Icon(Icons.fingerprint),
                label: const Text('Mark attendance'),
                backgroundColor: tokens.color.primary,
                foregroundColor: tokens.color.onPrimary,
              )
            : null,
      ),
    );
  }

  Future<void> _showMarkAttendanceSheet(BuildContext context) async {
    final tokens = DesignTokens.of(context);
    final today = controller.todayRecord.value;
    final policy = controller.policy.value;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
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
              Row(
                children: [
                  Icon(Icons.fingerprint, color: tokens.color.primary),
                  const SizedBox(width: 12),
                  Text('Mark attendance', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 16),
              if (policy != null && policy.withinGrace)
                Text('Within grace — checkout before ${policy.autoCheckoutAt?.hour.toString().padLeft(2, '0')}:${policy.autoCheckoutAt?.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.icon(
                    onPressed: controller.checkIn,
                    icon: const Icon(Icons.login),
                    label: Text('checkIn'.tr),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: today == null
                        ? null
                        : () {
                            controller.startBreak(BreakType.paid);
                            Get.back();
                          },
                    icon: const Icon(Icons.free_breakfast_outlined),
                    label: const Text('Start Paid Break'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: today == null || today.breaks.where((b) => b.end == null).isEmpty
                        ? null
                        : () {
                            final breakId = today.breaks.firstWhere((b) => b.end == null).id;
                            controller.endBreak(breakId);
                            Get.back();
                          },
                    icon: const Icon(Icons.timer_off_outlined),
                    label: const Text('End Break'),
                  ),
                  FilledButton.icon(
                    onPressed: today == null
                        ? null
                        : () {
                            controller.checkOut();
                            Get.back();
                          },
                    icon: const Icon(Icons.logout),
                    label: Text('checkOut'.tr),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Policy hints', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      _PolicyHint(icon: Icons.watch_later_outlined, label: 'Half Day if check-in after 10:30 AM'),
                      _PolicyHint(icon: Icons.bedtime_outlined, label: 'Auto checkout at 8:00 PM unless edited'),
                      _PolicyHint(icon: Icons.emergency_share_outlined, label: 'Request edit for missing punches within 3 days'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PolicyHint extends StatelessWidget {
  const _PolicyHint({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
