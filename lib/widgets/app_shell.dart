import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../screens/dashboard_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/academic_results_screen.dart';
import '../learning/screens/hub_screen.dart';
import '../math/screens/topic_explorer_screen.dart';
import '../math/screens/speed_challenge_screen.dart';
import '../math/screens/math_hub_screen.dart';
import '../theme/aurora_background.dart';
import '../widgets/aurora_card.dart';
import 'aurora_nav.dart';
import 'aurora_nav_rail.dart';
import 'responsive.dart';
import 'responsive_content.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onTap(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= desktopBreakpoint) {
          return _buildDesktop();
        }
        return _buildMobile();
      },
    );
  }

  Widget _buildDesktop() {
    return Scaffold(
      body: Row(
        children: [
          AuroraNavRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onTap,
            items: const [
              AuroraRailItem(icon: Icons.home_rounded, label: 'Home'),
              AuroraRailItem(icon: Icons.mail_outline_rounded, label: 'Messages'),
              AuroraRailItem(icon: Icons.auto_stories_rounded, label: 'Learning'),
              AuroraRailItem(icon: Icons.bar_chart_rounded, label: 'Results'),
            ],
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: IndexedStack(index: _currentIndex, children: const [
                  DashboardScreen(),
                  MessagesScreen(),
                  _LearningScreen(),
                  _ResultsScreen(),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile() {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(index: _currentIndex, children: const [
              DashboardScreen(),
              MessagesScreen(),
              _LearningScreen(),
              _ResultsScreen(),
            ]),
          ),
          SafeArea(
            top: false,
            child: AuroraNavBar(
              currentIndex: _currentIndex,
              onTap: _onTap,
              items: const [
                AuroraNavItem(icon: Icons.home_rounded, label: 'Home'),
                AuroraNavItem(icon: Icons.mail_outline_rounded, label: 'Messages'),
                AuroraNavItem(icon: Icons.auto_stories_rounded, label: 'Learning'),
                AuroraNavItem(icon: Icons.bar_chart_rounded, label: 'Results'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningScreen extends StatefulWidget {
  const _LearningScreen();
  @override
  State<_LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<_LearningScreen> {
  void _pickChildAndGo(Widget Function(Student child) screenBuilder) {
    final sp = context.read<StudentProvider>();
    if (sp.children.isEmpty) return;
    if (sp.children.length == 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => screenBuilder(sp.children.first),
      ));
      return;
    }
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _ChildPickerSheet(
        children: sp.children,
        onSelected: (child) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => screenBuilder(child),
          ));
        },
      ),
    );
  }

  int _gradeForChild(Student student) {
    final match = RegExp(r'(\d+)').firstMatch(student.className);
    if (match != null) {
      final g = int.tryParse(match.group(1)!) ?? 1;
      return g.clamp(1, 6);
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final desktop = isDesktop(context);
    final featureCards = <Widget>[
      _FeatureCard(
        icon: Icons.auto_stories_rounded,
        title: 'Learning Hub',
        subtitle: 'Browse all subjects and lessons',
        color: const Color(0xFF6C5CE7),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LearningHubScreen()),
        ),
      ),
      _FeatureCard(
        icon: Icons.calculate_rounded,
        title: 'Topic Explorer',
        subtitle: 'Pick a math topic to practice',
        color: const Color(0xFFFF6B6B),
        onTap: () => _pickChildAndGo(
          (child) => TopicExplorerScreen(student: child, grade: _gradeForChild(child)),
        ),
      ),
      _FeatureCard(
        icon: Icons.flash_on_rounded,
        title: 'Speed Challenge',
        subtitle: 'Race the clock with quick math',
        color: Colors.amber.shade700,
        onTap: () => _pickChildAndGo(
          (child) => SpeedChallengeScreen(student: child, grade: _gradeForChild(child)),
        ),
      ),
      _FeatureCard(
        icon: Icons.functions_rounded,
        title: 'Math Hub',
        subtitle: 'Math overview and progress',
        color: const Color(0xFF2D9CDB),
        onTap: () => _pickChildAndGo(
          (child) => MathHubScreen(student: child),
        ),
      ),
    ];

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: ResponsiveContent(
            child: ListView(
              padding: desktop
                  ? const EdgeInsets.fromLTRB(0, 12, 0, 40)
                  : const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('Explore and practice',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                ),
                if (desktop) ...[
                  // 2-column grid on desktop
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3.2,
                    children: featureCards,
                  ),
                ] else ...[
                  // Single-column list on mobile
                  ...featureCards.expand((w) => [w, const SizedBox(height: 12)]).toList()..removeLast(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AuroraCard(
      padding: const EdgeInsets.all(18),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
        ],
      ),
    );
  }
}

class _ChildPickerSheet extends StatelessWidget {
  final List<Student> children;
  final ValueChanged<Student> onSelected;
  const _ChildPickerSheet({required this.children, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 60, height: 5,
              decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(3)))),
          const SizedBox(height: 18),
          Text('Select a Child',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          ...children.map((child) => Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelected(child),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha: 0.7)
                        ]),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                          child: Text(child.name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.w800, fontSize: 20))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(child.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16)),
                            const SizedBox(height: 2),
                            Text('Class ${child.className}',
                                style: TextStyle(fontSize: 13,
                                    color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        )),
                    Icon(Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5)),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _ResultsScreen extends StatelessWidget {
  const _ResultsScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final desktop = isDesktop(context);
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: Consumer<StudentProvider>(
            builder: (context, sp, _) {
              if (sp.loadingChildren) {
                return const Center(child: CircularProgressIndicator());
              }
              if (sp.children.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.child_care_outlined, size: 64,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      Text('No Children Linked',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text('Add a child to view their results',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                );
              }
              return ResponsiveContent(
                child: ListView(
                  padding: desktop
                      ? const EdgeInsets.fromLTRB(0, 12, 0, 24)
                      : const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text('Select a child to view their academic results',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ),
                    if (desktop) ...[
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: sp.children.map((student) => SizedBox(
                          width: 440,
                          child: _buildStudentResultCard(
                              context, theme, colorScheme, student),
                        )).toList(),
                      ),
                    ] else ...[
                      ...sp.children.map((student) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildStudentResultCard(
                            context, theme, colorScheme, student),
                      )),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStudentResultCard(
      BuildContext context, ThemeData theme, ColorScheme colorScheme, dynamic student) {
    return AuroraCard(
      padding: const EdgeInsets.all(18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => AcademicResultsScreen(student: student)),
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.7)
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(student.name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w800, fontSize: 22)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.class_rounded, size: 14,
                        color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text('Class ${student.className}',
                        style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 22),
        ],
      ),
    );
  }
}