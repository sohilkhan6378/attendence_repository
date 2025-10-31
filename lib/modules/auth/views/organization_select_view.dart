import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../shared/widgets/primary_button.dart';
import '../controllers/auth_controller.dart';

/// OrganizationSelectView उपयोगकर्ता को ऑर्गनाइज़ेशन चुनने देता है।
class OrganizationSelectView extends StatelessWidget {
  const OrganizationSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: Text('select_org'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('select_org'.tr,
                style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final org = controller.organizations[index];
                  return ListTile(
                    title: Text(org.name),
                    leading: const Icon(Icons.apartment_outlined),
                    onTap: () {
                      controller.selectOrganization(org);
                      Get.toNamed(AppRoutes.permissions);
                    },
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: controller.organizations.length,
              ),
            ),
            PrimaryButton(
              label: 'verify'.tr,
              onPressed: () => Get.toNamed(AppRoutes.permissions),
              icon: Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }
}
