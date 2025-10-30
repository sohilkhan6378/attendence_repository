import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/themes/app_theme.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PulseTime', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  Text(
                    'Enterprise-grade attendance with offline resilience and contextual nudges.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Work Email / Phone',
                      prefixIcon: const Icon(Icons.alternate_email_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'One Time Password',
                      prefixIcon: const Icon(Icons.lock_clock_rounded),
                      suffixIcon: TextButton(onPressed: () {}, child: const Text('Resend OTP')),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'employee', label: Text('Employee')),
                        ButtonSegment(value: 'admin', label: Text('Admin')), 
                      ],
                      selected: {controller.selectedRole.value},
                      onSelectionChanged: (value) => controller.switchRole(value.first),
                      showSelectedIcon: false,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => FilledButton(
                            onPressed: controller.isLoading.value ? null : controller.login,
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2.2),
                                  )
                                : const Text('Continue'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.business_center_outlined),
                        label: const Text('SSO'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.help_outline),
                    label: const Text('Need access? Contact your admin'),
                  ),
                  const SizedBox(height: 48),
                  const Divider(),
                  const SizedBox(height: 16),
                  const _DesignTokensPreview(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesignTokensPreview extends StatelessWidget {
  const _DesignTokensPreview();

  @override
  Widget build(BuildContext context) {
    final tokens = DesignTokens.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key Tokens', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _TokenChip('Primary', tokens.color.primary),
            _TokenChip('Secondary', tokens.color.secondary),
            _TokenChip('Warning', tokens.color.warning),
            _TokenChip('Success', tokens.color.success),
            _TokenChip('Error', tokens.color.error),
            _TokenChip('Info', tokens.color.info),
          ],
        ),
      ],
    );
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: tokensOnColor(color))),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Color tokensOnColor(Color color) => color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
