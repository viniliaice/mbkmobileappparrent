import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/activity.dart';
import '../models/vocab_word.dart';
import 'pronounce_button.dart';

class ActivityRenderer extends StatefulWidget {
  final LearningActivity activity;
  final VoidCallback onCorrect;
  final VoidCallback onIncorrect;
  final bool showTts;
  final List<VocabWord>? vocabWords;

  const ActivityRenderer({
    super.key,
    required this.activity,
    required this.onCorrect,
    required this.onIncorrect,
    this.showTts = false,
    this.vocabWords,
  });

  @override
  State<ActivityRenderer> createState() => _ActivityRendererState();
}

class _ActivityRendererState extends State<ActivityRenderer> {
  String? _selectedAnswer;
  bool? _isCorrect;
  bool _showHint = false;
  bool _countingMode = false;
  List<String> _countableItems = [];
  int _currentCount = 0;
  final Set<int> _countedIndices = {};

  @override
  void initState() {
    super.initState();
    _detectCountingMode();
  }

  void _detectCountingMode() {
    final text = widget.activity.question;
    final emoji = RegExp(
      r'[\u{2600}-\u{27BF}\u{1F300}-\u{1FAD6}]',
      unicode: true,
    );
    final matches = emoji.allMatches(text).toList();
    if (matches.length >= 3 &&
        widget.activity.type == ActivityType.tapCorrect &&
        (text.toLowerCase().contains('count') ||
            text.toLowerCase().contains('how many'))) {
      _countingMode = true;
      _countableItems = matches.map((m) => m.group(0)!).toList();
    }
  }

  void _submitAnswer(String answer) {
    if (_isCorrect != null) return;
    setState(() {
      _selectedAnswer = answer;
      _isCorrect = answer == widget.activity.correctAnswer;
    });
    if (_isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onIncorrect();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionCard(theme, colorScheme),
        if (widget.vocabWords != null && widget.vocabWords!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildVocabBar(theme, colorScheme),
        ],
        const SizedBox(height: 16),
        _buildActivityArea(theme, colorScheme),
        const SizedBox(height: 12),
        if (_isCorrect != null) _buildFeedback(theme, colorScheme),
        if (!_showHint && _isCorrect == null && widget.activity.hint.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _showHint = true),
              icon: const Icon(Icons.lightbulb_outline, size: 18),
              label: const Text('Need a hint?'),
            ),
          ),
        if (_showHint && _isCorrect == null)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, size: 20, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(widget.activity.hint,
                      style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.amber.shade900,
                  )),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionCard(ThemeData theme, ColorScheme colorScheme) {
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text('Question', style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              )),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _difficultyColor(widget.activity.difficulty).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Lv.${widget.activity.difficulty}',
                    style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _difficultyColor(widget.activity.difficulty),
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(widget.activity.question,
                    style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                )),
              ),
              if (widget.showTts)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: PronounceButton(word: widget.activity.question),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVocabBar(ThemeData theme, ColorScheme colorScheme) {
    final items = widget.vocabWords!;
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF141D3A).withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.word,
                        style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                    Text(item.definition,
                        style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    )),
                  ],
                ),
                const SizedBox(width: 4),
                PronounceButton(word: item.word, iconSize: 18),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityArea(ThemeData theme, ColorScheme colorScheme) {
    switch (widget.activity.type) {
      case ActivityType.multipleChoice:
        return _buildMultipleChoice(theme, colorScheme);
      case ActivityType.tapCorrect:
        return _buildTapCorrect(theme, colorScheme);
      case ActivityType.fillBlank:
        return _buildFillBlank(theme, colorScheme);
      case ActivityType.dragOrder:
        return _buildDragOrder(theme, colorScheme);
      case ActivityType.numberLine:
        return _buildNumberLine(theme, colorScheme);
      case ActivityType.matchPairs:
        return _buildMatchPairs(theme, colorScheme);
    }
  }

  Widget _buildMultipleChoice(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: widget.activity.options.map((opt) {
        final isSelected = _selectedAnswer == opt;
        final isRight = _isCorrect == true && isSelected;
        final isWrong = _isCorrect == false && isSelected;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AnimatedScale(
            scale: isSelected ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isCorrect == null ? () => _submitAnswer(opt) : null,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: BorderSide(
                    color: isRight
                        ? Colors.green
                        : isWrong
                            ? Colors.red
                            : colorScheme.outlineVariant,
                    width: isRight || isWrong ? 2 : 1,
                  ),
                  backgroundColor: isRight
                      ? Colors.green.withValues(alpha: 0.1)
                      : isWrong
                          ? Colors.red.withValues(alpha: 0.1)
                          : null,
                ),
                child: Row(
                  children: [
                    if (isRight)
                      const Icon(Icons.check_circle, color: Colors.green, size: 22)
                    else if (isWrong)
                      const Icon(Icons.cancel, color: Colors.red, size: 22)
                    else
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                      ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(opt, style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      )),
                    ),
                    if (_isCorrect == false && opt == widget.activity.correctAnswer)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Correct answer',
                            style: TextStyle(fontSize: 11, color: Colors.green.shade700)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTapCorrect(ThemeData theme, ColorScheme colorScheme) {
    if (_countingMode) return _buildCountingActivity(theme, colorScheme);
    final gridSize = widget.activity.options.length;
    final crossAxisCount = gridSize <= 4 ? 2 : 3;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.activity.options.map((opt) {
        final isSelected = _selectedAnswer == opt;
        final isRight = _isCorrect == true && isSelected;
        final isWrong = _isCorrect == false && isSelected;
        return GestureDetector(
          onTap: _isCorrect == null ? () => _submitAnswer(opt) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: (MediaQuery.of(context).size.width - 64) / crossAxisCount,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            decoration: BoxDecoration(
              color: isRight
                  ? Colors.green.withValues(alpha: 0.15)
                  : isWrong
                      ? Colors.red.withValues(alpha: 0.15)
                      : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isRight
                    ? Colors.green
                    : isWrong
                        ? Colors.red
                        : colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: isRight || isWrong ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(opt, style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
                      if (_isCorrect == false && opt == widget.activity.correctAnswer)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Correct ✓', style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFillBlank(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isCorrect == null)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.activity.options.map((opt) {
              final isSelected = _selectedAnswer == opt;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                child: ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  onSelected: _isCorrect == null
                      ? (v) {
                          if (v) _submitAnswer(opt);
                        }
                      : null,
                  selectedColor: colorScheme.primaryContainer,
                ),
              );
            }).toList(),
          ),
        if (_isCorrect != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isCorrect!
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _isCorrect! ? Icons.check_circle : Icons.cancel,
                  color: _isCorrect! ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 12),
                Text(
                  _isCorrect!
                      ? 'Correct! "$_selectedAnswer" is right!'
                      : 'The answer was: ${widget.activity.correctAnswer}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDragOrder(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        if (_isCorrect == null) ...[
          _DragOrderList(
            items: List.of(widget.activity.options),
            onSubmitted: (ordered) {
              final joined = ordered.join(',');
              _submitAnswer(joined);
            },
          ),
        ] else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isCorrect!
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _isCorrect! ? Icons.check_circle : Icons.cancel,
                  color: _isCorrect! ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isCorrect! ? 'Perfect order!' : 'Not quite right.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!_isCorrect!)
                        Text('Correct order: ${widget.activity.correctAnswer}',
                            style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        )),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCountingActivity(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text('Tap each item to count',
                  style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              )),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(_countableItems.length, (index) {
                  final counted = _countedIndices.contains(index);
                  return GestureDetector(
                    onTap: _isCorrect == null
                        ? () {
                            setState(() {
                              if (counted) {
                                _countedIndices.remove(index);
                                _currentCount--;
                              } else {
                                _countedIndices.add(index);
                                _currentCount++;
                              }
                            });
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: counted
                            ? Colors.green.withValues(alpha: 0.2)
                            : colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: counted
                              ? Colors.green
                              : colorScheme.outlineVariant
                                  .withValues(alpha: 0.3),
                          width: counted ? 2.5 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(_countableItems[index],
                            style: const TextStyle(fontSize: 34)),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate,
                        size: 20, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text('Counted: $_currentCount',
                        style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isCorrect == null && _countedIndices.isNotEmpty
                      ? () => _submitAnswer(_currentCount.toString())
                      : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text('Confirm Count'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberLine(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        if (_isCorrect == null) ...[
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: LayoutBuilder(builder: (context, constraints) {
              return GestureDetector(
                onTapDown: _isCorrect == null
                    ? (details) {
                        final value = ((details.localPosition.dx /
                                    constraints.maxWidth) *
                                20)
                            .round();
                        _submitAnswer(value.toString());
                      }
                    : null,
                child: CustomPaint(
                  size: Size(constraints.maxWidth, 60),
                  painter: _NumberLinePainter(
                    selectedValue: _selectedAnswer != null
                        ? int.tryParse(_selectedAnswer!)
                        : null,
                    correctValue: int.tryParse(widget.activity.correctAnswer),
                    isCorrect: _isCorrect,
                    primaryColor: colorScheme.primary,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text('Tap on the number line',
              style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          )),
          if (_selectedAnswer != null && _isCorrect == null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('You tapped: $_selectedAnswer',
                  style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              )),
            ),
        ] else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isCorrect!
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _isCorrect! ? Icons.check_circle : Icons.cancel,
                  color: _isCorrect! ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 12),
                Text(
                  _isCorrect!
                      ? 'Correct! ${widget.activity.correctAnswer} is right!'
                      : 'The answer was ${widget.activity.correctAnswer}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMatchPairs(ThemeData theme, ColorScheme colorScheme) {
    if (_isCorrect == null) {
      final pairs = widget.activity.options.first.split(', ');
      final leftItems = <String>[];
      final rightItems = <String>[];
      for (final pair in pairs) {
        final parts = pair.split('=');
        if (parts.length == 2) {
          leftItems.add(parts[0].trim());
          rightItems.add(parts[1].trim());
        }
      }
      rightItems.shuffle();
      String? selectedLeft;

      return StatefulBuilder(builder: (context, setLocalState) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: leftItems.map((item) {
                      final isSelected = selectedLeft == item;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primaryContainer
                                : colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant
                                      .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(item,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: rightItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () {
                            final answer = '$selectedLeft=$item';
                            _submitAnswer(answer);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer
                                .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(item,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Text('Tap a left item, then tap its match on the right',
                style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            )),
          ],
        );
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCorrect!
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_isCorrect! ? Icons.check_circle : Icons.cancel,
              color: _isCorrect! ? Colors.green : Colors.red),
          const SizedBox(width: 12),
          Text(
            _isCorrect! ? 'Perfect match!' : 'Try again next time!',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback(ThemeData theme, ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isCorrect!
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isCorrect!
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isCorrect! ? Icons.check_circle_rounded : Icons.info_outline,
            color: _isCorrect! ? Colors.green : Colors.red,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isCorrect!
                  ? 'Great job! That\'s correct!'
                  : widget.activity.hint.isNotEmpty
                      ? 'Not quite. ${widget.activity.hint}'
                      : 'Not quite. The correct answer was: ${widget.activity.correctAnswer}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _isCorrect!
                    ? Colors.green.shade800
                    : Colors.red.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _difficultyColor(int level) {
    if (level <= 1) return Colors.green;
    if (level <= 2) return Colors.orange;
    return Colors.red;
  }
}

class _DragOrderList extends StatefulWidget {
  final List<String> items;
  final ValueChanged<List<String>> onSubmitted;

  const _DragOrderList({required this.items, required this.onSubmitted});

  @override
  State<_DragOrderList> createState() => _DragOrderListState();
}

class _DragOrderListState extends State<_DragOrderList> {
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items)..shuffle();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          onReorderItem: _onReorder,
          proxyDecorator: (child, index, animation) => Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
          itemBuilder: (context, index) {
            return Padding(
              key: ValueKey(_items[index]),
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(Icons.drag_handle, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${index + 1}.', style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    )),
                    const SizedBox(width: 8),
                    Text(_items[index], style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonalIcon(
            onPressed: () => widget.onSubmitted(_items),
            icon: const Icon(Icons.check),
            label: const Text('Check Order'),
          ),
        ),
      ],
    );
  }
}

class _NumberLinePainter extends CustomPainter {
  final int? selectedValue;
  final int? correctValue;
  final bool? isCorrect;
  final Color primaryColor;

  _NumberLinePainter({
    this.selectedValue,
    this.correctValue,
    this.isCorrect,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..strokeWidth = 2;

    final y = size.height / 2;
    final left = 20.0;
    final right = size.width - 20;

    canvas.drawLine(Offset(left, y), Offset(right, y), paint);

    for (int i = 0; i <= 20; i++) {
      final x = left + (right - left) * (i / 20);
      final isMain = i % 5 == 0;
      final tickHeight = isMain ? 12.0 : 6.0;
      canvas.drawLine(
        Offset(x, y - tickHeight / 2),
        Offset(x, y + tickHeight / 2),
        paint,
      );
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= 20; i += 5) {
      final x = left + (right - left) * (i / 20);
      textPainter.text = TextSpan(
        text: '$i',
        style: TextStyle(color: Colors.grey, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y + 12));
    }

    if (selectedValue != null) {
      final x = left + (right - left) * (selectedValue! / 20);
      final color = isCorrect == true ? Colors.green : isCorrect == false ? Colors.red : primaryColor;
      canvas.drawCircle(
        Offset(x, y),
        10,
        Paint()..color = color..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        Offset(x, y),
        10,
        Paint()
          ..color = color.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NumberLinePainter old) =>
      old.selectedValue != selectedValue || old.isCorrect != isCorrect;
}
