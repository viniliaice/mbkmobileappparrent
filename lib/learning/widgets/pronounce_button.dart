import 'package:flutter/material.dart';
import '../../services/tts_service.dart';

class PronounceButton extends StatefulWidget {
  final String word;
  final double iconSize;

  const PronounceButton({
    super.key,
    required this.word,
    this.iconSize = 24,
  });

  @override
  State<PronounceButton> createState() => _PronounceButtonState();
}

class _PronounceButtonState extends State<PronounceButton>
    with SingleTickerProviderStateMixin {
  final _tts = TtsService();
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _speak() async {
    _pulseController.repeat(reverse: true);
    await _tts.speakWord(widget.word);
    _pulseController.stop();
    _pulseController.value = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = 1.0 + (_pulseController.value * 0.12);
    return Transform.scale(
      scale: scale,
      child: GestureDetector(
        onTap: _speak,
        child: Container(
          width: widget.iconSize + 20,
          height: widget.iconSize + 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            Icons.volume_up_rounded,
            color: theme.colorScheme.primary,
            size: widget.iconSize,
          ),
        ),
      ),
    );
  }
}
