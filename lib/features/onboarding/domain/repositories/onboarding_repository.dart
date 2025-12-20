abstract class OnboardingRepository {
  Future<void> completeOnboarding();
  Future<void> resetOnboarding();
  Future<bool> isOnboardingCompleted();
}
