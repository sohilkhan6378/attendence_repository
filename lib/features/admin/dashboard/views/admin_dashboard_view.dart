import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/themes/app_theme.dart';
import '../../shell/controllers/admin_shell_controller.dart';

class AdminDashboardView extends GetView<AdminShellController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = DesignTokens.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _KpiCard(color: tokens.color.primary, label: 'Present now', value: '148'),
              _KpiCard(color: tokens.color.warning, label: 'On break', value: '24'),
              _KpiCard(color: tokens.color.error, label: 'Late arrivals', value: '18'),
              _KpiCard(color: tokens.color.info, label: 'Missing checkout', value: '9'),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 1080;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _TrendCard(title: 'Attendance trend'),
                          const SizedBox(height: 16),
                          _TrendCard(title: 'Late vs On-time'),
                        ],
                      ),
                    ),
                    SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),
                    Expanded(
                      child: Column(
                        children: const [
                          _HeatmapCard(),
                          SizedBox(height: 16),
                          _RealtimeTable(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.color, required this.label, required this.value});

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.open_in_full)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueGrey.withOpacity(.2)),
              ),
              child: const Center(child: Text('Chart placeholder')),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Department heatmap', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(colors: [Color(0xFFDCFCE7), Color(0xFFFFF7ED)]),
              ),
              child: const Center(child: Text('Heatmap placeholder')),
            ),
          ],
        ),
      ),
    );
  }
}

class _RealtimeTable extends GetView<AdminShellController> {
  const _RealtimeTable();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Today\'s punches', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.team.length,
                  itemBuilder: (context, index) {
                    final member = controller.team[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(member.name.substring(0, 1))),
                      title: Text(member.name),
                      subtitle: Text('${member.role} · ${member.location}'),
                      trailing: Wrap(
                        spacing: 12,
                        children: [
                          Chip(label: Text(member.firstPunch)),
                          Chip(label: Text(member.lastPunch)),
                          Chip(label: Text(member.status.label)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
