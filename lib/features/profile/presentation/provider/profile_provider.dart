import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../../../learning/presentation/provider/learning_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final WatchProfileUseCase watchProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final AuthService authService;
  final NotificationService notificationService;
  final LocalAuthentication _localAuth = LocalAuthentication();

  ProfileEntity? _profile;
  ProfileEntity? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get canChangePassword => authService.isPasswordAuth;

  bool get notificationsEnabled => notificationService.getNotificationStatus();

  StreamSubscription? _profileSubscription;
  LearningProvider? _learningProvider;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.watchProfileUseCase,
    required this.updateProfileUseCase,
    required this.authService,
    required this.notificationService,
  }) {
    _init();
  }

  Future<void> toggleNotifications(bool enabled) async {
    await notificationService.setNotificationStatus(enabled);
    notifyListeners();
  }

  void setLearningProvider(LearningProvider provider) {
    _learningProvider = provider;
  }

  void _init() {
    final user = authService.currentUser;
    if (user != null) {
      _startWatchingProfile(user.uid);
    }

    // Auth state listener to restart watching if user changes
    authService.user.listen((user) {
      if (user != null) {
        _startWatchingProfile(user.uid);
      } else {
        _profileSubscription?.cancel();
        _profile = null;
        notifyListeners();
      }
    });
  }

  void _startWatchingProfile(String uid) {
    _profileSubscription?.cancel();
    _profileSubscription = watchProfileUseCase(uid).listen((profile) {
      _profile = profile;
      if (profile != null && _learningProvider != null) {
        // We could sync back to LearningProvider if Firestore is newer,
        // but LearningProvider already does its own sync in _loadAllProgress.
        // For XP/Streak specifically, they should be driven by LearningProvider.
      }
      notifyListeners();
    });
  }

  Future<void> updateDisplayName(String name) async {
    if (_profile == null) return;
    _updateProfile(_profile!.copyWith(displayName: name));
  }

  Future<void> updateTwoFactor(bool enabled) async {
    if (_profile == null) return;
    _updateProfile(_profile!.copyWith(twoFactorEnabled: enabled));
  }

  Future<void> updateBiometric(bool enabled) async {
    if (_profile == null) return;
    _updateProfile(_profile!.copyWith(biometricEnabled: enabled));
  }

  Future<void> updatePhotoURL(String url) async {
    if (_profile == null) return;
    _updateProfile(_profile!.copyWith(photoURL: url));
  }

  Future<void> changePassword(String newPassword) async {
    await authService.updatePassword(newPassword);
  }

  Future<void> deleteAccount() async {
    await authService.deleteAccount();
  }

  Future<void> addXp(int amount) async {
    if (_learningProvider != null) {
      await _learningProvider!.addXP(amount);
    }
  }

  Future<void> updateStreak(int streak) async {
    // Streak is now managed by LearningProvider
    if (_learningProvider != null) {
      // Currently LearningProvider manages streak via _updateActivityStats
    }
  }

  Future<void> completeAchievement(String achievementId) async {
    if (_profile == null) return;
    if (_profile!.completedAchievements.contains(achievementId)) return;

    final newList = List<String>.from(_profile!.completedAchievements)
      ..add(achievementId);
    await updateProfileUseCase(
      _profile!.copyWith(completedAchievements: newList),
    );
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canAuthenticateWithBiometrics && !isDeviceSupported) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to change security settings',
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> _updateProfile(ProfileEntity updatedProfile) async {
    _isLoading = true;
    notifyListeners();
    try {
      await updateProfileUseCase(updatedProfile);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }
}
