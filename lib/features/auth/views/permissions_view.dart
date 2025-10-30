import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app/themes/app_theme.dart';
import '../controllers/auth_controller.dart';

class PermissionsView extends GetView<AuthController> {
  const PermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = DesignTokens.of(context);
    final steps = [
      _PermissionStep(
        title: 'Location Access',
        description: 'Allow location to enable geo-fence and QR compliance.',
        asset: 'assets/illustrations/permissions.svg',
      ),
      _PermissionStep(
        title: 'Camera & Face ID',
        description: 'Enable camera for Face ID and QR station punches.',
        asset: 'assets/illustrations/policy.svg',
      ),
      _PermissionStep(
        title: 'Notifications',
        description: 'Receive grace alerts, policy nudges and checkout reminders.',
        asset: 'assets/illustrations/offline.svg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Secure your workspace')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 720;
              return isWide
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Permissions & Security', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: 12),
                              Text(
                                'We only request the essentials. Toggle optional controls anytime from your profile.',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 32),
                              Expanded(
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    final step = steps[index];
                                    return _PermissionCard(tokens: tokens, step: step);
                                  },
                                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                                  itemCount: steps.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: _PolicyHighlight(tokens: tokens),
                        ),
                      ],
                    )
                  : ListView(
                      children: [
                        Text('Permissions & Security', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 12),
                        Text(
                          'We only request the essentials. Toggle optional controls anytime from your profile.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        ...steps.map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _PermissionCard(tokens: tokens, step: e),
                            )),
                        const SizedBox(height: 16),
                        _PolicyHighlight(tokens: tokens),
                      ],
                    );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: FilledButton.icon(
          onPressed: controller.continueToApp,
          icon: const Icon(Icons.verified_user_outlined),
          label: const Text('Continue to workspace'),
        ),
      ),
    );
  }
}

class _PermissionStep {
  const _PermissionStep({required this.title, required this.description, required this.asset});

  final String title;
  final String description;
  final String asset;
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({required this.tokens, required this.step});

  final DesignTokens tokens;
  final _PermissionStep step;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: tokens.color.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(step.asset, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(step.description, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.verified_outlined, color: tokens.color.success, size: 18),
                      const SizedBox(width: 6),
                      Text('Required for full experience', style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyHighlight extends StatelessWidget {
  const _PolicyHighlight({required this.tokens});

  final DesignTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: tokens.color.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.policy_outlined, color: tokens.color.info),
              const SizedBox(width: 12),
              Text('Policy Snapshot', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _PolicyChip('Half Day after 10:30 AM'),
              _PolicyChip('Auto checkout at 8:00 PM'),
              _PolicyChip('Grace 10 minutes'),
              _PolicyChip('Face & QR optional'),
            ],
          ),
          const SizedBox(height: 24),
          Text('Change these anytime in Admin → Policies.', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _PolicyChip extends StatelessWidget {
  const _PolicyChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.check_circle_outline, size: 18),
      label: Text(label),
    );
  }
}
