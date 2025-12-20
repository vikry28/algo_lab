import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<void> completeOnboarding() async {
    await localDataSource.cacheOnboarding();
  }

  @override
  Future<void> resetOnboarding() async {
    await localDataSource.resetOnboarding();
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return localDataSource.getOnboardingStatus();
  }
}
