import 'package:flutter/material.dart';
import '../../../../features/onboarding/domain/usecases/check_onboarding_status_usecase.dart';

enum SplashState { initial, loading, home, onboarding }

class SplashProvider extends ChangeNotifier {
  final CheckOnboardingStatusUseCase checkOnboardingStatusUseCase;

  SplashProvider({required this.checkOnboardingStatusUseCase});

  SplashState _state = SplashState.initial;
  SplashState get state => _state;

  Future<void> initSplash() async {
    _state = SplashState.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    final isCompleted = await checkOnboardingStatusUseCase.call();

    if (isCompleted) {
      _state = SplashState.home;
    } else {
      _state = SplashState.onboarding;
    }
    notifyListeners();
  }
}
