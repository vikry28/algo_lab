import '../../../../core/services/firestore_service.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/entities/badge_entity.dart';
import '../../domain/repository/achievement_repository.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final FirestoreService firestoreService;

  AchievementRepositoryImpl({required this.firestoreService});

  @override
  Future<List<AchievementEntity>> getAchievements(String uid) async {
    // For now, these are computed in the provider or we could fetch from Firestore
    // if we had a collection for 'unlocked_achievements'.
    // To keep it simple and clean, we'll return an empty list or let the provider compute.
    // However, Clean Architecture would suggest the repository provides them.
    return [];
  }

  @override
  Future<List<BadgeEntity>> getBadges(String uid) async {
    return [];
  }

  @override
  Future<void> unlockAchievement(String uid, String achievementId) async {
    try {
      await firestoreService.addCompletedAchievement(uid, achievementId);
    } catch (e) {
      // log or rethrow if needed
    }
  }

  @override
  Future<void> unlockBadge(String uid, String badgeId) async {
    try {
      await firestoreService.addBadgeToUser(uid, badgeId);
    } catch (e) {
      // log or rethrow if needed
    }
  }
}
