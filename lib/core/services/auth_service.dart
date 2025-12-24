import 'package:algo_lab/core/env/env.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../utils/app_logger.dart';
import '../di/service_locator.dart';
import 'analytics_service.dart';
import 'firestore_service.dart';
import 'notification_service.dart';
import '../../features/profile/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final AnalyticsService _analyticsService;
  final FirestoreService _firestoreService;

  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    AnalyticsService? analyticsService,
    FirestoreService? firestoreService,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _analyticsService = analyticsService ?? sl<AnalyticsService>(),
       _firestoreService = firestoreService ?? sl<FirestoreService>();

  bool get isPasswordAuth {
    final user = _auth.currentUser;
    if (user == null) return false;
    for (final info in user.providerData) {
      if (info.providerId == 'password') return true;
    }
    return false;
  }

  Stream<User?> get user => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(googleProvider);
      } else {
        await _googleSignIn.initialize(
          clientId: defaultTargetPlatform == TargetPlatform.android
              ? Env.androidClientId
              : Env.iosClientId,
          serverClientId: Env.webClientId,
        );

        final GoogleSignInAccount googleUser = await _googleSignIn
            .authenticate();
        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        if (googleAuth.idToken == null) {
          AppLogger.error(
            "Google Sign In Error: idToken is null. Check configuration.",
          );
          return null;
        }

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        final result = await _auth.signInWithCredential(credential);

        if (result.user != null) {
          AppLogger.info("Google Sign In Successful: ${result.user?.email}");
          _analyticsService.logLogin('google');
          await _syncUserToFirestore(result.user!);
        }
        return result;
      }
    } catch (e, stack) {
      AppLogger.error("Error in Google Sign In", e, stack);
      return null;
    }
  }

  Future<UserCredential?> signInQuickly() async {
    try {
      final deviceId = await _getDeviceId();

      final sanitizedId = deviceId.toLowerCase().replaceAll(
        RegExp(r'[^a-z0-9]'),
        '',
      );
      final email = "$sanitizedId@guest.algolab.com";
      const password = "permanent_guest_secret_99";

      UserCredential? result;
      try {
        result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
          result = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          rethrow;
        }
      }

      if (result.user != null) {
        AppLogger.info(
          "Persistent Guest Login Successful: ${result.user?.uid}",
        );
        _analyticsService.logLogin('quick_login');
        await _syncUserToFirestore(result.user!);
      }
      return result;
    } catch (e, stack) {
      AppLogger.error("Error in Quick Sign In (Persistent)", e, stack);
      return null;
    }
  }

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        return webInfo.userAgent ??
            "web_guest_${DateTime.now().millisecondsSinceEpoch}";
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ??
            "ios_guest_${DateTime.now().millisecondsSinceEpoch}";
      }
    } catch (e) {
      AppLogger.error("Error getting device ID", e);
    }
    return "unknown_device";
  }

  Future<void> signOut() async {
    try {
      final email = _auth.currentUser?.email ?? 'Anonymous';
      await _googleSignIn.signOut();
      await _auth.signOut();
      AppLogger.info("User signed out: $email");
      _analyticsService.logEvent(name: 'logout');
    } catch (e, stack) {
      AppLogger.error("Error in Sign Out", e, stack);
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestoreService.deleteUser(user.uid);

        await user.delete();
        AppLogger.info("User account deleted successfully");
      }
    } catch (e, stack) {
      AppLogger.error("Error deleting account", e, stack);
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        AppLogger.info("Password updated successfully");
      }
    } catch (e, stack) {
      AppLogger.error("Error updating password", e, stack);
      rethrow;
    }
  }

  User? get currentUser => _auth.currentUser;

  Future<void> _syncUserToFirestore(User firebaseUser) async {
    final firestoreService = _firestoreService;
    final existingUser = await firestoreService.getUser(firebaseUser.uid);

    if (existingUser != null) {
      await firestoreService.updateUserStats(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName ?? existingUser.displayName,
        photoURL: firebaseUser.photoURL ?? existingUser.photoURL,
      );
      AppLogger.info(
        "User profile updated (existing user): ${firebaseUser.uid}",
      );
    } else {
      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName:
            firebaseUser.displayName ??
            (_isGuestAccount(firebaseUser) ? "Guest" : "User"),
        photoURL: firebaseUser.photoURL,
        lastLogin: DateTime.now(),
      );
      await firestoreService.createUser(userModel);
      AppLogger.info("New user profile created: ${firebaseUser.uid}");
    }

    // Update FCM Token
    try {
      final notificationService = sl<NotificationService>();
      final token = await notificationService.getToken();
      if (token != null) {
        await firestoreService.updateFcmToken(firebaseUser.uid, token);
        AppLogger.info("FCM Token synced for user: ${firebaseUser.uid}");
      }
    } catch (e) {
      AppLogger.error("Failed to sync FCM token on login", e);
    }
  }

  bool _isGuestAccount(User user) {
    if (user.isAnonymous) return true;
    return user.email?.endsWith('@guest.algolab.com') ?? false;
  }
}
