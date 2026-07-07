import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/aurora_background.dart';
import '../provider.dart';
import '../widgets/badge.dart';
import '../../widgets/responsive_content.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: AuroraBackground(
        child: Consumer<LearningProvider>(
          builder: (context, lp, _) {
            if (!lp.loaded) {
              return const Center(child: CircularProgressIndicator());
            }
            final achievements = LearningProvider.achievements;
            return ResponsiveContent(
              child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: achievements.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildHeader(theme, colorScheme, lp);
              }
              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('${lp.unlockedCount} / ${lp.totalAchievements} Unlocked',
                      style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  )),
                );
              }
              final ach = achievements[index - 2];
              final unlocked = lp.unlockedAchievements.contains(ach.id);
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      AchievementBadgeWidget(
                        achievement: ach,
                        unlocked: unlocked,
                        size: 52,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ach.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: unlocked ? null : Colors.grey,
                            )),
                            const SizedBox(height: 2),
                            Text(ach.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                              color: unlocked
                                  ? colorScheme.onSurfaceVariant
                                  : Colors.grey,
                            )),
                          ],
                        ),
                      ),
                      Icon(
                        unlocked ? Icons.check_circle : Icons.lock_outline,
                        color: unlocked ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
            ),
          );
        },
      ),
    ),
  );
  }

  Widget _buildHeader(
      ThemeData theme, ColorScheme colorScheme, LearningProvider lp) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.emoji_events_rounded,
                color: Colors.white, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Achievements',
                    style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
                Text('${lp.unlockedCount} unlocked',
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
