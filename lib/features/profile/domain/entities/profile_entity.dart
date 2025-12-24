class ProfileEntity {
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

  ProfileEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    required this.streak,
    required this.totalXP,
    required this.todayXP,
    required this.lastLearnDate,
    this.lastLogin,
    this.twoFactorEnabled = false,
    this.biometricEnabled = false,
    this.level = 1,
    this.rank = "Novice",
    this.lastLearnTimestamp = 0,
    this.lastLearnedModuleId,
    this.completedAchievements = const [],
    this.badges = const [],
    this.completedModules = const [],
  });

  ProfileEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    int? streak,
    int? totalXP,
    int? todayXP,
    String? lastLearnDate,
    DateTime? lastLogin,
    bool? twoFactorEnabled,
    bool? biometricEnabled,
    int? level,
    String? rank,
    int? lastLearnTimestamp,
    String? lastLearnedModuleId,
    List<String>? completedAchievements,
    List<String>? badges,
    List<String>? completedModules,
  }) {
    return ProfileEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      streak: streak ?? this.streak,
      totalXP: totalXP ?? this.totalXP,
      todayXP: todayXP ?? this.todayXP,
      lastLearnDate: lastLearnDate ?? this.lastLearnDate,
      lastLogin: lastLogin ?? this.lastLogin,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      level: level ?? this.level,
      rank: rank ?? this.rank,
      lastLearnTimestamp: lastLearnTimestamp ?? this.lastLearnTimestamp,
      lastLearnedModuleId: lastLearnedModuleId ?? this.lastLearnedModuleId,
      completedAchievements:
          completedAchievements ?? this.completedAchievements,
      badges: badges ?? this.badges,
      completedModules: completedModules ?? this.completedModules,
    );
  }
}
