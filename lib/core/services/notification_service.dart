import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config/prefs.dart';
import '../utils/app_logger.dart';
import '../constants/app_localizations.dart';
import '../di/service_locator.dart';
import 'firestore_service.dart';
import 'auth_service.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static GlobalKey<NavigatorState>? navigatorKey;

  void Function(String?)? onNotificationClick;

  Future<void> init() async {
    final bool isEnabled = getNotificationStatus();
    if (!isEnabled) {
      AppLogger.info('Notifications are disabled by user');
      return;
    }

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      AppLogger.info('User granted permission for notifications');
    }

    // Setup for Android Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'algolab_high_importance_channel',
      'AlgoLab High Importance Notifications',
      description:
          'This channel is used for important algorithm notifications.',
      importance: Importance.max,
    );

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        AppLogger.info('Notification clicked: ${details.payload}');
        try {
          onNotificationClick?.call(details.payload);
        } catch (e) {
          AppLogger.error('Error in onNotificationClick', e);
        }
      },
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.createNotificationChannel(channel);
      await androidPlugin?.requestNotificationsPermission();
    }

    // Listeners
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.info(
        'Foreground message received: ${message.notification?.title}',
      );
      if (getNotificationStatus()) {
        _showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.info('App opened from notification: ${message.data}');
      onNotificationClick?.call(
        message.data['payload'] ?? message.data.toString(),
      );
    });

    // Initial message
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        AppLogger.info('App started from terminated state via notification');
        onNotificationClick?.call(
          message.data['payload'] ?? message.data.toString(),
        );
      }
    });

    // Token Refresh logic
    _messaging.onTokenRefresh.listen((newToken) {
      _updateTokenInFirestore(newToken);
    });
  }

  Future<void> _updateTokenInFirestore(String token) async {
    final firestore = sl<FirestoreService>();
    final auth = sl<AuthService>();
    final user = auth.currentUser;
    if (user != null) {
      await firestore.updateFcmToken(user.uid, token);
      AppLogger.info('FCM Token updated in Firestore on refresh');
    }
  }

  bool getNotificationStatus() {
    return Prefs.getBool('notifications_enabled', defaultValue: true);
  }

  Future<void> setNotificationStatus(bool enabled) async {
    await Prefs.setBool('notifications_enabled', enabled);
    if (enabled) {
      await init();
    } else {
      AppLogger.info('Notifications disabled');
    }
  }

  Future<String?> getToken() async {
    try {
      if (kIsWeb) return null;
      final token = await _messaging.getToken();
      if (kDebugMode) {
        AppLogger.info('--- FCM DEBUG INFO ---');
        AppLogger.info('FCM Token: $token');
        AppLogger.info('----------------------');
      }
      return token;
    } catch (e) {
      AppLogger.error(
        'CRITICAL: FCM Token retrieval failed. This is usually due to missing SHA-1 in Firebase Console.',
        e,
      );
      return null;
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'algolab_high_importance_channel',
          'AlgoLab Notifications',
          channelDescription: 'Algorithm learning updates and reminders',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notification = message.notification;
    if (notification == null) return;

    String title = notification.title ?? '';
    String body = notification.body ?? '';

    final titleKey = message.data['title_loc_key'];
    final bodyKey = message.data['body_loc_key'];

    if (titleKey != null || bodyKey != null) {
      final context = navigatorKey?.currentContext;
      if (context != null) {
        final l10n = AppLocalizations.of(context);
        if (titleKey != null) title = l10n.translate(titleKey);
        if (bodyKey != null) body = l10n.translate(bodyKey);
      }
    }

    await _localNotifications.show(
      notification.hashCode,
      title,
      body,
      details,
      payload: message.data.toString(),
    );
  }

  Future<void> showBadgeNotification(
    String titleKey,
    String bodyKey, {
    String? payload,
    Map<String, String>? arguments,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'algolab_high_importance_channel',
          'AlgoLab Notifications',
          channelDescription: 'Algorithm learning updates and reminders',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String title = titleKey;
    String body = bodyKey;

    final context = navigatorKey?.currentContext;
    if (context != null) {
      final l10n = AppLocalizations.of(context);
      title = l10n.translate(titleKey);
      body = l10n.translate(bodyKey);

      if (arguments != null) {
        arguments.forEach((key, value) {
          String translatedValue = l10n.translate(value);
          body = body.replaceAll('{$key}', translatedValue);
          title = title.replaceAll('{$key}', translatedValue);
        });
      }
    }

    await _localNotifications.show(
      title.hashCode,
      title,
      body,
      details,
      payload: payload,
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.info('Background message: ${message.messageId}');
}
