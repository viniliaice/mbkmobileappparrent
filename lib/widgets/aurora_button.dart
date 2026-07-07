import 'package:flutter/material.dart';

class AuroraButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expanded;
  final List<Color>? gradient;
  final double height;

  const AuroraButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
    this.expanded = true,
    this.gradient,
    this.height = 56,
  });

  @override
  State<AuroraButton> createState() => _AuroraButtonState();
}

class _AuroraButtonState extends State<AuroraButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = widget.gradient ??
        (isDark
            ? [const Color(0xFF448AFF), const Color(0xFF3D5AFE)]
            : [const Color(0xFF3D5AFE), const Color(0xFF5C6BC0)]);
    final disabled = widget.onPressed == null || widget.loading;
    final effectiveOpacity = disabled ? 0.5 : 1.0;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 - (_pulseController.value * 0.02);
        return Transform.scale(
          scale: scale,
          child: Container(
            height: widget.height,
            width: widget.expanded ? double.infinity : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradientColors.first.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTapDown: disabled ? null : (_) => _pulseController.forward(),
                onTapUp: disabled ? null : (_) {
                  _pulseController.reverse();
                  widget.onPressed?.call();
                },
                onTapCancel: () => _pulseController.reverse(),
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.white.withValues(alpha: 0.15),
                highlightColor: Colors.transparent,
                child: Center(
                  child: Opacity(
                    opacity: effectiveOpacity,
                    child: Row(
                      mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.loading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else ...[
                          if (widget.icon != null) ...[
                            Icon(widget.icon, color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            widget.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
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
}
