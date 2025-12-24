import '../../../../core/config/prefs.dart';

abstract class OnboardingLocalDataSource {
  Future<void> cacheOnboarding();
  Future<void> resetOnboarding();
  Future<bool> getOnboardingStatus();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  static const String onboardingKey = 'cached_onboarding_status';

  @override
  Future<void> cacheOnboarding() async {
    await Prefs.setBool(onboardingKey, true);
  }

  @override
  Future<void> resetOnboarding() async {
    await Prefs.setBool(onboardingKey, false);
  }

  @override
  Future<bool> getOnboardingStatus() async {
    return Prefs.getBool(onboardingKey, defaultValue: false);
  }
}
