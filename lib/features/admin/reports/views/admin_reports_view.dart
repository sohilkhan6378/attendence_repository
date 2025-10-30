import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shell/controllers/admin_shell_controller.dart';

class AdminReportsView extends GetView<AdminShellController> {
  const AdminReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('MIS & Exports', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.schedule_send_outlined),
                label: const Text('Schedule report'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.grid_view_outlined),
                    title: const Text('Per Employee MIS'),
                    subtitle: const Text('Detailed punches, breaks, approvals'),
                    trailing: FilledButton(onPressed: () {}, child: const Text('Export XLSX')),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.analytics_outlined),
                    title: const Text('Company summary'),
                    subtitle: const Text('Attendance trend, break usage, overtime'),
                    trailing: FilledButton(onPressed: () {}, child: const Text('Export PDF')),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Report builder', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: const [
                            _ChipFilter(label: 'This week'),
                            _ChipFilter(label: 'Last month'),
                            _ChipFilter(label: 'Custom range'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const TextField(
                          decoration: InputDecoration(labelText: 'Departments / People'),
                        ),
                        const SizedBox(height: 16),
                        const TextField(
                          decoration: InputDecoration(labelText: 'Columns'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.table_view_outlined),
                              label: const Text('Preview'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.save_outlined),
                              label: const Text('Save template'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipFilter extends StatelessWidget {
  const _ChipFilter({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: label == 'This week',
      onSelected: (_) {},
    );
  }
}
