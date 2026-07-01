import 'package:flutter/material.dart';
import '../models/achievement.dart';

class AchievementBadgeWidget extends StatelessWidget {
  final Achievement achievement;
  final bool unlocked;
  final double size;

  const AchievementBadgeWidget({
    super.key,
    required this.achievement,
    this.unlocked = false,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? achievement.color : Colors.grey;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: unlocked ? color.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.1),
        border: Border.all(
          color: unlocked ? color.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            achievement.icon,
            color: unlocked ? color : Colors.grey,
            size: size * 0.45,
          ),
        ],
      ),
    );
  }
}
