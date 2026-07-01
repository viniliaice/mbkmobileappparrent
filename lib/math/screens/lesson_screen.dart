import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../models/math_question.dart';
import '../data/question_generator.dart';
import '../providers/math_provider.dart';
import '../widgets/activity_widget.dart';
import '../widgets/lesson_celebration.dart';
import '../widgets/lesson_mode.dart';

class LessonScreen extends StatefulWidget {
  final Student student;
  final MathTopic topic;
  final Difficulty difficulty;
  final LessonMode mode;
  final int grade;

  const LessonScreen({
    super.key,
    required this.student,
    required this.topic,
    required this.difficulty,
    required this.mode,
    required this.grade,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with TickerProviderStateMixin {
  late List<MathQuestion> _questions;
  int _currentIndex = 0;
  int _correctCount = 0;
  final Stopwatch _stopwatch = Stopwatch();
  bool _isFinished = false;
  bool _isProcessing = false;
  int _lives = 3;
  int _xpEarned = 0;
  int _starsEarned = 0;
  late AnimationController _progressController;

  static const Map<LessonMode, int> _questionsPerMode = {
    LessonMode.practice: 8,
    LessonMode.challenge: 10,
    LessonMode.mastery: 12,
  };

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadQuestions();
    _stopwatch.start();
  }

  void _loadQuestions() {
    final count = _questionsPerMode[widget.mode]!;
    _questions = QuestionGenerator.generate(
      grade: widget.grade,
      topic: widget.topic,
      difficulty: widget.difficulty,
      count: count + 5, // extras for retries
    ).take(count).toList();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _progressController.dispose();
    super.dispose();
  }

  void _onAnswer(bool isCorrect) {
    if (_isProcessing || _isFinished) return;
    setState(() {
      _isProcessing = true;
      if (isCorrect) {
        _correctCount++;
        _calculateXp();
      } else if (widget.mode == LessonMode.mastery) {
        _lives--;
      }
      // ===================================================
      // Generate a new question if we have less than needed
      // This prevents index out of range.
      // ===================================================
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  void _calculateXp() {
    switch (widget.mode) {
      case LessonMode.practice:
        _xpEarned += 5;
        break;
      case LessonMode.challenge:
        _xpEarned += 15 + (widget.difficulty == Difficulty.hard ? 5 : 0);
        break;
      case LessonMode.mastery:
        _xpEarned += 25 + (widget.difficulty == Difficulty.hard ? 10 : widget.difficulty == Difficulty.medium ? 5 : 0);
        break;
    }
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _isProcessing = false;
    });

    if (_currentIndex >= _questions.length) {
      _finishLesson();
    } else {
      _progressController.forward(from: 0);
    }
  }

  void _finishLesson() {
    _stopwatch.stop();
    _isFinished = true;
    _calculateStars();
    final mp = context.read<MathProvider>();
    mp.recordLessonComplete(
      studentId: widget.student.id,
      topic: widget.topic,
      score: _correctCount,
      totalQuestions: _questions.length,
      timeSpentSeconds: _stopwatch.elapsed.inSeconds,
    );
  }

  void _calculateStars() {
    final acc = _correctCount / _questions.length;
    if (widget.mode == LessonMode.mastery) {
      _starsEarned = acc >= 0.95 ? 3 : acc >= 0.75 ? 2 : 1;
    } else if (widget.mode == LessonMode.challenge) {
      _starsEarned = acc >= 0.8 ? 3 : acc >= 0.6 ? 2 : 1;
    } else {
      _starsEarned = acc >= 0.9 ? 3 : acc >= 0.7 ? 2 : 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F23) : const Color(0xFFF8FAFF),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_modeTitle(),
            style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isFinished
          ? _buildResults(theme, colorScheme, isDark)
          : _buildLesson(theme, colorScheme, isDark),
    );
  }

  String _modeTitle() {
    switch (widget.mode) {
      case LessonMode.practice: return 'Practice Mode';
      case LessonMode.challenge: return 'Challenge Mode';
      case LessonMode.mastery: return 'Mastery Quiz';
    }
  }

  Widget _buildLesson(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return SafeArea(
      child: Column(
        children: [
          _buildProgressBar(theme, colorScheme),
          const SizedBox(height: 8),
          _buildStats(theme, colorScheme),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: _currentIndex < _questions.length
                  ? QuestionActivityView(
                      key: ValueKey(_currentIndex),
                      question: _questions[_currentIndex],
                      onAnswer: _onAnswer,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme, ColorScheme colorScheme) {
    final progress = (_currentIndex + 1) / _questions.length;
    final clamped = progress.clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: FractionallySizedBox(
            widthFactor: clamped,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _statBubble(Icons.check_circle_rounded, Colors.green, '$_correctCount', 'Correct', theme),
          const SizedBox(width: 8),
          _statBubble(Icons.star_rounded, Colors.amber, '$_xpEarned', 'XP', theme),
          const SizedBox(width: 8),
          if (widget.mode == LessonMode.mastery) ...[
            _statBubble(Icons.favorite_rounded, Colors.red, '$_lives', 'Lives', theme),
            const SizedBox(width: 8),
          ],
          const Spacer(),
          Flexible(
            child: Text(
              'Q ${_currentIndex + 1}/${_questions.length}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBubble(IconData icon, Color color, String value, String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              )),
        ],
      ),
    );
  }

  Widget _buildResults(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    final acc = (_correctCount / _questions.length * 100).toInt();
    return Stack(
      children: [
        LessonCelebration(
          stars: _starsEarned,
          accuracy: acc,
          xpEarned: _xpEarned,
          correctAnswers: _correctCount,
          totalQuestions: _questions.length,
          durationSeconds: _stopwatch.elapsed.inSeconds,
          mode: widget.mode,
          onRetry: () {
            setState(() {
              _currentIndex = 0;
              _correctCount = 0;
              _xpEarned = 0;
              _starsEarned = 0;
              _lives = 3;
              _isFinished = false;
              _loadQuestions();
              _stopwatch.reset();
              _stopwatch.start();
            });
          },
          onContinue: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}