import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shell/controllers/admin_shell_controller.dart';

class AdminPoliciesView extends GetView<AdminShellController> {
  const AdminPoliciesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          Text('Policy controls', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Obx(
            () => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: controller.shifts
                  .map(
                    (shift) => SizedBox(
                      width: 320,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shift.name, style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text('Start ${shift.start} · End ${shift.end}'),
                              Text('Grace ${shift.grace} · Auto checkout ${shift.autoCheckout}'),
                              Text('Breaks ${shift.breaks}'),
                              const SizedBox(height: 12),
                              FilledButton.tonal(
                                onPressed: () {},
                                child: const Text('Edit shift'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Late & Half-day rule', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  const ListTile(
                    leading: Icon(Icons.timer_outlined),
                    title: Text('Half Day if check-in after 10:30 AM'),
                    subtitle: Text('Managers can override on approval'),
                    trailing: Icon(Icons.edit_outlined),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.timelapse_outlined),
                    title: Text('Grace'),
                    subtitle: Text('10 minutes — highlight as within grace on employee UI'),
                    trailing: Icon(Icons.edit_outlined),
                  ),
                  const Divider(),
                  SwitchListTile.adaptive(
                    value: true,
                    onChanged: (_) {},
                    title: const Text('Geo-fence enforcement'),
                    subtitle: const Text('Requires device within 100m radius'),
                  ),
                  SwitchListTile.adaptive(
                    value: false,
                    onChanged: (_) {},
                    title: const Text('Face ID mandatory'),
                    subtitle: const Text('Employees can opt-in if disabled'),
                  ),
                  SwitchListTile.adaptive(
                    value: true,
                    onChanged: (_) {},
                    title: const Text('QR stations enabled'),
                    subtitle: const Text('Set by location in company settings'),
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
