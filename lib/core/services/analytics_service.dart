import 'package:firebase_analytics/firebase_analytics.dart';
import '../utils/app_logger.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
      AppLogger.info('Analytics: Logged event $name with params $parameters');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log event $name', e);
    }
  }

  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      AppLogger.info('Analytics: User ID set to $userId');
    } catch (e) {
      AppLogger.error('Analytics: Failed to set user ID', e);
    }
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      AppLogger.info('Analytics: User property $name set to $value');
    } catch (e) {
      AppLogger.error('Analytics: Failed to set user property $name', e);
    }
  }

  Future<void> logLogin(String method) async {
    await logEvent(name: 'login', parameters: {'method': method});
  }

  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
    AppLogger.info('Analytics: App Opened');
  }

  Future<void> logAlgorithmStarted(String algorithmId) async {
    await logEvent(
      name: 'algo_started',
      parameters: {'algorithm_id': algorithmId},
    );
  }

  Future<void> logAlgorithmCompleted(String algorithmId) async {
    await logEvent(
      name: 'algo_completed',
      parameters: {'algorithm_id': algorithmId},
    );
  }
}
