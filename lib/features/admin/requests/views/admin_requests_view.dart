import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/attendance_models.dart';
import '../../shell/controllers/admin_shell_controller.dart';

class AdminRequestsView extends GetView<AdminShellController> {
  const AdminRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Approvals', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              SizedBox(
                width: 220,
                child: TextField(
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search employee'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_alt_outlined),
                label: const Text('Filters'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(
              () => ListView.separated(
                itemCount: controller.approvalQueue.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final request = controller.approvalQueue[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(request.id)),
                      title: Text('${request.type.name} · ${request.date.day}/${request.date.month}'),
                      subtitle: Text(request.reason),
                      trailing: Wrap(
                        spacing: 12,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('Reject'),
                          ),
                          FilledButton(
                            onPressed: () {},
                            child: const Text('Approve'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
