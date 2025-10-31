// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../app/themes/app_theme.dart';
// import '../../dashboard/views/admin_dashboard_view.dart';
// import '../../policies/views/admin_policies_view.dart';
// import '../../reports/views/admin_reports_view.dart';
// import '../../requests/views/admin_requests_view.dart';
// import '../../settings/views/admin_settings_view.dart';
// import '../../team/views/admin_team_view.dart';
// import '../controllers/admin_shell_controller.dart';
//
// class AdminShellView extends GetView<AdminShellController> {
//   const AdminShellView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isWide = MediaQuery.of(context).size.width >= 1024;
//       final navigation = _AdminNavigation(
//         controller: controller,
//         isWide: isWide,
//       );
//       final content = Expanded(
//         child: SafeArea(
//           child: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 200),
//             child: _AdminContent(index: controller.currentIndex.value),
//           ),
//         ),
//       );
//       if (isWide) {
//         return Scaffold(body: Row(children: [navigation, content]));
//       }
//       return Scaffold(
//         body: content,
//         bottomNavigationBar: NavigationBarTheme(
//           data: NavigationBarThemeData(
//             labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>((
//               states,
//             ) {
//               if (states.contains(MaterialState.selected)) {
//                 return const TextStyle(
//                   fontWeight: FontWeight.w400,
//                   color: Colors.blue,
//                   fontSize: 10,
//                 );
//               }
//               return const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey,
//                 fontSize: 10,
//
//               );
//             }),
//           ),
//           child: NavigationBar(
//             selectedIndex: controller.currentIndex.value,
//             onDestinationSelected: controller.setIndex,
//             destinations: const [
//               NavigationDestination(
//                 icon: Icon(Icons.dashboard_outlined),
//                 label: 'Dashboard',
//               ),
//               NavigationDestination(
//                 icon: Icon(Icons.groups_3_outlined),
//                 label: 'Team',
//               ),
//               NavigationDestination(
//                 icon: Icon(Icons.task_alt_outlined),
//                 label: 'Requests',
//               ),
//               NavigationDestination(
//                 icon: Icon(Icons.rule_folder_outlined),
//                 label: 'Policies',
//               ),
//               NavigationDestination(
//                 icon: Icon(Icons.assessment_outlined),
//                 label: 'Reports',
//               ),
//               NavigationDestination(
//                 icon: Icon(Icons.settings_outlined),
//                 label: 'Settings',
//               ),
//             ],
//           ),
//         ),
//
//         // NavigationBar(
//         //   selectedIndex: controller.currentIndex.value,
//         //   onDestinationSelected: controller.setIndex,
//         //   labelTextStyle: ,
//         //   destinations: const [
//         //     NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard',),
//         //     NavigationDestination(icon: Icon(Icons.groups_3_outlined), label: 'Team'),
//         //     NavigationDestination(icon: Icon(Icons.task_alt_outlined), label: 'Requests'),
//         //     NavigationDestination(icon: Icon(Icons.rule_folder_outlined), label: 'Policies'),
//         //     NavigationDestination(icon: Icon(Icons.assessment_outlined), label: 'Reports'),
//         //     NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings',),
//         //   ],
//         // ),
//       );
//     });
//   }
// }
//
// class _AdminNavigation extends StatelessWidget {
//   const _AdminNavigation({required this.controller, required this.isWide});
//
//   final AdminShellController controller;
//   final bool isWide;
//
//   @override
//   Widget build(BuildContext context) {
//     final tokens = DesignTokens.of(context);
//     return Container(
//       width: isWide ? 280 : 72,
//       decoration: BoxDecoration(
//         color: tokens.color.surface,
//         border: Border(right: BorderSide(color: tokens.color.divider)),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//             child: Row(
//               children: [
//                 Icon(Icons.hub_outlined, color: tokens.color.primary),
//                 if (isWide) ...[
//                   const SizedBox(width: 12),
//                   Text(
//                     'Admin Console',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ],
//                 const Spacer(),
//                 IconButton(
//                   onPressed: controller.toggleCompact,
//                   icon: Icon(
//                     controller.compactMode.value
//                         ? Icons.view_agenda
//                         : Icons.view_week_outlined,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _NavTile(
//                   index: 0,
//                   controller: controller,
//                   icon: Icons.dashboard_outlined,
//                   label: 'Dashboard',
//                   isWide: isWide,
//                 ),
//                 _NavTile(
//                   index: 1,
//                   controller: controller,
//                   icon: Icons.groups_3_outlined,
//                   label: 'Team',
//                   isWide: isWide,
//                 ),
//                 _NavTile(
//                   index: 2,
//                   controller: controller,
//                   icon: Icons.task_alt_outlined,
//                   label: 'Requests',
//                   isWide: isWide,
//                 ),
//                 _NavTile(
//                   index: 3,
//                   controller: controller,
//                   icon: Icons.rule_folder_outlined,
//                   label: 'Policies',
//                   isWide: isWide,
//                 ),
//                 _NavTile(
//                   index: 4,
//                   controller: controller,
//                   icon: Icons.assessment_outlined,
//                   label: 'Reports',
//                   isWide: isWide,
//                 ),
//                 _NavTile(
//                   index: 5,
//                   controller: controller,
//                   icon: Icons.settings_outlined,
//                   label: 'Settings',
//                   isWide: isWide,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _NavTile extends StatelessWidget {
//   const _NavTile({
//     required this.index,
//     required this.controller,
//     required this.icon,
//     required this.label,
//     required this.isWide,
//   });
//
//   final int index;
//   final AdminShellController controller;
//   final IconData icon;
//   final String label;
//   final bool isWide;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isSelected = controller.currentIndex.value == index;
//       return ListTile(
//         leading: Icon(
//           icon,
//           color: isSelected ? Theme.of(context).colorScheme.primary : null,
//         ),
//         title: isWide ? Text(label, style: TextStyle(fontSize: 14)) : null,
//         selected: isSelected,
//         onTap: () => controller.setIndex(index),
//       );
//     });
//   }
// }
//
// class _AdminContent extends StatelessWidget {
//   const _AdminContent({required this.index});
//
//   final int index;
//
//   @override
//   Widget build(BuildContext context) {
//     switch (index) {
//       case 0:
//         return const AdminDashboardView();
//       case 1:
//         return const AdminTeamView();
//       case 2:
//         return const AdminRequestsView();
//       case 3:
//         return const AdminPoliciesView();
//       case 4:
//         return const AdminReportsView();
//       case 5:
//         return const AdminSettingsView();
//       default:
//         return const AdminDashboardView();
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';

// NOTE: yeh aapke existing views hain — imports same rakhe gaye.
import '../../../../app/themes/app_theme.dart';
import '../../dashboard/views/admin_dashboard_view.dart';
import '../../policies/views/admin_policies_view.dart';
import '../../reports/views/admin_reports_view.dart';
import '../../requests/views/admin_requests_view.dart';
import '../../settings/views/admin_settings_view.dart';
import '../../team/views/admin_team_view.dart';
import '../controllers/admin_shell_controller.dart';

/// AdminShellView
/// - Yeh pura Admin console ka shell/layout manage karta hai.
/// - Wide screen par (>=1024px) left side rail + right side content.
/// - Mobile par bottom NavigationBar + upar content.
class AdminShellView extends GetView<AdminShellController> {
  const AdminShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final size = MediaQuery.of(context).size;
      final isWide = size.width >= 1024;

      // ---------------------------------------------
      // contentWidget: SafeArea + AnimatedSwitcher
      // ---------------------------------------------
      // IMPORTANT: Yaha Expanded NAHIN lagayenge.
      // Expanded sirf Row/Column ke andar use hota hai.
      final Widget contentWidget = SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _AdminContent(index: controller.currentIndex.value),
        ),
      );

      // ---------------------------------------------
      // WIDE LAYOUT: Row(navigation, Expanded(content))
      // ---------------------------------------------
      if (isWide) {
        return Scaffold(
          body: Row(
            children: [
              _AdminNavigation(controller: controller, isWide: isWide),
              // Yaha Expanded sahi jagah par hai (Row ka child)
              Expanded(child: contentWidget),
            ],
          ),
        );
      }

      // ---------------------------------------------
      // NARROW LAYOUT (Mobile): sirf content + bottom nav
      // NOTE: Yaha body me Expanded BILKUL mat lagana.
      // ---------------------------------------------
      return Scaffold(
        body: contentWidget,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            // Label text style: selected/unselected ke liye alag style
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>((states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                );
              }
              return const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: controller.currentIndex.value,
            onDestinationSelected: controller.setIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.groups_3_outlined),
                label: 'Team',
              ),
              NavigationDestination(
                icon: Icon(Icons.task_alt_outlined),
                label: 'Requests',
              ),
              NavigationDestination(
                icon: Icon(Icons.rule_folder_outlined),
                label: 'Policies',
              ),
              NavigationDestination(
                icon: Icon(Icons.assessment_outlined),
                label: 'Reports',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// Left-side Navigation (Rail style on wide screens)
/// - isWide true hoga to text labels show honge
/// - warna compact icon-only rail
class _AdminNavigation extends StatelessWidget {
  const _AdminNavigation({required this.controller, required this.isWide});

  final AdminShellController controller;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    // DesignTokens aapke theme system ka hissa hai (already aapke project me).
    final tokens = DesignTokens.of(context);

    return Container(
      width: isWide ? 280 : 72, // wide par bada sidebar, narrow par compact
      decoration: BoxDecoration(
        color: tokens.color.surface,
        border: Border(right: BorderSide(color: tokens.color.divider)),
      ),
      child: Column(
        children: [
          // ---------------- Header (Logo/Title + Compact toggle) ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                Icon(Icons.hub_outlined, color: tokens.color.primary),
                if (isWide) ...[
                  const SizedBox(width: 12),
                  Text('Admin Console', style: Theme.of(context).textTheme.titleMedium),
                ],
                const Spacer(),
                // Compact toggle (aapke controller me bool Rx hai)
                Obx(() {
                  final compact = controller.compactMode.value;
                  return IconButton(
                    tooltip: compact ? 'Expand navigation' : 'Compact navigation',
                    onPressed: controller.toggleCompact,
                    icon: Icon(compact ? Icons.view_agenda : Icons.view_week_outlined),
                  );
                }),
              ],
            ),
          ),

          // ---------------- Nav Items ----------------
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _NavTile(
                  index: 0,
                  controller: controller,
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  isWide: isWide,
                ),
                _NavTile(
                  index: 1,
                  controller: controller,
                  icon: Icons.groups_3_outlined,
                  label: 'Team',
                  isWide: isWide,
                ),
                _NavTile(
                  index: 2,
                  controller: controller,
                  icon: Icons.task_alt_outlined,
                  label: 'Requests',
                  isWide: isWide,
                ),
                _NavTile(
                  index: 3,
                  controller: controller,
                  icon: Icons.rule_folder_outlined,
                  label: 'Policies',
                  isWide: isWide,
                ),
                _NavTile(
                  index: 4,
                  controller: controller,
                  icon: Icons.assessment_outlined,
                  label: 'Reports',
                  isWide: isWide,
                ),
                _NavTile(
                  index: 5,
                  controller: controller,
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  isWide: isWide,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Single navigation item (icon + optional label)
class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.index,
    required this.controller,
    required this.icon,
    required this.label,
    required this.isWide,
  });

  final int index;
  final AdminShellController controller;
  final IconData icon;
  final String label;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Obx(() {
      final isSelected = controller.currentIndex.value == index;

      return ListTile(
        leading: Icon(
          icon,
          color: isSelected ? t.colorScheme.primary : null,
        ),
        title: isWide ? Text(label, style: const TextStyle(fontSize: 14)) : null,
        selected: isSelected,
        selectedTileColor: t.colorScheme.primary.withOpacity(.08),
        onTap: () => controller.setIndex(index),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
    });
  }
}

/// Content switcher: index ke base par kaun sa page dikhega
class _AdminContent extends StatelessWidget {
  const _AdminContent({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return const AdminDashboardView();
      case 1:
        return const AdminTeamView();
      case 2:
        return const AdminRequestsView();
      case 3:
        return const AdminPoliciesView();
      case 4:
        return const AdminReportsView();
      case 5:
        return const AdminSettingsView();
      default:
        return const AdminDashboardView();
    }
  }
}
