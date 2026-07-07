import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/student.dart';
import '../models/topic.dart';
import '../data/content.dart';
import '../provider.dart';
import '../../widgets/responsive_content.dart';
import 'lesson_screen.dart';

class TopicListScreen extends StatefulWidget {
  final Student student;
  final bool isMath;

  const TopicListScreen({
    super.key,
    required this.student,
    required this.isMath,
  });

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningProvider>().loadProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjects = LearningContent.topicsForSubject(widget.isMath);
    final subjectName = widget.isMath ? 'Mathematics' : 'English';
    final subjectColor = widget.isMath ? Colors.blue : Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
      ),
      body: Consumer<LearningProvider>(
        builder: (context, lp, _) {
          if (!lp.loaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return ResponsiveContent(
            child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final topic = subjects[index];
              final progress = lp.getTopicProgress(widget.student.id, topic.lessons);
              return _TopicCard(
                topic: topic,
                progress: progress,
                color: subjectColor,
                student: widget.student,
              ).animate().fadeIn(
                duration: 300.ms,
                delay: (50 * index).ms,
                curve: Curves.easeOut,
              );
            },
            ),
          );
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final LearningTopic topic;
  final double progress;
  final Color color;
  final Student student;

  const _TopicCard({
    required this.topic,
    required this.progress,
    required this.color,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LessonListScreen(
              student: student,
              topic: topic,
              color: color,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(topic.icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
                    const SizedBox(height: 2),
                    Text(topic.description,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    )),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('${(progress * 100).toInt()}%',
                  style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              )),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonListScreen extends StatelessWidget {
  final Student student;
  final LearningTopic topic;
  final Color color;

  const LessonListScreen({
    super.key,
    required this.student,
    required this.topic,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      body: Consumer<LearningProvider>(
        builder: (context, lp, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topic.lessons.length,
            itemBuilder: (context, index) {
              final lesson = topic.lessons[index];
              final completed = lp.isLessonCompleted(student.id, lesson.id);
              final unlocked = lp.isLessonUnlocked(
                  student.id, lesson.id, topic.lessons);
              return _LessonCard(
                lesson: lesson,
                completed: completed,
                unlocked: unlocked,
                color: color,
                student: student,
              ).animate().fadeIn(
                duration: 300.ms,
                delay: (50 * index).ms,
              );
            },
          );
        },
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LearningLesson lesson;
  final bool completed;
  final bool unlocked;
  final Color color;
  final Student student;

  const _LessonCard({
    required this.lesson,
    required this.completed,
    required this.unlocked,
    required this.color,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: unlocked
            ? () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LessonScreen(
                      student: student,
                      lesson: lesson,
                      color: color,
                    ),
                  ),
                )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: completed
                      ? Colors.green.withValues(alpha: 0.15)
                      : unlocked
                          ? color.withValues(alpha: 0.12)
                          : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  completed
                      ? Icons.check_circle
                      : unlocked
                          ? Icons.play_arrow_rounded
                          : Icons.lock_outline,
                  color: completed
                      ? Colors.green
                      : unlocked
                          ? color
                          : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: unlocked ? null : Colors.grey,
                    )),
                    Text(lesson.objective,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                      color: unlocked
                          ? colorScheme.onSurfaceVariant
                          : Colors.grey,
                    )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('+${lesson.xpReward} XP',
                    style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
