import 'package:flutter/material.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/entities/badge_entity.dart';
import '../../domain/usecases/achievement_usecases.dart';
import '../../../learning/presentation/provider/learning_provider.dart';
import '../provider/profile_provider.dart';
import '../../../../core/utils/achievement_evaluator.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/di/service_locator.dart';

class AchievementProvider with ChangeNotifier {
  final LearningProvider learningProvider;
  final ProfileProvider profileProvider;
  final GetAchievementsUseCase getAchievementsUseCase;
  final GetBadgesUseCase getBadgesUseCase;

  AchievementProvider({
    required this.learningProvider,
    required this.profileProvider,
    required this.getAchievementsUseCase,
    required this.getBadgesUseCase,
  }) {
    learningProvider.addListener(_onDataChanged);
    profileProvider.addListener(_onDataChanged);
  }

  String? _lastUnlockedBadge;
  String? get lastUnlockedBadge => _lastUnlockedBadge;
  void clearLastUnlockedBadge() {
    _lastUnlockedBadge = null;
    notifyListeners();
  }

  @override
  void dispose() {
    learningProvider.removeListener(_onDataChanged);
    profileProvider.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    _checkNewAchievements();
    _checkNewBadges();
    notifyListeners();
  }

  void _checkNewBadges() {
    final profile = profileProvider.profile;
    if (profile == null) return;

    final allBadges = badges;
    for (var b in allBadges) {
      if (b.isUnlocked && !profile.badges.contains(b.id)) {
        // Persist new badge
        final uid = profile.uid;
        sl<UnlockBadgeUseCase>()
            .call(uid, b.id)
            .then((_) {
              // Show local notification for badge unlocked
              sl<NotificationService>().showBadgeNotification(
                'notification_badge_unlocked_title',
                'notification_badge_unlocked_body',
                payload: b.id,
                arguments: {
                  'name': b.titleKey,
                }, // We'll translate this in NotificationService
              );
              _lastUnlockedBadge = b.id;
              notifyListeners();
            })
            .catchError((_) {});
      }
    }
  }

  void _checkNewAchievements() {
    final profile = profileProvider.profile;
    if (profile == null) return;

    final allAchievements = achievements;
    for (var ach in allAchievements) {
      if (ach.isCompleted && !profile.completedAchievements.contains(ach.id)) {
        // New achievement completed!
        _completeAchievement(ach);
      }
    }
  }

  Future<void> _completeAchievement(AchievementEntity ach) async {
    await profileProvider.completeAchievement(ach.id);
    // Persist immediately via repository/usecase to ensure Firestore has the achievement recorded
    final profile = profileProvider.profile;
    if (profile != null) {
      try {
        await sl<UnlockAchievementUseCase>().call(profile.uid, ach.id);
      } catch (_) {}
    }
    await learningProvider.addXP(ach.xpReward);

    // Show local notification
    sl<NotificationService>().showBadgeNotification(
      'notification_achievement_reached_title',
      'notification_achievement_reached_body',
      arguments: {'name': ach.titleKey},
    );
  }

  // ============= BADGES =============
  List<BadgeEntity> get badges {
    final totalXP = learningProvider.totalXP;

    return [
      BadgeEntity(
        id: 'algo_novice',
        titleKey: 'badge_algo_novice',
        descriptionKey: 'badge_algo_novice_desc',
        icon: '🌱',
        color: 0xFF10B981,
        isUnlocked: totalXP >= 100,
        requiredXP: 100,
      ),
      BadgeEntity(
        id: 'algo_master',
        titleKey: 'badge_algo_master',
        descriptionKey: 'badge_algo_master_desc',
        icon: '🧠',
        color: 0xFF3B82F6,
        isUnlocked: totalXP >= 5000,
        requiredXP: 5000,
      ),
      BadgeEntity(
        id: 'speed_demon',
        titleKey: 'badge_speed_demon',
        descriptionKey: 'badge_speed_demon_desc',
        icon: '⚡',
        color: 0xFFEC4899,
        isUnlocked: totalXP >= 3000,
        requiredXP: 3000,
      ),
      BadgeEntity(
        id: 'elite_pro',
        titleKey: 'badge_elite_pro',
        descriptionKey: 'badge_elite_pro_desc',
        icon: '🏆',
        color: 0xFFF59E0B,
        isUnlocked: userLevel >= 10,
        requiredXP: 0,
      ),
    ];
  }

  int get unlockedBadgesCount => badges.where((b) => b.isUnlocked).length;

  // ============= ACHIEVEMENTS =============
  List<AchievementEntity> get achievements {
    final profile = profileProvider.profile;
    if (profile == null) return [];

    return AchievementEvaluator.getAllAchievements(
      learningProvider.streak,
      learningProvider.completedCount,
      learningProvider.sessionsCount,
    );
  }

  List<AchievementEntity> get latestAchievements {
    final sorted = List<AchievementEntity>.from(achievements);
    sorted.sort((a, b) {
      if (a.isCompleted && !b.isCompleted) return 1;
      if (!a.isCompleted && b.isCompleted) return -1;
      return b.progressPercentage.compareTo(a.progressPercentage);
    });
    return sorted.take(3).toList();
  }

  int get userLevel => learningProvider.currentLevel;

  String get userRank {
    final xp = learningProvider.totalXP;
    if (xp >= 5000) return 'Master Algoritma';
    if (xp >= 2000) return 'Elite Pro';
    if (xp >= 1000) return 'Spesialis';
    if (xp >= 500) return 'Apprentice';
    return 'Novice';
  }

  String get globalRanking {
    final xp = learningProvider.totalXP;
    if (xp >= 10000) return 'global_rank_top_1';
    if (xp >= 5000) return 'global_rank_top_5';
    if (xp >= 2000) return 'global_rank_top_10';
    return 'global_rank_top_25';
  }
}
