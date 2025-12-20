import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/profile_entity.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final int streak;
  final int totalXP;
  final int todayXP;
  final String lastLearnDate;
  final DateTime? lastLogin;
  final bool twoFactorEnabled;
  final bool biometricEnabled;
  final int level;
  final String rank;
  final int lastLearnTimestamp;
  final String? lastLearnedModuleId;
  final List<String> completedAchievements;
  final List<String> badges;
  final List<String> completedModules;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.streak = 0,
    this.totalXP = 0,
    this.todayXP = 0,
    this.lastLearnDate = "",
    this.lastLogin,
    this.twoFactorEnabled = false,
    this.biometricEnabled = true,
    this.level = 1,
    this.rank = "Novice",
    this.lastLearnTimestamp = 0,
    this.lastLearnedModuleId,
    this.completedAchievements = const [],
    this.badges = const [],
    this.completedModules = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      streak: map['streak'] ?? 0,
      totalXP: map['totalXP'] ?? 0,
      todayXP: map['todayXP'] ?? 0,
      lastLearnDate: map['lastLearnDate'] ?? "",
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate(),
      twoFactorEnabled: map['twoFactorEnabled'] ?? false,
      biometricEnabled: map['biometricEnabled'] ?? true,
      level: map['level'] ?? 1,
      rank: map['rank'] ?? "Novice",
      lastLearnTimestamp: map['lastLearnTimestamp'] ?? 0,
      lastLearnedModuleId: map['lastLearnedModuleId'],
      completedAchievements: List<String>.from(
        map['completedAchievements'] ?? [],
      ),
      badges: List<String>.from(map['badges'] ?? []),
      completedModules: List<String>.from(map['completedModules'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'streak': streak,
      'totalXP': totalXP,
      'todayXP': todayXP,
      'lastLearnDate': lastLearnDate,
      'lastLogin': lastLogin != null
          ? Timestamp.fromDate(lastLogin!)
          : FieldValue.serverTimestamp(),
      'twoFactorEnabled': twoFactorEnabled,
      'biometricEnabled': biometricEnabled,
      'level': level,
      'rank': rank,
      'lastLearnTimestamp': lastLearnTimestamp,
      'lastLearnedModuleId': lastLearnedModuleId,
      'completedAchievements': completedAchievements,
      'badges': badges,
      'completedModules': completedModules,
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      streak: streak,
      totalXP: totalXP,
      todayXP: todayXP,
      lastLearnDate: lastLearnDate,
      lastLogin: lastLogin,
      twoFactorEnabled: twoFactorEnabled,
      biometricEnabled: biometricEnabled,
      level: level,
      rank: rank,
      lastLearnTimestamp: lastLearnTimestamp,
      lastLearnedModuleId: lastLearnedModuleId,
      completedAchievements: completedAchievements,
      badges: badges,
      completedModules: completedModules,
    );
  }

  factory UserModel.fromEntity(ProfileEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      streak: entity.streak,
      totalXP: entity.totalXP,
      todayXP: entity.todayXP,
      lastLearnDate: entity.lastLearnDate,
      lastLogin: entity.lastLogin,
      twoFactorEnabled: entity.twoFactorEnabled,
      biometricEnabled: entity.biometricEnabled,
      level: entity.level,
      rank: entity.rank,
      lastLearnTimestamp: entity.lastLearnTimestamp,
      lastLearnedModuleId: entity.lastLearnedModuleId,
      completedAchievements: entity.completedAchievements,
      badges: entity.badges,
      completedModules: entity.completedModules,
    );
  }
}

class UserProgressModel {
  final String moduleId;
  final double progress;
  final bool completed;
  final DateTime lastUpdated;

  UserProgressModel({
    required this.moduleId,
    required this.progress,
    required this.completed,
    required this.lastUpdated,
  });

  factory UserProgressModel.fromMap(Map<String, dynamic> map, String id) {
    return UserProgressModel(
      moduleId: id,
      progress: (map['progress'] ?? 0.0).toDouble(),
      completed: map['completed'] ?? false,
      lastUpdated:
          (map['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'progress': progress,
      'completed': completed,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
