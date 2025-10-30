import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shell/controllers/admin_shell_controller.dart';

class AdminTeamView extends GetView<AdminShellController> {
  const AdminTeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Team overview', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined),
                label: const Text('Export'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add shift'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(
              () => DataTable(
                columns: const [
                  DataColumn(label: Text('Employee')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('First punch')),
                  DataColumn(label: Text('Last punch')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Location')),
                ],
                rows: controller.team
                    .map(
                      (member) => DataRow(
                        cells: [
                          DataCell(Text(member.name)),
                          DataCell(Text(member.role)),
                          DataCell(Text(member.firstPunch)),
                          DataCell(Text(member.lastPunch)),
                          DataCell(Chip(label: Text(member.status.label))),
                          DataCell(Text(member.location)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
