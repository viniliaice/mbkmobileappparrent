import 'package:flutter/material.dart';

class AuroraNavRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AuroraRailItem> items;

  const AuroraNavRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      width: 200,
      margin: const EdgeInsets.fromLTRB(12, 12, 0, 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(24)),
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
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(24)),
        child: Column(
          children: [
            const Spacer(flex: 1),
            // Logo / Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00BCD4), Color(0xFF3D5AFE)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Center(
                      child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('MBK', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Navigation items
            ...List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == selectedIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onDestinationSelected(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: selected
                            ? colorScheme.primary.withValues(alpha: 0.12)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          if (selected)
                            Container(
                              width: 4, height: 24,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                gradient: LinearGradient(
                                  colors: [Color(0xFF00BCD4), Color(0xFF3D5AFE)],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class AuroraRailItem {
  final IconData icon;
  final String label;
  const AuroraRailItem({required this.icon, required this.label});
}
