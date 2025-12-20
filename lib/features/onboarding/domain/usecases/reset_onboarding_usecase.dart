import '../repositories/onboarding_repository.dart';

class ResetOnboardingUseCase {
  final OnboardingRepository repository;

  ResetOnboardingUseCase(this.repository);

  Future<void> call() async {
    return repository.resetOnboarding();
  }
}
