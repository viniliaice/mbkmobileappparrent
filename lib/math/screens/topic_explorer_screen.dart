import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../../theme/aurora_background.dart';
import '../models/math_question.dart';
import '../models/math_progress.dart';
import '../providers/math_provider.dart';
import '../widgets/lesson_mode.dart';
import '../../widgets/responsive_content.dart';
import 'lesson_screen.dart';
import 'speed_challenge_screen.dart';

class TopicExplorerScreen extends StatefulWidget {
  final Student student;
  final int grade;

  const TopicExplorerScreen({super.key, required this.student, required this.grade});

  @override
  State<TopicExplorerScreen> createState() => _TopicExplorerScreenState();
}

class _TopicExplorerScreenState extends State<TopicExplorerScreen> {
  static const _topicGradients = <List<Color>>[
    [Color(0xFF4CAF50), Color(0xFF66BB6A)],
    [Color(0xFF2196F3), Color(0xFF42A5F5)],
    [Color(0xFFFF9800), Color(0xFFFFB74D)],
    [Color(0xFF9C27B0), Color(0xFFBA68C8)],
    [Color(0xFFE91E63), Color(0xFFF06292)],
    [Color(0xFF00BCD4), Color(0xFF26C6DA)],
    [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
    [Color(0xFF795548), Color(0xFFA1887F)],
    [Color(0xFF607D8B), Color(0xFF90A4AE)],
    [Color(0xFFCDDC39), Color(0xFFDCE775)],
    [Color(0xFFFFEB3B), Color(0xFFFFF176)],
    [Color(0xFF009688), Color(0xFF26A69A)],
    [Color(0xFFF44336), Color(0xFFEF5350)],
    [Color(0xFF673AB7), Color(0xFF9575CD)],
    [Color(0xFF388E3C), Color(0xFF66BB6A)],
  ];

  static const _topicIcons = <IconData>[
    Icons.calculate_rounded,
    Icons.fingerprint_rounded,
    Icons.add_rounded,
    Icons.remove_rounded,
    Icons.close_rounded,
    Icons.dashboard_customize_rounded,
    Icons.percent_rounded,
    Icons.more_horiz_rounded,
    Icons.access_time_rounded,
    Icons.attach_money_rounded,
    Icons.straighten_rounded,
    Icons.category_rounded,
    Icons.auto_awesome_rounded,
    Icons.menu_book_rounded,
    Icons.architecture_rounded,
  ];

  void _openSpeedChallenge() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SpeedChallengeScreen(student: widget.student, grade: widget.grade),
    ));
  }

  void _openLesson(MathTopic topic, Difficulty difficulty, LessonMode mode) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LessonScreen(
        student: widget.student,
        topic: topic,
        difficulty: difficulty,
        mode: mode,
        grade: widget.grade,
      ),
    ));
  }

  void _showTopicDetailSheet(MathTopic topic, int idx) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (sheetContext) => _TopicDetailSheet(
        topic: topic,
        topicTitle: topicTitles[topic] ?? '',
        topicDescription: topicDescriptions[topic] ?? '',
        gradient: _topicGradients[idx % _topicGradients.length],
        icon: _topicIcons[idx % _topicIcons.length],
        onStart: (difficulty, mode) {
          Navigator.of(sheetContext).pop();
          _openLesson(topic, difficulty, mode);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final mp = context.watch<MathProvider>();
    final topics = MathTopic.values;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Grade ${widget.grade} • ${widget.student.name}',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on_rounded),
            tooltip: 'Quick Speed Challenge',
            onPressed: _openSpeedChallenge,
            style: IconButton.styleFrom(foregroundColor: Colors.amber.shade700),
          ),
        ],
      ),
      body: AuroraBackground(
        child: SafeArea(
          child: ResponsiveContent(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _buildHero(theme, colorScheme, isDark, mp),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Pick a Topic',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.92,
              ),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                return _TopicCard(
                  topic: topic,
                  title: topicTitles[topic] ?? topic.name,
                  description: topicDescriptions[topic] ?? '',
                  icon: _topicIcons[index % _topicIcons.length],
                  gradient: _topicGradients[index % _topicGradients.length],
                  progress: mp.topicProgress(widget.student.id, topic),
                  onTap: () => _showTopicDetailSheet(topic, index),
                );
              },
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }

  Widget _buildHero(ThemeData theme, ColorScheme colorScheme, bool isDark, MathProvider mp) {
    final progress = mp.currentProgress;
    final xp = progress?.totalXp ?? 0;
    final streak = progress?.dailyStreak ?? 0;
    final minutes = progress?.weeklyActiveMinutes ?? 0;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF8E7EF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
        ],
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
                child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose what to practice',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '15 topics • 3 difficulties • 3 modes',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _statBlock('XP', xp.toString(), Icons.star_rounded, Colors.amber),
              const SizedBox(width: 12),
              _statBlock('Streak', '$streak', Icons.local_fire_department_rounded, Colors.lightGreenAccent),
              const SizedBox(width: 12),
              _statBlock('Min', '$minutes', Icons.schedule_rounded, Colors.cyanAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBlock(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 18,
            )),
            Text(label, style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            )),
          ],
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final MathTopic topic;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final TopicProgress? progress;
  final VoidCallback onTap;

  const _TopicCard({
    required this.topic,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final stars = progress?.starsEarned ?? 0;
    final accuracy = progress?.accuracy ?? 0;
    final accuracyPercent = (accuracy * 100).toInt();
    final hasData = progress != null && progress!.totalAttempts > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  if (hasData)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (i) {
                          return Icon(
                            Icons.star_rounded,
                            color: i < stars ? Colors.white : Colors.white.withValues(alpha: 0.35),
                            size: 11,
                          );
                        }),
                      ),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: accuracy.clamp(0.0, 1.0).toDouble(),
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasData ? '$accuracyPercent% accuracy' : 'Not started',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicDetailSheet extends StatefulWidget {
  final MathTopic topic;
  final String topicTitle;
  final String topicDescription;
  final List<Color> gradient;
  final IconData icon;
  final void Function(Difficulty difficulty, LessonMode mode) onStart;

  const _TopicDetailSheet({
    required this.topic,
    required this.topicTitle,
    required this.topicDescription,
    required this.gradient,
    required this.icon,
    required this.onStart,
  });

  @override
  State<_TopicDetailSheet> createState() => _TopicDetailSheetState();
}

class _TopicDetailSheetState extends State<_TopicDetailSheet> {
  Difficulty _selectedDifficulty = Difficulty.easy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.topicTitle,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20)),
                          const SizedBox(height: 2),
                          Text(widget.topicDescription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text('Pick a Difficulty',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  )),
              const SizedBox(height: 12),
              Row(
                children: [
                  _difficultyButton(Difficulty.easy, 'Easy', '🟢', isDark),
                  const SizedBox(width: 10),
                  _difficultyButton(Difficulty.medium, 'Medium', '🟡', isDark),
                  const SizedBox(width: 10),
                  _difficultyButton(Difficulty.hard, 'Hard', '🔴', isDark),
                ],
              ),
              const SizedBox(height: 22),
              Text('Pick a Mode',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  )),
              const SizedBox(height: 12),
              _modeButton(
                LessonMode.practice,
                Icons.loop_rounded,
                'Practice',
                'Unlimited, learn at your pace',
                Colors.green,
                isDark,
              ),
              const SizedBox(height: 10),
              _modeButton(
                LessonMode.challenge,
                Icons.bolt_rounded,
                'Challenge',
                '10 questions, earn XP',
                Colors.orange,
                isDark,
              ),
              const SizedBox(height: 10),
              _modeButton(
                LessonMode.mastery,
                Icons.workspace_premium_rounded,
                'Mastery',
                '12 questions, 3 lives, earn stars',
                Colors.purple,
                isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _difficultyButton(Difficulty d, String label, String emoji, bool isDark) {
    final isSelected = _selectedDifficulty == d;
    const accent = Color(0xFF6C5CE7);
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _selectedDifficulty = d),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? accent.withValues(alpha: isDark ? 0.25 : 0.12)
                  : isDark ? const Color(0xFF2A2A2E) : const Color(0xFFF8F8FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? accent.withValues(alpha: 0.6)
                    : isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 4),
                Text(label, style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? accent
                      : isDark ? Colors.white : Colors.black87,
                )),
                if (isSelected) ...[
                  const SizedBox(height: 2),
                  Icon(Icons.check_rounded, color: accent, size: 14),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _modeButton(LessonMode mode, IconData icon, String title, String subtitle, Color color, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => widget.onStart(_selectedDifficulty, mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.18 : 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.3 : 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
            ],
          ),
        ),
      ),
    );
  }
}