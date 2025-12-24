import 'package:algo_lab/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:algo_lab/features/onboarding/domain/usecases/check_onboarding_status_usecase.dart';
import 'package:algo_lab/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:algo_lab/features/onboarding/domain/usecases/reset_onboarding_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'onboarding_usecases_test.mocks.dart';

@GenerateMocks([OnboardingRepository])
void main() {
  late MockOnboardingRepository mockRepository;
  late CheckOnboardingStatusUseCase checkStatusUseCase;
  late CompleteOnboardingUseCase completeUseCase;
  late ResetOnboardingUseCase resetUseCase;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    checkStatusUseCase = CheckOnboardingStatusUseCase(mockRepository);
    completeUseCase = CompleteOnboardingUseCase(mockRepository);
    resetUseCase = ResetOnboardingUseCase(mockRepository);
  });

  group('Onboarding UseCases', () {
    test('check status should return value from repo', () async {
      when(
        mockRepository.isOnboardingCompleted(),
      ).thenAnswer((_) async => true);

      final result = await checkStatusUseCase();

      expect(result, true);
      verify(mockRepository.isOnboardingCompleted());
    });

    test('complete onboarding should call repo', () async {
      when(
        mockRepository.completeOnboarding(),
      ).thenAnswer((_) async => Future.value());

      await completeUseCase();

      verify(mockRepository.completeOnboarding());
    });

    test('reset onboarding should call repo', () async {
      when(
        mockRepository.resetOnboarding(),
      ).thenAnswer((_) async => Future.value());

      await resetUseCase();

      verify(mockRepository.resetOnboarding());
    });
  });
}
