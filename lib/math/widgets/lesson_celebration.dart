import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'lesson_mode.dart';

class LessonCelebration extends StatefulWidget {
  final int stars;
  final int accuracy;
  final int xpEarned;
  final int correctAnswers;
  final int totalQuestions;
  final int durationSeconds;
  final LessonMode mode;
  final VoidCallback onRetry;
  final VoidCallback onContinue;

  const LessonCelebration({
    super.key,
    required this.stars,
    required this.accuracy,
    required this.xpEarned,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.durationSeconds,
    required this.mode,
    required this.onRetry,
    required this.onContinue,
  });

  @override
  State<LessonCelebration> createState() => _LessonCelebrationState();
}

class _LessonCelebrationState extends State<LessonCelebration>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _starController;
  late ConfettiController _confettiController;
  late Animation<double> _star1;
  late Animation<double> _star2;
  late Animation<double> _star3;
  late Animation<double> _scoreScale;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _star1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _starController, curve: const Interval(0.0, 0.3, curve: Curves.elasticOut)),
    );
    _star2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _starController, curve: const Interval(0.2, 0.5, curve: Curves.elasticOut)),
    );
    _star3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _starController, curve: const Interval(0.4, 0.7, curve: Curves.elasticOut)),
    );
    _scoreScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.elasticOut),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _starController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _starController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String _modeLabel() {
    switch (widget.mode) {
      case LessonMode.practice: return 'Practice';
      case LessonMode.challenge: return 'Challenge';
      case LessonMode.mastery: return 'Mastery';
    }
  }

  String _performanceLabel() {
    if (widget.accuracy >= 95) return 'Outstanding!';
    if (widget.accuracy >= 80) return 'Excellent!';
    if (widget.accuracy >= 65) return 'Great Try!';
    if (widget.accuracy >= 50) return 'Good Effort!';
    return 'Keep Practicing!';
  }

  Color _performanceColor(bool isDark) {
    if (widget.accuracy >= 80) return Colors.green;
    if (widget.accuracy >= 65) return Colors.blue;
    if (widget.accuracy >= 50) return Colors.orange;
    return Colors.red;
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    if (mins == 0) return '${secs}s';
    return '${mins}m ${secs}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final performanceColor = _performanceColor(isDark);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF0F0F23), const Color(0xFF1A1A3E)]
                  : [const Color(0xFFF8FAFF), const Color(0xFFE8F0FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _scoreScale,
                    child: Container(
                      width: 160, height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [performanceColor, performanceColor.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: performanceColor.withValues(alpha: 0.4),
                            blurRadius: 40,
                            offset: const Offset(0, 16),
                            spreadRadius: -8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${widget.accuracy}%',
                                style: theme.textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 48,
                            )),
                            Text('Accuracy',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(_performanceLabel(),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      )),
                  const SizedBox(height: 4),
                  Text('${_modeLabel()} Complete',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(height: 24),
                  _buildStars(),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _statRow(Icons.check_circle_rounded, '${widget.correctAnswers}/${widget.totalQuestions}', 'Correct Answers', Colors.green),
                        const Divider(height: 24),
                        _statRow(Icons.star_rounded, '+${widget.xpEarned}', 'XP Earned', Colors.amber),
                        const Divider(height: 24),
                        _statRow(Icons.access_time_rounded, _formatDuration(widget.durationSeconds), 'Time Taken', Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.onRetry,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Try Again'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
                            foregroundColor: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: widget.onContinue,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('Continue'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: math.pi / 2,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 40,
            maxBlastForce: 30,
            minBlastForce: 15,
            colors: const [Colors.amber, Colors.pink, Colors.cyan, Colors.green, Colors.purple, Colors.orange],
          ),
        ),
      ],
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final filled = i < widget.stars;
        return AnimatedBuilder(
          animation: i == 0 ? _star1 : (i == 1 ? _star2 : _star3),
          builder: (context, child) {
            final scale = (i == 0 ? _star1 : (i == 1 ? _star2 : _star3)).value;
            return Transform.scale(
              scale: scale.clamp(0.0, 1.5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, rotation, child) {
                    return Transform.rotate(
                      angle: rotation * math.pi * 2 * (filled ? 1 : 0),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: filled
                              ? LinearGradient(colors: [Colors.amber, Colors.orange])
                              : null,
                          color: filled ? null : Colors.grey.withValues(alpha: 0.2),
                          boxShadow: filled
                              ? [
                                  BoxShadow(
                                    color: Colors.amber.withValues(alpha: 0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          Icons.star_rounded,
                          color: filled ? Colors.white : Colors.grey.withValues(alpha: 0.6),
                          size: 36,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _statRow(IconData icon, String value, String label, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              const SizedBox(height: 2),
              Text(value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}