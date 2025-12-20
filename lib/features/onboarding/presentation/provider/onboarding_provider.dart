import 'package:flutter/material.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';
import '../../../../core/services/auth_service.dart';

class OnboardingProvider extends ChangeNotifier {
  final CompleteOnboardingUseCase completeOnboardingUseCase;
  final AuthService authService;

  bool _isGoogleLoading = false;
  bool get isGoogleLoading => _isGoogleLoading;

  bool _isQuickLoading = false;
  bool get isQuickLoading => _isQuickLoading;

  bool get isLoggingIn => _isGoogleLoading || _isQuickLoading;

  OnboardingProvider({
    required this.completeOnboardingUseCase,
    required this.authService,
  });

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final PageController pageController = PageController();

  void setPage(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentIndex < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void previousPage() {
    if (_currentIndex > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void skipToLastPage() {
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuart,
    );
  }

  Future<void> skipOrComplete() async {
    await completeOnboardingUseCase.call();
  }

  Future<bool> googleLogin() async {
    _isGoogleLoading = true;
    notifyListeners();
    try {
      final user = await authService.signInWithGoogle();
      if (user != null) {
        await skipOrComplete();
        return true;
      }
      return false;
    } finally {
      _isGoogleLoading = false;
      notifyListeners();
    }
  }

  Future<bool> quickLogin() async {
    _isQuickLoading = true;
    notifyListeners();
    try {
      final user = await authService.signInQuickly();
      if (user != null) {
        await skipOrComplete();
        return true;
      }
      return false;
    } finally {
      _isQuickLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
