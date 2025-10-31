import 'package:attendence_management_software/core/models/attendance_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/themes/app_theme.dart';
import '../../shell/controllers/admin_shell_controller.dart';

class AdminDashboardView extends GetView<AdminShellController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = DesignTokens.of(context);
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive columns for KPI grid
        final isUltraWide = constraints.maxWidth >= 1440;
        final isWide = constraints.maxWidth >= 1080;
        final kpiCrossAxisCount = isUltraWide ? 4 : (isWide ? 3 : 2);
        final chartHeight = isWide ? 220.0 : 180.0;

        return CustomScrollView(
           slivers: [
             SliverToBoxAdapter(
              child: Text('Overview', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700,fontSize: 20)),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 12)),

            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kpiCrossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 120,
              ),
              delegate: SliverChildListDelegate.fixed(const [
                _KpiCard(colorKey: _KpiColor.primary, label: 'Present now', value: '148'),
                _KpiCard(colorKey: _KpiColor.warning, label: 'On break', value: '24'),
                _KpiCard(colorKey: _KpiColor.error, label: 'Late arrivals', value: '18'),
                _KpiCard(colorKey: _KpiColor.info, label: 'Missing checkout', value: '9'),
              ]),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 24)),

            // --- CHARTS ROW --------------------------------------------------
            SliverToBoxAdapter(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _ChartCard(title: 'Attendance trend', height: chartHeight, width: _w(constraints, take: 2)),
                  _ChartCard(title: 'Late vs On-time', height: chartHeight, width: _w(constraints, take: 2)),
                ],
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 16)),

            // --- HEATMAP + REALTIME TABLE -----------------------------------
            SliverToBoxAdapter(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  const _HeatmapCard(width: 480, height: 200),
                   ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 520, maxWidth: 820),
                    child: const _RealtimeTable(maxRows: 6),
                  ),
                ],
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        );
      },
    );
  }

  // Helper to compute responsive widths for Wrap children
  static double _w(BoxConstraints c, {required int take}) {
    // Take approx half width minus spacing; Clamp for mobile
    final base = c.maxWidth;
    final gutter = 16.0;
    if (base < 720) return base; // stack full-width on small screens
    final columns = 4; // conceptual grid
    final colWidth = (base - (gutter * (columns - 1))) / columns;
    return (colWidth * take) + gutter * (take - 1);
  }
}

enum _KpiColor { primary, warning, error, info }

class _KpiCard extends StatefulWidget {
  const _KpiCard({
    required this.colorKey,
    required this.label,
    required this.value,
  });

  final _KpiColor colorKey;
  final String label;
  final String value;

  @override
  State<_KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<_KpiCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();

  Color _mapColor(BuildContext ctx) {
    final t = DesignTokens.of(ctx).color;
    switch (widget.colorKey) {
      case _KpiColor.primary:
        return t.primary;
      case _KpiColor.warning:
        return t.warning;
      case _KpiColor.error:
        return t.error;
      case _KpiColor.info:
        return t.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _mapColor(context);
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,

              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),side: BorderSide(color: Colors.blueGrey.withOpacity(.14))),
              child: Stack(
                children: [
                  // subtle gradient glass
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.withOpacity(.10),
                            color.withOpacity(.03),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.label, style: theme.textTheme.labelMedium?.copyWith(color: theme.hintColor)),
                        const SizedBox(height: 12),
                        ScaleTransition(
                          scale: CurvedAnimation(parent: _ac, curve: Curves.easeOutBack),
                          child: Text(
                            widget.value,
                            style: theme.textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.height,
    required this.width,
  });

  final String title;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.open_in_full)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blueGrey.withOpacity(.14)),
                ),
                alignment: Alignment.center,
                child: const Text('Chart placeholder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({this.width = 520, this.height = 200});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Department heatmap', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              Container(
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDCFCE7), Color(0xFFFFF7ED)],
                  ),
                ),
                alignment: Alignment.center,
                child: const Text('Heatmap placeholder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RealtimeTable extends GetView<AdminShellController> {
  const _RealtimeTable({this.maxRows = 6});

  final int maxRows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final rows = controller.team.take(maxRows).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Today's punches", style: theme.textTheme.titleMedium),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
                ],
              ),
              const SizedBox(height: 12),

              // Non-scrollable list — let the outer CustomScrollView handle scrolling.
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rows.length,
                separatorBuilder: (_, __) => const Divider(height: 8),
                itemBuilder: (context, index) {
                  final member = rows[index];

                  // Use safe fallbacks if strings are empty
                  final first = (member.firstPunch.isEmpty) ? '—' : member.firstPunch;
                  final last  = (member.lastPunch.isEmpty)  ? '—' : member.lastPunch;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 18,
                          child: Text(member.name.isNotEmpty ? member.name[0] : '?'),
                        ),
                        const SizedBox(width: 12),

                        // Name (top) + timings (bottom)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name line
                              Text(
                                member.name,
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),

                              // Timing line (small, muted)
                              Row(
                                children: [
                                  _TimingPill(icon: Icons.login,  label: first), // Check-in
                                  const SizedBox(width: 8),
                                  _TimingPill(icon: Icons.logout, label: last),  // Check-out
                                  const SizedBox(width: 8),
                                  _StatusDot(text: member.status.label),         // Status (colored dot + text)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (controller.team.length > maxRows) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    // TODO: navigate to full Attendance list
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('View all'),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}

class _TimingPill extends StatelessWidget {
  const _TimingPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: t.colorScheme.surfaceContainerHighest.withOpacity(.6),
        border: Border.all(color: t.dividerColor.withOpacity(.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 6),
          Text(label, style: t.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final lower = text.toLowerCase();
    final color = lower.contains('late') || lower.contains('half')
        ? t.colorScheme.error
        : t.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: t.textTheme.labelSmall?.copyWith(color: color)),
      ],
    );
  }
}
