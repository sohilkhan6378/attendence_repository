import 'package:flutter/material.dart';

class AdminSettingsView extends StatelessWidget {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Company settings', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                TextField(decoration: InputDecoration(labelText: 'Company name')),
                SizedBox(height: 12),
                TextField(decoration: InputDecoration(labelText: 'Time zone')),
                SizedBox(height: 12),
                TextField(decoration: InputDecoration(labelText: 'Working locations')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Integrations', style: Theme.of(context).textTheme.titleMedium),
                SwitchListTile.adaptive(
                  value: true,
                  onChanged: (_) {},
                  title: const Text('Email alerts'),
                  subtitle: const Text('SMTP: alerts@pulsetime.com'),
                ),
                SwitchListTile.adaptive(
                  value: false,
                  onChanged: (_) {},
                  title: const Text('Slack / Teams'),
                  subtitle: const Text('Configure attendance bot webhooks'),
                ),
                SwitchListTile.adaptive(
                  value: true,
                  onChanged: (_) {},
                  title: const Text('Cloud storage'),
                  subtitle: const Text('S3 · Attendance exports backup'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
