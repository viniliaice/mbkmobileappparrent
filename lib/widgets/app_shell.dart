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
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: const [
        DashboardScreen(),
        MessagesScreen(),
        _LearningScreen(),
        _ResultsScreen(),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTap,
        animationDuration: const Duration(milliseconds: 300),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        height: 72,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.email_outlined),
            selectedIcon: Icon(Icons.email_rounded),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories_rounded),
            label: 'Learning',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Results',
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
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Learning', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text('Explore and practice',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          ),
          _FeatureCard(
            icon: Icons.auto_stories_rounded,
            title: 'Learning Hub',
            subtitle: 'Browse all subjects and lessons',
            color: const Color(0xFF6C5CE7),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LearningHubScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            icon: Icons.calculate_rounded,
            title: 'Topic Explorer',
            subtitle: 'Pick a math topic to practice',
            color: const Color(0xFFFF6B6B),
            onTap: () => _pickChildAndGo(
              (child) => TopicExplorerScreen(student: child, grade: _gradeForChild(child)),
            ),
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            icon: Icons.flash_on_rounded,
            title: 'Speed Challenge',
            subtitle: 'Race the clock with quick math',
            color: Colors.amber.shade700,
            onTap: () => _pickChildAndGo(
              (child) => SpeedChallengeScreen(student: child, grade: _gradeForChild(child)),
            ),
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            icon: Icons.functions_rounded,
            title: 'Math Hub',
            subtitle: 'Math overview and progress',
            color: const Color(0xFF2D9CDB),
            onTap: () => _pickChildAndGo(
              (child) => MathHubScreen(student: child),
            ),
          ),
        ],
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
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.03),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.03),
                blurRadius: 16, offset: const Offset(0, 4), spreadRadius: -4,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.2 : 0.12),
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
        ),
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
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Student Results', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<StudentProvider>(
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
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('No Children Linked',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Add a child to view their results',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text('Select a child to view their academic results',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ),
              ...sp.children.map((student) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => AcademicResultsScreen(student: student)),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.03),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.03),
                            blurRadius: 16, offset: const Offset(0, 4),
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withValues(alpha: 0.7)
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
                                        ?.copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.class_rounded, size: 14,
                                        color: theme.colorScheme.onSurfaceVariant),
                                    const SizedBox(width: 4),
                                    Text('Class ${student.className}',
                                        style: TextStyle(
                                            color: theme.colorScheme.onSurfaceVariant,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.chevron_right_rounded,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                              size: 22),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}