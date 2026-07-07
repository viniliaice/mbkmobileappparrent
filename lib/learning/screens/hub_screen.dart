import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/aurora_background.dart';
import '../../widgets/aurora_card.dart';
import '../../widgets/student_card.dart';
import '../../widgets/responsive_content.dart';
import '../../widgets/responsive.dart';
import 'subject_screen.dart';
import 'achievements_screen.dart';
import 'progress_screen.dart';

class LearningHubScreen extends StatefulWidget {
  const LearningHubScreen({super.key});

  @override
  State<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends State<LearningHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = context.read<StudentProvider>();
      if (sp.children.isEmpty) {
        final auth = context.read<AuthProvider>();
        if (auth.user != null) {
          sp.loadChildren(auth.user!.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final desktop = isDesktop(context);

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded,
                          color: colorScheme.primary),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 4),
                    Text('Interactive Learning',
                        style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.emoji_events_outlined,
                                color: colorScheme.primary),
                            tooltip: 'Achievements',
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const AchievementsScreen()),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.bar_chart_outlined,
                                color: colorScheme.primary),
                            tooltip: 'Progress Report',
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const ProgressScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Consumer<StudentProvider>(
                  builder: (context, sp, _) {
                    if (sp.loadingChildren) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    if (sp.children.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.child_care_outlined,
                                size: 64,
                                color: colorScheme.onSurfaceVariant),
                            const SizedBox(height: 16),
                            Text('No children linked to your account'),
                          ],
                        ),
                      );
                    }
                    return ResponsiveContent(
child: ListView(
                        padding: desktop
                            ? const EdgeInsets.fromLTRB(0, 8, 0, 24)
                            : const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        children: [
                          AuroraCard(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(Icons.auto_awesome,
                                      color: colorScheme.primary, size: 28),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Interactive Learning',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Text('Learn by doing!',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text('Choose a Child',
                              style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                          const SizedBox(height: 14),
                          ...sp.children.map((student) => StudentCard(
                                student: student,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => SubjectSelectionScreen(
                                        student: student),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
