import 'package:flutter/material.dart';

class AuroraNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AuroraNavItem> items;

  const AuroraNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark
            ? const Color(0xFF141D3A).withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.85),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: isDark ? const Color(0xFF6A72A0) : const Color(0xFF9A9FB8),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: items
              .map((item) => BottomNavigationBarItem(
                    icon: Icon(item.icon, size: 24),
                    activeIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(item.icon, size: 22, color: colorScheme.primary),
                    ),
                    label: item.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class AuroraNavItem {
  final IconData icon;
  final String label;
  const AuroraNavItem({required this.icon, required this.label});
}
