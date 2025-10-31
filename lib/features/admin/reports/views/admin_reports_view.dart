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
            Column(
            children: [
    _buildReportCard(
    context,
    icon: Icons.grid_view_outlined,
    title: 'Per Employee MIS',
    description: 'Detailed punches, breaks, approvals',
    buttonText: 'Export XLSX',
    onPressed: () {},
    ),
    const SizedBox(height: 12),
    _buildReportCard(
    context,
    icon: Icons.analytics_outlined,
    title: 'Company summary',
    description: 'Attendance trend, break usage, overtime',
    buttonText: 'Export PDF',
    onPressed: () {},
    ),
    ],
    ),

// Helper widget


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
  Widget _buildReportCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required String buttonText,
        required VoidCallback onPressed,
      }) {
    return Card(
      //color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: Colors.blueGrey),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
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
