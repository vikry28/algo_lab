import '../entities/achievement_entity.dart';
import '../entities/badge_entity.dart';

abstract class AchievementRepository {
  Future<List<AchievementEntity>> getAchievements(String uid);
  Future<List<BadgeEntity>> getBadges(String uid);
  Future<void> unlockAchievement(String uid, String achievementId);
  Future<void> unlockBadge(String uid, String badgeId);
}
