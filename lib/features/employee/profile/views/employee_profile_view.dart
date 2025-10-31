import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/attendance_models.dart';
import '../../shell/controllers/employee_shell_controller.dart';

class EmployeeProfileView extends GetView<EmployeeShellController> {
  const EmployeeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(
        () {
          final profile = controller.profile.value;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ProfileHeader(profile: profile),
              const SizedBox(height: 24),
              _InfoSection(profile: profile),
              const SizedBox(height: 24),
              _PermissionsSection(profile: profile),
              const SizedBox(height: 24),
              _NotificationsSection(profile: profile),
              const SizedBox(height: 24),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: const Text('View attendance policies'),
                  subtitle: const Text('Half day rules, auto checkout, geo-fence, edit window'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final EmployeeProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 36,
              child: Text(profile.name.substring(0, 1)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.name, style: Theme.of(context).textTheme.titleLarge),
                  Text(profile.employeeCode, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _InfoChip(label: profile.department, icon: Icons.domain_outlined),
                      _InfoChip(label: 'Manager · ${profile.managerName}', icon: Icons.people_outline),
                      _InfoChip(label: 'Shift · ${profile.shift.name}', icon: Icons.schedule_outlined),
                    ],
                  ),
                  SizedBox(height: 15,),

                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      Icon(Icons.upload, size: 30,),
                      SizedBox(width: 8,),
                      Text('Upload Documents',style: TextTheme.of(context).bodyMedium,)
                    ],),
                  ),
                  SizedBox(height: 18,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(children: [
                        Icon(Icons.generating_tokens_outlined, size: 30,),
                        SizedBox(width: 8,),
                        Text('Generate Salary Slip',style: TextTheme.of(context).bodyMedium,)
                      ],),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.profile});

  final EmployeeProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick links', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _QuickLink(icon: Icons.support_agent_outlined, title: 'Helpdesk', subtitle: 'Reach HR for support'),
            _QuickLink(icon: Icons.shield_outlined, title: 'Security settings', subtitle: 'Device trust & biometrics'),
            _QuickLink(icon: Icons.info_outline, title: 'About PulseTime', subtitle: 'Version 1.0.0'),
          ],
        ),
      ),
    );
  }
}

class _PermissionsSection extends StatelessWidget {
  const _PermissionsSection({required this.profile});

  final EmployeeProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Devices & Permissions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _PermissionTile(
              label: 'Location permission',
              enabled: profile.locationPermissionGranted,
              description: 'Used for geo-fence & compliance heatmaps',
            ),
            _PermissionTile(
              label: 'Face ID enrollment',
              enabled: profile.faceEnrolled,
              description: 'Required for high trust punches',
            ),
            _PermissionTile(
              label: 'Linked device',
              enabled: profile.linkedDevice != null,
              description: profile.linkedDevice ?? 'No device linked',
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({required this.profile});

  final EmployeeProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart notifications', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              value: profile.notificationsEnabled,
              onChanged: (_) {},
              title: const Text('Shift reminders & grace alerts'),
              subtitle: const Text('10 minutes before start, grace and auto checkout warnings'),
            ),
            SwitchListTile.adaptive(
              value: true,
              onChanged: (_) {},
              title: const Text('Policy updates'),
              subtitle: const Text('Changes to grace, auto checkout, break rules'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({required this.label, required this.enabled, required this.description});

  final String label;
  final bool enabled;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(enabled ? Icons.check_circle : Icons.error_outline, color: enabled ? Colors.green : Colors.orange),
      title: Text(label),
      subtitle: Text(description),
      trailing: Text(enabled ? 'Enabled' : 'Action needed', style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
