import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/attendance_models.dart';
import '../../shell/controllers/employee_shell_controller.dart';

class EmployeeRequestsView extends GetView<EmployeeShellController> {
  const EmployeeRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Regularization'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FilledButton.icon(
                onPressed: () => _createRequest(context),
                icon: const Icon(Icons.add_task),
                label: const Text('New request'),
              ),
            ),
          ],
        ),
        body: Obx(
          () {
            final pending = controller.requests.where((e) => e.status == RequestStatus.pending).toList();
            final approved = controller.requests.where((e) => e.status == RequestStatus.approved).toList();
            final rejected = controller.requests.where((e) => e.status == RequestStatus.rejected).toList();
            return TabBarView(
              children: [
                _RequestList(items: pending, emptyMessage: 'Nothing pending — great job!'),
                _RequestList(items: approved, emptyMessage: 'No approvals yet'),
                _RequestList(items: rejected, emptyMessage: 'No rejections, keep it up'),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _createRequest(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    DateTime selectedDate = DateTime.now();
    RequestType selectedType = RequestType.missingPunch;
    final reasonController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create request', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              DropdownButtonFormField<RequestType>(
                initialValue: selectedType,
                decoration: const InputDecoration(labelText: 'Issue type'),
                items: const [
                  DropdownMenuItem(value: RequestType.missingPunch, child: Text('Missing punch')),
                  DropdownMenuItem(value: RequestType.wrongTime, child: Text('Wrong time')),
                  DropdownMenuItem(value: RequestType.breakAdjustment, child: Text('Break adjustment')),
                ],
                onChanged: (value) {
                  if (value != null) selectedType = value;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Please add a reason' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          selectedDate = picked;
                        }
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file_outlined),
                      label: const Text('Attach proof'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    controller.submitRequest(
                      RequestModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        type: selectedType,
                        date: selectedDate,
                        status: RequestStatus.pending,
                        reason: reasonController.text,
                      ),
                    );
                    Get.back();
                  }
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text('Submit for approval'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestList extends StatelessWidget {
  const _RequestList({required this.items, required this.emptyMessage});

  final List<RequestModel> items;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.layers_clear_outlined, size: 48),
            const SizedBox(height: 12),
            Text(emptyMessage, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final request = items[index];
        return Card(
          child: ListTile(
            title: Text('${request.type.name} · ${request.date.day}/${request.date.month}'),
            subtitle: Text(request.reason),
            trailing: Chip(
              label: Text(request.status.label),
              backgroundColor: request.status.color.withOpacity(.12),
              avatar: Icon(Icons.verified, color: request.status.color),
            ),
          ),
        );
      },
    );
  }
}
