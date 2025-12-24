import 'package:flutter/material.dart';
import '../../../../features/onboarding/domain/usecases/check_onboarding_status_usecase.dart';
import '../../../../core/services/auth_service.dart';
import '../../../profile/domain/usecases/profile_usecases.dart';
import 'package:local_auth/local_auth.dart';

enum SplashState { initial, loading, authenticating, home, onboarding }

class SplashProvider extends ChangeNotifier {
  final CheckOnboardingStatusUseCase checkOnboardingStatusUseCase;
  final AuthService authService;
  final GetProfileUseCase getProfileUseCase;
  final LocalAuthentication _localAuth = LocalAuthentication();

  SplashProvider({
    required this.checkOnboardingStatusUseCase,
    required this.authService,
    required this.getProfileUseCase,
  });

  SplashState _state = SplashState.initial;
  SplashState get state => _state;

  Future<void> initSplash() async {
    _state = SplashState.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    final isCompleted = await checkOnboardingStatusUseCase.call();

    if (isCompleted) {
      final user = authService.currentUser;
      if (user != null) {
        // Check security settings
        final profile = await getProfileUseCase(user.uid);
        if (profile != null && profile.biometricEnabled) {
          _state = SplashState.authenticating;
          notifyListeners();

          final authenticated = await _authenticate();
          if (authenticated) {
            _state = SplashState.home;
          } else {
            // If failed, we could stay on authenticating or handle it
            // For now, let's assume if it fails it stays on splash/loading
            return;
          }
        } else {
          _state = SplashState.home;
        }
      } else {
        _state = SplashState.onboarding;
      }
    } else {
      _state = SplashState.onboarding;
    }
    notifyListeners();
  }

  Future<bool> _authenticate() async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isSupported = await _localAuth.isDeviceSupported();

      if (!canCheck && !isSupported) return true; // Fail safe

      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to unlock Algo Lab',
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );
    } catch (e) {
      return false;
    }
  }
}
