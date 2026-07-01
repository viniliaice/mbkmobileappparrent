import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../provider.dart';
import '../data/content.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String? _selectedStudentId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Learning Progress')),
      body: Consumer2<StudentProvider, LearningProvider>(
        builder: (context, sp, lp, _) {
          if (!lp.loaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final children = sp.children;
          if (children.isEmpty) {
            return const Center(child: Text('No children linked'));
          }

              final studentId = _selectedStudentId ?? children.first.id;
              final xp = lp.getXp(studentId);
          final completed = lp.getCompletedLessonsCount(studentId);
          final accuracy = lp.getOverallAccuracy(studentId);
              final weekTopics = lp.getWeakStrongTopics(studentId);
          final totalLessons = LearningContent.mathematics.fold<int>(
              0, (sum, t) => sum + t.lessons.length) +
              LearningContent.english.fold<int>(
                  0, (sum, t) => sum + t.lessons.length);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (children.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DropdownButtonFormField<String>(
                    initialValue: studentId,
                    decoration: const InputDecoration(
                      labelText: 'Select Child',
                      border: OutlineInputBorder(),
                    ),
                    items: children.map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name),
                    )).toList(),
                    onChanged: (v) => setState(() => _selectedStudentId = v),
                  ),
                ),
              _buildStatCard(theme, colorScheme, 'Total XP', '$xp XP',
                  Icons.stars, Colors.amber),
              const SizedBox(height: 10),
              _buildStatCard(theme, colorScheme, 'Lessons Completed',
                  '$completed / $totalLessons', Icons.check_circle, Colors.green),
              const SizedBox(height: 10),
              _buildStatCard(theme, colorScheme, 'Overall Accuracy',
                  '${(accuracy * 100).toInt()}%', Icons.trending_up, Colors.blue),
              const SizedBox(height: 10),
              _buildStatCard(theme, colorScheme, 'Current Streak',
                  '${lp.currentStreak} day${lp.currentStreak == 1 ? '' : 's'}',
                  Icons.local_fire_department, Colors.orange),
              const SizedBox(height: 24),
              Text('Subject Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              )),
              const SizedBox(height: 12),
              _buildSubjectProgress(theme, colorScheme, lp, studentId, true),
              const SizedBox(height: 10),
              _buildSubjectProgress(theme, colorScheme, lp, studentId, false),
              if (weekTopics['strong']!.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Strong Topics',
                    style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: weekTopics['strong']!.map((t) => Chip(
                    avatar: const Icon(Icons.star, size: 16, color: Colors.green),
                    label: Text(t, style: const TextStyle(fontSize: 13)),
                    backgroundColor: Colors.green.withValues(alpha: 0.1),
                  )).toList(),
                ),
              ],
              if (weekTopics['weak']!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Needs Practice',
                    style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: weekTopics['weak']!.map((t) => Chip(
                    avatar: const Icon(Icons.trending_up, size: 16, color: Colors.orange),
                    label: Text(t, style: const TextStyle(fontSize: 13)),
                    backgroundColor: Colors.orange.withValues(alpha: 0.1),
                  )).toList(),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, ColorScheme colorScheme,
      String label, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  )),
                  const SizedBox(height: 2),
                  Text(value, style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectProgress(ThemeData theme, ColorScheme colorScheme,
      LearningProvider lp, String studentId, bool isMath) {
    final topics = LearningContent.topicsForSubject(isMath);
    final subjectName = isMath ? 'Mathematics' : 'English';
    final subjectColor = isMath ? Colors.blue : Colors.teal;

    int completed = 0;
    int total = 0;
    for (final topic in topics) {
      for (final lesson in topic.lessons) {
        total++;
        if (lp.isLessonCompleted(studentId, lesson.id)) completed++;
      }
    }
    final progress = total > 0 ? completed / total : 0.0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: subjectColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isMath ? Icons.calculate : Icons.menu_book,
                color: subjectColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subjectName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(subjectColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('$completed / $total lessons',
                      style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  )),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text('${(progress * 100).toInt()}%',
                style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: subjectColor,
            )),
          ],
        ),
      ),
    );
  }
}
