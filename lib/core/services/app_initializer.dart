import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import '../di/service_locator.dart';
import 'notification_service.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import '../services/analytics_service.dart';
import '../config/prefs.dart';

class AppInitializer {
  static Future<void> setup() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize local prefs
    await Prefs.init();

    // Setup service locator
    await ServiceLocator.init();

    // Initialize notification service
    final notificationService = sl<NotificationService>();
    await notificationService.init();

    // Sync FCM token if user logged in
    final auth = sl<AuthService>();
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      final token = await notificationService.getToken();
      if (token != null) {
        await sl<FirestoreService>().updateFcmToken(currentUser.uid, token);
      }
    }

    // Log app open
    final analytics = sl<AnalyticsService>();
    await analytics.logAppOpen();
  }
}
