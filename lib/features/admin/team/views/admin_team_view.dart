import 'package:attendence_management_software/core/models/attendance_models.dart';
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team overview',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
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
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(
                  () => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                      ),
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      ),
                      columnSpacing: 28,
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 60,
                      columns: const [
                        DataColumn(label: Text('Employee')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('First punch')),
                        DataColumn(label: Text('Last punch')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Location')),
                      ],
                      rows: controller.team.map(
                            (member) => DataRow(
                          cells: [
                            DataCell(Text(member.name)),
                            DataCell(Text(member.role)),
                            DataCell(Text(member.firstPunch)),
                            DataCell(Text(member.lastPunch)),
                            DataCell(
                              Chip(
                                label: Text(
                                  member.status.label,
                                  style: const TextStyle(fontSize: 12,color: Colors.black87),
                                ),
                                backgroundColor: member.status.label.toLowerCase().contains('late')
                                    ? Colors.red.shade50
                                    : Colors.green.shade50,
                                side: BorderSide.none,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            DataCell(Text(member.location)),
                          ],
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
