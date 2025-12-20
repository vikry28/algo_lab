import '../../features/profile/domain/entities/achievement_entity.dart';

class AchievementEvaluator {
  static List<AchievementEntity> getAllAchievements(
    int streak,
    int completedCount,
    int sessionCount,
  ) {
    return [
      AchievementEntity(
        id: 'first_algo',
        titleKey: 'achievement_first_algo',
        descriptionKey: 'achievement_first_algo_desc',
        icon: '🎯',
        color: 0xFF10B981,
        currentProgress: completedCount > 0 ? 1 : 0,
        targetProgress: 1,
        xpReward: 100,
      ),
      AchievementEntity(
        id: 'sorting_master',
        titleKey: 'achievement_sorting_master',
        descriptionKey: 'achievement_sorting_master_desc',
        icon: '📊',
        color: 0xFF8B5CF6,
        currentProgress: completedCount,
        targetProgress: 5,
        xpReward: 500,
      ),
      AchievementEntity(
        id: 'streak_hero',
        titleKey: 'achievement_streak_hero',
        descriptionKey: 'achievement_streak_hero_desc',
        icon: '🔥',
        color: 0xFFF97316,
        currentProgress: streak,
        targetProgress: 7,
        xpReward: 300,
      ),
      AchievementEntity(
        id: 'dedicated_learner',
        titleKey: 'achievement_dedicated_learner',
        descriptionKey: 'achievement_dedicated_learner_desc',
        icon: '📚',
        color: 0xFF3B82F6,
        currentProgress: sessionCount,
        targetProgress: 10,
        xpReward: 400,
      ),
    ];
  }
}
