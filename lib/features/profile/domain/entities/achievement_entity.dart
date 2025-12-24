class AchievementEntity {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String icon;
  final int color;
  final int currentProgress;
  final int targetProgress;
  final int xpReward;

  const AchievementEntity({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.color,
    required this.currentProgress,
    required this.targetProgress,
    required this.xpReward,
  });

  bool get isCompleted => currentProgress >= targetProgress;
  double get progressPercentage =>
      (currentProgress / targetProgress).clamp(0.0, 1.0);
}
