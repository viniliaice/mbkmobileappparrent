import 'package:flutter/material.dart';

class AuroraCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final Color? accentColor;
  final bool hasGlow;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const AuroraCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.accentColor,
    this.hasGlow = false,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final radius = borderRadius ?? BorderRadius.circular(24);

    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          if (hasGlow && accentColor != null)
            BoxShadow(
              color: accentColor!.withValues(alpha: isDark ? 0.15 : 0.08),
              blurRadius: 32,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: colorScheme.primary.withValues(alpha: 0.08),
          highlightColor: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF141D3A).withValues(alpha: 0.7),
                        const Color(0xFF1A2A5C).withValues(alpha: 0.4),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.8),
                        const Color(0xFFF0F4FF).withValues(alpha: 0.5),
                      ],
              ),
            ),
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}
