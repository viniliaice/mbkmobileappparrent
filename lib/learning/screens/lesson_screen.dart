import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../models/topic.dart';
import '../provider.dart';
import '../widgets/activity_renderer.dart';
import '../widgets/celebration.dart';

class LessonScreen extends StatefulWidget {
  final Student student;
  final LearningLesson lesson;
  final Color color;

  const LessonScreen({
    super.key,
    required this.student,
    required this.lesson,
    required this.color,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentStep = 0;
  int _correctCount = 0;
  bool _showCelebration = false;
  bool _lessonComplete = false;
  bool _needsContinue = false;

  bool get _isIntroStep => _currentStep == 0;
  bool get _isFinalStep => _currentStep == widget.lesson.activities.length + 1;
  int get _activityIndex => _currentStep - 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildProgressBar(theme, colorScheme),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.25),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: _buildCurrentStep(theme, colorScheme),
                  ),
                ),
              ),
            ],
          ),
          if (_showCelebration)
            CelebrationOverlay(
              title: 'Lesson Complete!',
              subtitle: widget.lesson.objective,
              xpGained: widget.lesson.xpReward,
              badgeName: widget.lesson.badgeName,
              onContinue: () {
                setState(() => _showCelebration = false);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme, ColorScheme colorScheme) {
    final totalSteps = widget.lesson.activities.length + 2;
    final progress = (_currentStep + 1) / totalSteps;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0).toDouble(),
                minHeight: 6,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(widget.color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text('${_currentStep + 1}/$totalSteps',
              style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(ThemeData theme, ColorScheme colorScheme) {
    Widget step;
    if (_isIntroStep) {
      step = _buildIntro(theme, colorScheme);
    } else if (_isFinalStep) {
      step = _buildFinalReview(theme, colorScheme);
    } else {
      step = _buildActivity(theme, colorScheme);
    }
    return KeyedSubtree(key: ValueKey('step_$_currentStep'), child: step);
  }

  Widget _buildIntro(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(Icons.menu_book_rounded,
              color: widget.color, size: 40),
        ),
        const SizedBox(height: 20),
        Text(widget.lesson.title,
            style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        )),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('+${widget.lesson.xpReward} XP on completion',
              style: TextStyle(
            color: widget.color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          )),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Learning Objective',
                  style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              )),
              const SizedBox(height: 8),
              Text(widget.lesson.objective,
                  style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              )),
              const SizedBox(height: 16),
              Text('What You\'ll Learn',
                  style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              )),
              const SizedBox(height: 8),
              Text(widget.lesson.explanation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              )),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => setState(() => _currentStep++),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: widget.color,
            ),
            child: const Text('Start Learning'),
          ),
        ),
      ],
    );
  }

  Widget _buildActivity(ThemeData theme, ColorScheme colorScheme) {
    final activity = widget.lesson.activities[_activityIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Activity ${_activityIndex + 1}',
                style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.color,
            )),
            const Spacer(),
            Text('$_correctCount correct',
                style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            )),
          ],
        ),
        const SizedBox(height: 16),
        ActivityRenderer(
          key: ValueKey(activity.id),
          activity: activity,
          onCorrect: () {
            setState(() {
              _correctCount++;
              _needsContinue = true;
            });
          },
          onIncorrect: () {
            setState(() {
              _needsContinue = true;
            });
          },
        ),
        if (_needsContinue) ...[
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                setState(() {
                  _needsContinue = false;
                  _currentStep++;
                });
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: widget.color,
              ),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continue'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFinalReview(ThemeData theme, ColorScheme colorScheme) {
    final total = widget.lesson.activities.length;
    final percent = total > 0 ? (_correctCount / total) * 100 : 0.0;
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _scoreColor(percent).withValues(alpha: 0.15),
            border: Border.all(
              color: _scoreColor(percent),
              width: 3,
            ),
          ),
          child: Center(
            child: Text('${percent.toInt()}%',
                style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _scoreColor(percent),
            )),
          ),
        ),
        const SizedBox(height: 16),
        Text('Review Complete',
            style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        )),
        const SizedBox(height: 8),
        Text('You got $_correctCount out of $total correct',
            style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        )),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _finishLesson,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: widget.color,
            ),
            child: const Text('Finish Lesson'),
          ),
        ),
      ],
    );
  }

  Future<void> _finishLesson() async {
    final lp = context.read<LearningProvider>();
    await lp.completeLesson(
      widget.student.id,
      widget.lesson.id,
      _correctCount,
      widget.lesson.activities.length,
    );
    if (!mounted) return;
    setState(() => _lessonComplete = true);
    if (lp.lastUnlockedAchievement != null) {
      lp.clearLastAchievement();
    }
    setState(() => _showCelebration = true);
  }

  Future<bool> _showExitDialog(BuildContext context) {
    if (_lessonComplete || _currentStep == 0) {
      Navigator.of(context).pop();
      return Future.value(false);
    }
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Leave Lesson?'),
        content: const Text('Your progress in this lesson will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
              Navigator.of(context).pop();
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    ).then((v) => v ?? false);
  }

  Color _scoreColor(double percent) {
    if (percent >= 80) return Colors.green;
    if (percent >= 50) return Colors.orange;
    return Colors.red;
  }
}
