import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../models/math_question.dart';
import '../models/math_progress.dart';
import '../providers/math_provider.dart';
import 'speed_challenge_screen.dart';

class MathHubScreen extends StatefulWidget {
  final Student student;

  const MathHubScreen({super.key, required this.student});

  @override
  State<MathHubScreen> createState() => _MathHubScreenState();
}

class _MathHubScreenState extends State<MathHubScreen> {
  int? _selectedGrade;

  static const _gradeColors = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
    Color(0xFF00BCD4),
  ];

  static const _gradeIcons = [
    Icons.looks_one,
    Icons.looks_two,
    Icons.looks_3,
    Icons.looks_4,
    Icons.looks_5,
    Icons.looks_6,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MathProvider>().selectStudent(widget.student.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final mp = context.watch<MathProvider>();
    final StudentMathProgress? progress = mp.currentProgress;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Interactive Math'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, progress),
            const SizedBox(height: 20),
            Text('Select Grade', style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 12),
            ...List.generate(6, (i) => _buildGradeCard(i + 1, theme, colorScheme, progress)),
            const SizedBox(height: 24),
            if (progress != null) _buildProgressOverview(theme, colorScheme, mp, progress),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, StudentMathProgress? progress) {
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hello, ${widget.student.name}!',
              style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 4),
          Text('Ready for a math challenge?',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
          if (progress != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                _headerStat('${progress.totalXp}', 'Total XP', Colors.amber, theme),
                const SizedBox(width: 16),
                _headerStat('${progress.dailyStreak}', 'Day Streak', Colors.lightGreen, theme),
                const SizedBox(width: 16),
                _headerStat('${progress.weeklyActiveMinutes}', 'Min Active', Colors.cyan, theme),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _headerStat(String value, String label, Color color, ThemeData theme) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          )),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildGradeCard(int grade, ThemeData theme, ColorScheme colorScheme, StudentMathProgress? progress) {
    final color = _gradeColors[grade - 1];
    final isSelected = _selectedGrade == grade;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isSelected ? color.withValues(alpha: 0.1) : colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        elevation: isSelected ? 4 : 1,
        child: InkWell(
          onTap: () => _startSpeedChallenge(grade),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(_gradeIcons[grade - 1], color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grade $grade',
                          style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
                      Text(_gradeTopics(grade),
                          style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer, size: 14, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text('60s', style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startSpeedChallenge(int grade) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SpeedChallengeScreen(
          student: widget.student,
          grade: grade,
        ),
      ),
    );
  }

  Widget _buildProgressOverview(ThemeData theme, ColorScheme colorScheme, MathProvider mp, StudentMathProgress progress) {
    final completedCount = progress.topicProgress.values.where((t) => t.totalAttempts > 0).length;
    final totalTopics = MathTopic.values.length;
    final accuracy = mp.averageAccuracy(widget.student.id);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress Overview',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _progressRow('Topics Started', '$completedCount / $totalTopics', completedCount / totalTopics, colorScheme),
          const SizedBox(height: 8),
          _progressRow('Average Accuracy', '${(accuracy * 100).toInt()}%', accuracy, colorScheme),
        ],
      ),
    );
  }

  Widget _progressRow(String label, String value, double fraction, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        SizedBox(
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(value, textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      ],
    );
  }

  String _gradeTopics(int grade) {
    switch (grade) {
      case 1: return 'Counting, Addition, Subtraction, Shapes';
      case 2: return 'Addition, Subtraction, Multiplication, Time';
      case 3: return '× ÷, Fractions, Area, Place Value';
      case 4: return '× ÷, Fractions, Decimals, Geometry';
      case 5: return 'Fractions, Decimals, Word Problems';
      case 6: return 'Fractions, Decimals, Ratios, Geometry';
      default: return 'Math Practice';
    }
  }
}
