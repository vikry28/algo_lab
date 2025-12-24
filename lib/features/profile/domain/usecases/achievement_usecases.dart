import '../entities/achievement_entity.dart';
import '../entities/badge_entity.dart';
import '../repository/achievement_repository.dart';

class GetAchievementsUseCase {
  final AchievementRepository repository;

  GetAchievementsUseCase(this.repository);

  Future<List<AchievementEntity>> call(String uid) {
    return repository.getAchievements(uid);
  }
}

class GetBadgesUseCase {
  final AchievementRepository repository;

  GetBadgesUseCase(this.repository);

  Future<List<BadgeEntity>> call(String uid) {
    return repository.getBadges(uid);
  }
}

class UnlockAchievementUseCase {
  final AchievementRepository repository;

  UnlockAchievementUseCase(this.repository);

  Future<void> call(String uid, String achievementId) {
    return repository.unlockAchievement(uid, achievementId);
  }
}

class UnlockBadgeUseCase {
  final AchievementRepository repository;

  UnlockBadgeUseCase(this.repository);

  Future<void> call(String uid, String badgeId) {
    return repository.unlockBadge(uid, badgeId);
  }
}
