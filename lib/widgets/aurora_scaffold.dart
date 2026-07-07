import 'package:flutter/material.dart';
import '../widgets/aurora_nav.dart';
import '../theme/aurora_background.dart';

class AuroraScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final List<AuroraNavItem>? navItems;
  final int? currentIndex;
  final ValueChanged<int>? onNavTap;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  const AuroraScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.navItems,
    this.currentIndex,
    this.onNavTap,
    this.bottomSheet,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAppBar = title != null || (actions != null && actions!.isNotEmpty);

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      bottomSheet: bottomSheet,
      body: AuroraBackground(
        child: Column(
          children: [
            if (hasAppBar)
              _buildAppBar(context, theme),
            Expanded(child: body),
            if (navItems != null && currentIndex != null && onNavTap != null)
              SafeArea(
                top: false,
                child: AuroraNavBar(
                  currentIndex: currentIndex!,
                  onTap: onNavTap!,
                  items: navItems!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    final nav = Navigator.of(context);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Row(
          children: [
            if (nav.canPop())
              IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, size: 20),
                onPressed: () => nav.pop(),
              ),
            if (title != null) ...[
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            ...?actions,
          ],
        ),
      ),
    );
  }
}
