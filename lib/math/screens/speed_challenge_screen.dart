import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../models/student.dart';
import '../models/math_question.dart';
import '../data/question_generator.dart';
import '../providers/math_provider.dart';

class SpeedChallengeScreen extends StatefulWidget {
  final Student student;
  final int grade;

  const SpeedChallengeScreen({
    super.key,
    required this.student,
    required this.grade,
  });

  @override
  State<SpeedChallengeScreen> createState() => _SpeedChallengeScreenState();
}

class _SpeedChallengeScreenState extends State<SpeedChallengeScreen>
    with TickerProviderStateMixin {
  late List<MathQuestion> _questions;
  int _questionIndex = 0;
  int _correctCount = 0;
  int _incorrectCount = 0;
  int _score = 0;
  int _timeLeft = 60;
  int _combo = 0;
  int _bestCombo = 0;
  bool _isRunning = false;
  bool _isFinished = false;
  bool _showFeedback = false;
  bool _lastCorrect = false;
  int _personalBest = 0;
  Timer? _timer;
  Timer? _feedbackTimer;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _timerPulseController;
  late AnimationController _confettiController;
  late AnimationController _entryController;
  MathQuestion? _currentQuestion;
  ConfettiController? _centerConfetti;
  ConfettiController? _leftConfetti;
  ConfettiController? _rightConfetti;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..value = 1.0;
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _timerPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _centerConfetti = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _leftConfetti = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _rightConfetti = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    _entryController.forward();
    _startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _feedbackTimer?.cancel();
    _pulseController.dispose();
    _shakeController.dispose();
    _timerPulseController.dispose();
    _confettiController.dispose();
    _entryController.dispose();
    _centerConfetti?.dispose();
    _leftConfetti?.dispose();
    _rightConfetti?.dispose();
    super.dispose();
  }

  void _startGame() {
    _questions = QuestionGenerator.generateSpeedChallenge(widget.grade, 50);
    debugPrint('SPEED: generated ${_questions.length} questions for grade ${widget.grade}');
    for (final q in _questions.take(3)) {
      debugPrint('SPEED:   question="${q.question}" answer="${q.correctAnswer}" options=${q.options}');
    }
    _questions.shuffle(math.Random(DateTime.now().millisecondsSinceEpoch));
    _questionIndex = 0;
    _correctCount = 0;
    _incorrectCount = 0;
    _score = 0;
    _timeLeft = 60;
    _combo = 0;
    _bestCombo = 0;
    _isRunning = true;
    _isFinished = false;
    _showFeedback = false;
    _currentQuestion = _questions.isNotEmpty ? _questions[0] : null;
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer timer) {
    if (!mounted) return;
    setState(() {
      _timeLeft--;
      if (_timeLeft <= 10 && _timeLeft > 0) {
        _timerPulseController.forward(from: 0);
      }
      if (_timeLeft <= 0) _endGame();
    });
  }

  void _endGame() {
    _timer?.cancel();
    _feedbackTimer?.cancel();
    _timerPulseController.stop();
    _isRunning = false;
    _isFinished = true;
    _personalBest = _score > _personalBest ? _score : _personalBest;
    final answered = _correctCount + _incorrectCount;
    final mp = context.read<MathProvider>();
    mp.recordSpeedChallenge(
      studentId: widget.student.id,
      grade: widget.grade,
      durationSeconds: 60,
      questionsAnswered: answered,
      correctAnswers: _correctCount,
      finalScore: _score,
      personalBest: _personalBest,
    );

    if (answered > 0) {
      final acc = _correctCount / answered;
      if (acc >= 0.8) {
        _centerConfetti?.play();
        _leftConfetti?.play();
        _rightConfetti?.play();
        _confettiController.forward();
      }
    }
  }

  void _answer(String selected) {
    if (!_isRunning || _showFeedback || _currentQuestion == null) return;
    debugPrint('ANSWER: selected="$selected" correct="${_currentQuestion!.correctAnswer}"');

    final correct = selected == _currentQuestion!.correctAnswer;

    // Haptic feedback
    if (correct) {
      HapticFeedback.lightImpact();
      _combo++;
      if (_combo > _bestCombo) _bestCombo = _combo;
    } else {
      HapticFeedback.mediumImpact();
      _combo = 0;
    }

    setState(() {
      _showFeedback = true;
      _lastCorrect = correct;
      if (correct) {
        _correctCount++;
        _score += 10 + (_timeLeft ~/ 5) + (_combo ~/ 3) * 5;
        _pulseController.forward(from: 0);
        _centerConfetti?.play();
      } else {
        _incorrectCount++;
        _shakeController.forward(from: 0);
      }
    });

    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _showFeedback = false;
        _questionIndex++;
        if (_questionIndex >= _questions.length) {
          _questions = QuestionGenerator.generateSpeedChallenge(widget.grade, 50);
          _questions.shuffle(math.Random(DateTime.now().millisecondsSinceEpoch));
          _questionIndex = 0;
        }
        _currentQuestion = _questions[_questionIndex];
      });
    });
  }

  String _gradeRating() {
    if (_correctCount + _incorrectCount == 0) return '-';
    final acc = _correctCount / (_correctCount + _incorrectCount);
    if (acc >= 0.95) return 'A+';
    if (acc >= 0.85) return 'A';
    if (acc >= 0.75) return 'B';
    if (acc >= 0.65) return 'C';
    if (acc >= 0.50) return 'D';
    return 'F';
  }

  String _ratingLabel(String rating) {
    switch (rating) {
      case 'A+': return 'Superstar!';
      case 'A': return 'Excellent!';
      case 'B': return 'Great Job!';
      case 'C': return 'Good Try!';
      case 'D': return 'Keep Practicing!';
      default: return 'Don\'t Give Up!';
    }
  }

  Color _ratingColor(String rating) {
    switch (rating) {
      case 'A+': case 'A': return Colors.green;
      case 'B': return Colors.blue;
      case 'C': return Colors.orange;
      case 'D': return Colors.deepOrange;
      default: return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BUILD: qIndex=$_questionIndex qCount=${_questions.length} currentQ=${_currentQuestion?.question} pulseValue=${_pulseController.value}');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F23) : const Color(0xFFF8FAFF),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Grade ${widget.grade} Speed Challenge',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildBackground(isDark, colorScheme),
          if (_isFinished) _buildResults(theme, colorScheme, isDark)
          else _buildGame(theme, colorScheme, isDark),
          // Confetti overlays
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _centerConfetti!,
              blastDirection: math.pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              maxBlastForce: 20,
              minBlastForce: 10,
              colors: const [
                Colors.amber,
                Colors.pink,
                Colors.cyan,
                Colors.green,
                Colors.purple,
                Colors.orange,
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: _leftConfetti!,
              blastDirection: math.pi / 4,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              colors: const [Colors.amber, Colors.pink, Colors.cyan, Colors.green],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _rightConfetti!,
              blastDirection: 3 * math.pi / 4,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              colors: const [Colors.amber, Colors.pink, Colors.cyan, Colors.green],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(bool isDark, ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0F0F23),
                  const Color(0xFF1A1A3E),
                  const Color(0xFF0D0D1A),
                ]
              : [
                  const Color(0xFFF8FAFF),
                  const Color(0xFFE8F0FF),
                  const Color(0xFFF0F4FF),
                ],
        ),
      ),
    );
  }

  Widget _buildGame(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    final total = _correctCount + _incorrectCount;
    final accuracy = total > 0 ? (_correctCount / total * 100).toInt() : 0;

    return SafeArea(
      child: Column(
        children: [
          _buildTopBar(theme, colorScheme, accuracy),
          const SizedBox(height: 4),
          _buildTimerBar(theme, colorScheme),
          const SizedBox(height: 8),
          _buildStatsRow(theme, colorScheme),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _currentQuestion == null
                      ? _buildLoading()
                      : _buildQuestionArea(theme, colorScheme),
                ),
                if (_showFeedback) _buildFeedbackStrip(theme, colorScheme),
                if (!_showFeedback && _currentQuestion != null)
                  _buildAnswerOptions(theme, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }

  Widget _buildTopBar(ThemeData theme, ColorScheme colorScheme, int accuracy) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
                const SizedBox(width: 4),
                Text('$_correctCount',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    )),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel, size: 16, color: Colors.red.shade700),
                const SizedBox(width: 4),
                Text('$_incorrectCount',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    )),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text('$_score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    )),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (_combo > 1)
            AnimatedScale(
              scale: _combo > 5 ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text('x$_combo',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimerBar(ThemeData theme, ColorScheme colorScheme) {
    final fraction = _timeLeft / 60.0;
    final isCritical = _timeLeft <= 10;
    final timerColor = fraction > 0.5
        ? Colors.green
        : fraction > 0.25
            ? Colors.orange
            : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _timerPulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isCritical ? (0.9 + _timerPulseController.value * 0.2) : 1.0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: timerColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _timeLeft <= 5 ? Icons.timer_off : Icons.timer,
                        color: timerColor,
                        size: 22,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Text(
                '$_timeLeft',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: timerColor,
                  fontSize: 32,
                ),
              ),
              const SizedBox(width: 8),
              Text('sec',
                  style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              )),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: colorScheme.surfaceContainerHighest,
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: fraction,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [
                          timerColor,
                          timerColor.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _statChip(Icons.check_circle, Colors.green, '$_correctCount', 'Correct')),
          const SizedBox(width: 8),
          Expanded(child: _statChip(Icons.cancel, Colors.red, '$_incorrectCount', 'Wrong')),
          const SizedBox(width: 8),
          Expanded(
            child: _statChip(
              Icons.speed,
              colorScheme.primary,
              '$_correctCount + $_incorrectCount',
              'Total',
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, Color color, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: color,
                fontSize: 16,
              )),
          Text(label,
              style: TextStyle(
                fontSize: 10,
                color: color.withValues(alpha: 0.8),
              )),
        ],
      ),
    );
  }

  Widget _buildQuestionArea(ThemeData theme, ColorScheme colorScheme) {
    final q = _currentQuestion!;
    debugPrint('QUESTION_AREA: text="${q.question}" answer="${q.correctAnswer}" pulseValue=${_pulseController.value}');
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Padding(
        key: ValueKey('${q.id}_$_correctCount'),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: ScaleTransition(
            scale: _pulseController.drive(CurveTween(curve: Curves.elasticOut)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E3F) : Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Question ${_questionIndex + 1}',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(q.question,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    letterSpacing: -0.3,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Widget _buildAnswerOptions(ThemeData theme, ColorScheme colorScheme) {
    final q = _currentQuestion!;
    // Options are pre-shuffled at generation time — never re-shuffle on display
    final options = q.options.length >= 3 ? q.options.sublist(0, 3) : q.options;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          ...List.generate(3, (i) {
            if (i >= options.length) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _answerButton(options[i], theme, colorScheme, i),
            );
          }),
        ],
      ),
    );
  }

  Widget _answerButton(String text, ThemeData theme, ColorScheme colorScheme, int index) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final isShaking = _shakeController.isAnimating && _lastCorrect == false;
        final offset = isShaking
            ? math.sin(_shakeController.value * 6 * math.pi) * 8
            : 0.0;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: AnimatedScale(
            scale: _showFeedback && _lastCorrect && text == _currentQuestion?.correctAnswer
                ? 1.02
                : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Material(
              color: _showFeedback
                  ? (text == _currentQuestion?.correctAnswer
                      ? Colors.green.withValues(alpha: 0.15)
                      : text == _currentQuestion?.correctAnswer
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1))
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              elevation: _showFeedback ? 0 : 4,
              shadowColor: colorScheme.primary.withValues(alpha: 0.15),
              child: InkWell(
                onTap: _showFeedback ? null : () => _answer(text),
                borderRadius: BorderRadius.circular(20),
                splashColor: colorScheme.primary.withValues(alpha: 0.1),
                highlightColor: colorScheme.primary.withValues(alpha: 0.05),
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _showFeedback
                          ? (text == _currentQuestion?.correctAnswer
                              ? Colors.green
                              : Colors.red)
                          : colorScheme.outlineVariant.withValues(alpha: 0.3),
                      width: _showFeedback ? 3 : 1.5,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_showFeedback && text == _currentQuestion?.correctAnswer)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(Icons.check_circle, color: Colors.green, size: 26),
                          )
                        else if (_showFeedback && text != _currentQuestion?.correctAnswer)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(Icons.cancel, color: Colors.red, size: 26),
                          ),
                        Text(text,
                            style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: _showFeedback
                              ? (text == _currentQuestion?.correctAnswer
                                  ? Colors.green.shade800
                                  : Colors.red.shade800)
                              : colorScheme.primary,
                          fontSize: 28,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeedbackStrip(ThemeData theme, ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _lastCorrect
              ? [Colors.green.withValues(alpha: 0.2), Colors.green.withValues(alpha: 0.1)]
              : [Colors.red.withValues(alpha: 0.2), Colors.red.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _lastCorrect ? Colors.green : Colors.red,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (_lastCorrect ? Colors.green : Colors.red).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: _pulseController.value > 0 ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _lastCorrect ? Icons.celebration : Icons.sentiment_dissatisfied,
              color: _lastCorrect ? Colors.green : Colors.red,
              size: 28,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              _lastCorrect
                  ? '+${10 + (_timeLeft ~/ 5) + (_combo ~/ 3) * 5} pts! ${_combo > 2 ? "x$_combo Combo!" : ""}'
                  : 'Answer: ${_currentQuestion?.correctAnswer}',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: _lastCorrect ? Colors.green.shade800 : Colors.red.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ── Results Screen ───────────────────────────────────────────────
  Widget _buildResults(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    final total = _correctCount + _incorrectCount;
    final acc = total > 0 ? (_correctCount / total * 100).toInt() : 0;
    final rating = _gradeRating();
    final ratingColor = _ratingColor(rating);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 40),
      child: Column(
        children: [
          // Confetti celebration
          if (acc >= 80)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFloatingEmoji('⭐'),
                  const SizedBox(width: 8),
                  _buildFloatingEmoji('🎉'),
                  const SizedBox(width: 8),
                  _buildFloatingEmoji('🏆'),
                ],
              ),
            ),
          _buildScoreCircle(acc, ratingColor, theme, colorScheme),
          const SizedBox(height: 20),
          Text('Time\'s Up!',
              style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          )),
          const SizedBox(height: 4),
          Text('Grade ${widget.grade} Speed Challenge',
              style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          )),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ratingColor, ratingColor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: ratingColor.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(rating,
                    style: theme.textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
                )),
                Text(_ratingLabel(rating),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _buildResultCard('Questions Answered', '$total', Icons.help_outline, colorScheme.primary),
          _buildResultCard('Correct Answers', '$_correctCount', Icons.check_circle, Colors.green),
          _buildResultCard('Incorrect Answers', '$_incorrectCount', Icons.cancel, Colors.red),
          _buildResultCard('Accuracy', '$acc%', Icons.analytics_outlined,
              acc >= 70 ? Colors.green : Colors.orange),
          _buildResultCard('Best Combo', 'x$_bestCombo', Icons.local_fire_department, Colors.amber),
          _buildResultCard('Final Score', '$_score', Icons.star, Colors.amber),
          _buildResultCard('Personal Best', '$_personalBest', Icons.emoji_events, Colors.amber.shade700),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Exit'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    side: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
                    foregroundColor: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    setState(_startGame);
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Play Again'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
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
    );
  }

  Widget _buildFloatingEmoji(String emoji) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Text(emoji, style: const TextStyle(fontSize: 32)),
    );
  }

  Widget _buildScoreCircle(int acc, Color color, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color, width: 5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$acc%',
                style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
              fontSize: 48,
            )),
            Text('Accuracy',
                style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Text(label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              )),
          const Spacer(),
          Text(value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              )),
        ],
      ),
    );
  }
}