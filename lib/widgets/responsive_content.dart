import 'package:flutter/material.dart';
import 'responsive.dart';

/// Wraps child content with a centered, max-width constraint on desktop screens.
///
/// On mobile (< 900px), the child fills the available width unchanged.
/// On desktop, the child is centered, constrained to [maxWidth], and given
/// horizontal padding so content doesn't run edge-to-edge.
class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final double desktopPadding;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = 1100,
    this.desktopPadding = 32,
  });

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width >= desktopBreakpoint;

    if (!desktop) return child;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: desktopPadding),
          child: child,
        ),
      ),
    );
  }
}