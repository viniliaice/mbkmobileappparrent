import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/math_question.dart';

class QuestionActivityView extends StatefulWidget {
  final MathQuestion question;
  final void Function(bool isCorrect) onAnswer;

  const QuestionActivityView({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  State<QuestionActivityView> createState() => _QuestionActivityViewState();
}

class _QuestionActivityViewState extends State<QuestionActivityView>
    with TickerProviderStateMixin {
  String? _selectedAnswer;
  bool? _isCorrect;
  bool _showHint = false;
  bool _isLocked = false;
  List<String>? _orderItems;
  String? _selectedLeft;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _appearController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    if (widget.question.type == QuestionType.dragOrder && widget.question.options.isNotEmpty) {
      _orderItems = List.of(widget.question.options)..shuffle();
    }
  }

  @override
  void didUpdateWidget(covariant QuestionActivityView old) {
    super.didUpdateWidget(old);
    if (old.question.id != widget.question.id) {
      setState(() {
        _selectedAnswer = null;
        _isCorrect = null;
        _isLocked = false;
        _showHint = false;
        _selectedLeft = null;
        if (widget.question.type == QuestionType.dragOrder && widget.question.options.isNotEmpty) {
          _orderItems = List.of(widget.question.options)..shuffle();
        }
      });
      _appearController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _appearController.dispose();
    super.dispose();
  }

  void _tryAnswer(String answer) {
    if (_isLocked) return;
    setState(() {
      _selectedAnswer = answer;
      _isCorrect = answer == widget.question.correctAnswer;
      _isLocked = true;
    });
    if (_isCorrect!) {
      HapticFeedback.lightImpact();
      _pulseController.forward(from: 0);
    } else {
      HapticFeedback.mediumImpact();
      _shakeController.forward(from: 0);
    }
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) widget.onAnswer(_isCorrect!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FadeTransition(
      opacity: _appearController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _appearController, curve: Curves.easeOutCubic)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestionCard(theme, colorScheme),
            const SizedBox(height: 20),
            _buildActivityArea(theme, colorScheme),
            const SizedBox(height: 12),
            if (_isCorrect != null) _buildFeedback(theme, colorScheme),
            if (!_showHint && _isCorrect == null && widget.question.hint.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _showHint = true),
                  icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
                  label: const Text('Need a hint?'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.amber.shade700,
                  ),
                ),
              ),
            if (_showHint && _isCorrect == null)
              _buildHintCard(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(ThemeData theme, ColorScheme colorScheme) {
    final q = widget.question;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.5),
            colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text('Question',
                  style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              )),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _difficultyColor(q.difficulty).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_difficultyIcon(q.difficulty), size: 12, color: _difficultyColor(q.difficulty)),
                    const SizedBox(width: 4),
                    Text(difficultyLabel2(q),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _difficultyColor(q.difficulty),
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(q.question,
              style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.4,
            letterSpacing: -0.2,
          )),
        ],
      ),
    );
  }

  Widget _buildActivityArea(ThemeData theme, ColorScheme colorScheme) {
    final type = widget.question.type;
    switch (type) {
      case QuestionType.multipleChoice:
        return _buildMultipleChoice(theme, colorScheme);
      case QuestionType.tapCorrect:
        return _buildTapCorrect(theme, colorScheme);
      case QuestionType.fillBlank:
        return _buildFillBlank(theme, colorScheme);
      case QuestionType.dragOrder:
        return _buildDragOrder(theme, colorScheme);
      case QuestionType.numberLine:
        return _buildNumberLine(theme, colorScheme);
      case QuestionType.matching:
        return _buildMatching(theme, colorScheme);
    }
  }

  Widget _buildMultipleChoice(ThemeData theme, ColorScheme colorScheme) {
    final options = widget.question.options;
    return Column(
      children: options.map((opt) {
        final isSelected = _selectedAnswer == opt;
        final isRight = _isCorrect == true && isSelected;
        final isWrong = _isCorrect == false && isSelected;
        final isCorrectOption = _isCorrect == false && opt == widget.question.correctAnswer;
        return AnimatedScale(
          scale: isSelected ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: isRight
                  ? Colors.green.withValues(alpha: 0.12)
                  : isWrong
                      ? Colors.red.withValues(alpha: 0.1)
                      : isCorrectOption
                          ? Colors.green.withValues(alpha: 0.08)
                          : colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              elevation: isSelected ? 0 : 2,
              shadowColor: colorScheme.primary.withValues(alpha: 0.1),
              child: InkWell(
                onTap: _isLocked ? null : () => _tryAnswer(opt),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isRight
                          ? Colors.green
                          : isWrong
                              ? Colors.red
                              : isCorrectOption
                                  ? Colors.green.withValues(alpha: 0.5)
                                  : colorScheme.outlineVariant.withValues(alpha: 0.4),
                      width: isRight || isWrong || isCorrectOption ? 2.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (isRight)
                        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 26)
                      else if (isWrong)
                        const Icon(Icons.cancel_rounded, color: Colors.red, size: 26)
                      else if (isCorrectOption)
                        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 26)
                      else
                        Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colorScheme.outlineVariant, width: 2),
                          ),
                        ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(opt, style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          height: 1.4,
                          color: isRight ? Colors.green.shade800 : isWrong ? Colors.red.shade800 : null,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTapCorrect(ThemeData theme, ColorScheme colorScheme) {
    final options = widget.question.options;
    final crossAxisCount = options.length <= 4 ? 2 : 3;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((opt) {
        final isSelected = _selectedAnswer == opt;
        final isRight = _isCorrect == true && isSelected;
        final isWrong = _isCorrect == false && isSelected;
        final isCorrectOption = _isCorrect == false && opt == widget.question.correctAnswer;
        final width = (MediaQuery.of(context).size.width - 56) / crossAxisCount;
        return SizedBox(
          width: width,
          child: Material(
            color: isRight
                ? Colors.green.withValues(alpha: 0.15)
                : isWrong
                    ? Colors.red.withValues(alpha: 0.1)
                    : isCorrectOption
                        ? Colors.green.withValues(alpha: 0.08)
                        : colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            elevation: 2,
            child: InkWell(
              onTap: _isLocked ? null : () => _tryAnswer(opt),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isRight || isCorrectOption ? Colors.green : isWrong ? Colors.red : colorScheme.outlineVariant.withValues(alpha: 0.4),
                    width: isRight || isWrong || isCorrectOption ? 2.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(opt,
                        style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isRight ? Colors.green.shade800 : isWrong ? Colors.red.shade800 : colorScheme.primary,
                    )),
                    if (isCorrectOption) ...[
                      const SizedBox(height: 4),
                      Text('Correct ✓',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w700,
                          )),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFillBlank(ThemeData theme, ColorScheme colorScheme) {
    final options = widget.question.options;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        final isSelected = _selectedAnswer == opt;
        return AnimatedScale(
          scale: isSelected ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: ChoiceChip(
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Text(opt, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            selected: isSelected,
            onSelected: _isLocked ? null : (v) {
              if (v) _tryAnswer(opt);
            },
            selectedColor: _isCorrect == true ? Colors.green.shade200 : _isCorrect == false ? Colors.red.shade200 : colorScheme.primaryContainer,
            backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: _isCorrect == true && isSelected ? Colors.green : _isCorrect == false && isSelected ? Colors.red : colorScheme.outlineVariant,
                width: _isCorrect != null && isSelected ? 2.5 : 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDragOrder(ThemeData theme, ColorScheme colorScheme) {
    if (_orderItems == null) return const SizedBox.shrink();
    return Column(
      children: [
        ...List.generate(_orderItems!.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('${i + 1}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(_orderItems![i],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    ReorderableDragStartListener(
                      index: i,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(Icons.drag_indicator_rounded, color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isLocked ? null : () {
              final joined = _orderItems!.join(',');
              _tryAnswer(joined);
            },
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text('Check Order'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberLine(ThemeData theme, ColorScheme colorScheme) {
    final correct = widget.question.correctAnswer;
    return Column(
      children: [
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: LayoutBuilder(builder: (context, constraints) {
            return GestureDetector(
              onTapDown: _isLocked
                  ? null
                  : (details) {
                      final value = ((details.localPosition.dx /
                                  constraints.maxWidth) *
                              20)
                          .round()
                          .clamp(0, 20);
                      setState(() {});
                      _tryAnswer(value.toString());
                    },
              child: CustomPaint(
                size: Size(constraints.maxWidth, 80),
                painter: _NumberLinePainter(
                  selectedValue: _selectedAnswer != null
                      ? int.tryParse(_selectedAnswer!)
                      : null,
                  correctValue: int.tryParse(correct),
                  isCorrect: _isCorrect,
                  maxValue: 20,
                  primaryColor: colorScheme.primary,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        if (_selectedAnswer == null)
          Text('Tap on the number line',
              style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ))
        else
          Text('You tapped: $_selectedAnswer',
              style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.primary,
          )),
      ],
    );
  }

  Widget _buildMatching(ThemeData theme, ColorScheme colorScheme) {
    final q = widget.question;
    final pairsRaw = q.options.isNotEmpty ? q.options.first : '';
    final pairs = pairsRaw.split(', ').map((s) {
      final parts = s.split('=');
      return parts.length == 2 ? {'l': parts[0].trim(), 'r': parts[1].trim()} : {'l': s, 'r': s};
    }).toList();

    return StatefulBuilder(builder: (ctx, setLocalState) {
      final leftItems = pairs.map((p) => p['l']!).toList();
      var rightItems = pairs.map((p) => p['r']!).toList();
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: leftItems.map((item) {
                    final isSelected = _selectedLeft == item;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: isSelected ? colorScheme.primaryContainer : colorScheme.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: _isLocked ? null : () {
                            setState(() {
                              _selectedLeft = isSelected ? null : item;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? colorScheme.primary : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(item,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            )),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.link_rounded, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: rightItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: _isLocked || _selectedLeft == null ? null : () {
                            final answer = '$_selectedLeft=$item';
                            setState(() => _selectedLeft = null);
                            _tryAnswer(answer);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(item,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            )),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Tap a left item, then tap its match on the right',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          )),
        ],
      );
    });
  }

  Widget _buildFeedback(ThemeData theme, ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (_isCorrect! ? Colors.green : Colors.red).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _isCorrect! ? Colors.green : Colors.red, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (_isCorrect! ? Colors.green : Colors.red).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isCorrect! ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              color: _isCorrect! ? Colors.green : Colors.red,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isCorrect! ? 'Great job!' : 'Not quite!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: (_isCorrect! ? Colors.green : Colors.red).shade800,
                  ),
                ),
                if (!_isCorrect! && widget.question.explanation.isNotEmpty)
                  Text(widget.question.explanation,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintCard(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_rounded, color: Colors.amber.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(widget.question.hint,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.amber.shade900,
                )),
          ),
        ],
      ),
    );
  }

  Color _difficultyColor(Difficulty d) {
    switch (d) {
      case Difficulty.easy: return Colors.green;
      case Difficulty.medium: return Colors.orange;
      case Difficulty.hard: return Colors.red;
    }
  }

  IconData _difficultyIcon(Difficulty d) {
    switch (d) {
      case Difficulty.easy: return Icons.sentiment_very_satisfied_rounded;
      case Difficulty.medium: return Icons.sentiment_satisfied_rounded;
      case Difficulty.hard: return Icons.local_fire_department_rounded;
    }
  }
}

String difficultyLabel2(MathQuestion q) {
  switch (q.difficulty) {
    case Difficulty.easy: return 'Easy';
    case Difficulty.medium: return 'Medium';
    case Difficulty.hard: return 'Hard';
  }
}

class _NumberLinePainter extends CustomPainter {
  final int? selectedValue;
  final int? correctValue;
  final bool? isCorrect;
  final int maxValue;
  final Color primaryColor;

  _NumberLinePainter({
    this.selectedValue,
    this.correctValue,
    this.isCorrect,
    required this.maxValue,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withValues(alpha: 0.4)
      ..strokeWidth = 2;
    final y = size.height / 2;
    final left = 16.0;
    final right = size.width - 16;

    canvas.drawLine(Offset(left, y), Offset(right, y), paint);

    for (int i = 0; i <= maxValue; i++) {
      final x = left + (right - left) * (i / maxValue);
      final isMain = i % 5 == 0;
      final tickHeight = isMain ? 14.0 : 8.0;
      canvas.drawLine(
        Offset(x, y - tickHeight / 2),
        Offset(x, y + tickHeight / 2),
        paint,
      );
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= maxValue; i += 5) {
      final x = left + (right - left) * (i / maxValue);
      textPainter.text = TextSpan(
        text: '$i',
        style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w700),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y + 16));
    }

    if (selectedValue != null) {
      final x = left + (right - left) * (selectedValue! / maxValue);
      final color = isCorrect == true ? Colors.green : isCorrect == false ? Colors.red : primaryColor;
      // Glow effect
      canvas.drawCircle(Offset(x, y), 16, Paint()..color = color.withValues(alpha: 0.2)..style = PaintingStyle.fill);
      canvas.drawCircle(Offset(x, y), 12, Paint()..color = color..style = PaintingStyle.fill);
      // Correct indicator above
      if (isCorrect != false && correctValue != null) {
        final text = TextPainter(
          text: TextSpan(
            text: '✓',
            style: TextStyle(color: Colors.green.shade700, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        text.paint(canvas, Offset(x - text.width / 2, y - 36));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NumberLinePainter old) =>
      old.selectedValue != selectedValue ||
      old.isCorrect != isCorrect;
}