import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/themes/app_theme.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = DesignTokens.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Select workspace')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 720;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _WorkspaceCard(
                        icon: Icons.badge_outlined,
                        title: 'Employee experience',
                        description: 'Mark attendance, view calendar, raise requests and track reports.',
                        highlights: const [
                          'Smart alerts with grace insights',
                          'Offline punches auto-sync',
                          'Policy aware check-ins',
                        ],
                        color: tokens.color.primary,
                        onTap: () {
                          controller.setRole('employee');
                          controller.launch();
                        },
                      ),
                    ),
                    SizedBox(width: isWide ? 24 : 0, height: isWide ? 0 : 24),
                    Expanded(
                      child: _WorkspaceCard(
                        icon: Icons.insights_outlined,
                        title: 'Admin control center',
                        description: 'Monitor workforce, approve regularization, manage shifts & policies.',
                        highlights: const [
                          'Real-time dashboards',
                          'Policy automation',
                          'Exports & schedules',
                        ],
                        color: tokens.color.secondary,
                        onTap: () {
                          controller.setRole('admin');
                          controller.launch();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  const _WorkspaceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.highlights,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<String> highlights;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(.12),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              ...highlights.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: color, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(e)),
                      ],
                    ),
                  )),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: FilledButton.tonal(
                  onPressed: onTap,
                  child: const Text('Launch'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
