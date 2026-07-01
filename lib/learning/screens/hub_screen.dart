import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/student_card.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Learning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            tooltip: 'Achievements',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AchievementsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: 'Progress Report',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProgressScreen()),
            ),
          ),
        ],
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
                  Icon(Icons.child_care_outlined,
                      size: 64, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text('No children linked to your account'),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.auto_awesome,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Interactive Learning',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                              Text('Learn by doing!',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              )),
                            ],
                          ),
                        ),
                      ],
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
                        builder: (_) =>
                            SubjectSelectionScreen(student: student),
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
