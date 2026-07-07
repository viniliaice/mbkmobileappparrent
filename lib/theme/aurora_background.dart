import 'dart:math';
import 'package:flutter/material.dart';

class AuroraBackground extends StatefulWidget {
  final Widget child;
  final bool animate;

  const AuroraBackground({super.key, required this.child, this.animate = true});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    if (widget.animate) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF0B1026),
                      const Color(0xFF0F1B3D),
                      const Color(0xFF0D142E),
                    ]
                  : [
                      const Color(0xFFF0F4FF),
                      const Color(0xFFE8EEFF),
                      const Color(0xFFF5F0FF),
                    ],
            ),
          ),
          child: Stack(
            children: [
              if (widget.animate) ...[
                _buildBlob(
                  offset: Offset(
                    sin(_controller.value * 2 * pi) * 60,
                    cos(_controller.value * 1.7 * pi) * 40,
                  ),
                  size: 280,
                  color: isDark
                      ? const Color(0xFF448AFF).withValues(alpha: 0.06)
                      : const Color(0xFF448AFF).withValues(alpha: 0.04),
                ),
                _buildBlob(
                  offset: Offset(
                    cos(_controller.value * 1.3 * pi + 1) * 50,
                    sin(_controller.value * 2.1 * pi + 2) * 35,
                  ),
                  size: 220,
                  color: isDark
                      ? const Color(0xFF00BCD4).withValues(alpha: 0.05)
                      : const Color(0xFF00BCD4).withValues(alpha: 0.03),
                ),
                _buildBlob(
                  offset: Offset(
                    sin(_controller.value * 0.9 * pi + 3) * 45,
                    cos(_controller.value * 1.5 * pi + 1.5) * 30,
                  ),
                  size: 200,
                  color: isDark
                      ? const Color(0xFF9B59B6).withValues(alpha: 0.04)
                      : const Color(0xFF9B59B6).withValues(alpha: 0.03),
                ),
              ],
              SafeArea(child: child!),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }

  Widget _buildBlob({
    required Offset offset,
    required double size,
    required Color color,
  }) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - size / 2 + offset.dx,
      top: MediaQuery.of(context).size.height * 0.15 + offset.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 120,
              spreadRadius: 40,
            ),
          ],
        ),
      ),
    );
  }
}
