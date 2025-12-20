import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/profile/data/models/user_model.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<void> createUser(UserModel user) async {
    try {
      await _db
          .collection('users')
          .doc(user.uid)
          .set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      _logger.e("Error creating user: $e");
      rethrow;
    }
  }

  Future<void> syncUserProfile(UserModel user) async {
    try {
      final data = user.toMap();
      data['lastLogin'] = FieldValue.serverTimestamp();
      await _db
          .collection('users')
          .doc(user.uid)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      _logger.e("Error syncing user profile: $e");
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      _logger.e("Error getting user: $e");
      return null;
    }
  }

  Future<void> updateUserStats({
    required String uid,
    String? email,
    String? displayName,
    String? photoURL,
    int? streak,
    int? totalXP,
    int? todayXP,
    String? lastLearnDate,
    int? lastLearnTimestamp,
    String? lastLearnedModuleId,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (email != null) data['email'] = email;
      if (displayName != null) data['displayName'] = displayName;
      if (photoURL != null) data['photoURL'] = photoURL;
      if (streak != null) data['streak'] = streak;
      if (totalXP != null) data['totalXP'] = totalXP;
      if (todayXP != null) data['todayXP'] = todayXP;
      if (lastLearnDate != null) data['lastLearnDate'] = lastLearnDate;
      if (lastLearnTimestamp != null) {
        data['lastLearnTimestamp'] = lastLearnTimestamp;
      }
      if (lastLearnedModuleId != null) {
        data['lastLearnedModuleId'] = lastLearnedModuleId;
      }
      data['lastLogin'] = FieldValue.serverTimestamp();

      await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      _logger.e("Error updating user stats: $e");
    }
  }

  Future<void> updateFcmToken(String uid, String token) async {
    try {
      await _db.collection('users').doc(uid).set({
        'fcmToken': token,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      _logger.e("Error updating FCM token: $e");
    }
  }

  Future<void> updateProgress(String uid, UserProgressModel progress) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc(progress.moduleId)
          .set(progress.toMap(), SetOptions(merge: true));
    } catch (e) {
      _logger.e("Error updating progress: $e");
    }
  }

  Future<List<UserProgressModel>> getAllProgress(String uid) async {
    try {
      final querySnapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('progress')
          .get();
      return querySnapshot.docs
          .map((doc) => UserProgressModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      _logger.e("Error getting all progress: $e");
      return [];
    }
  }

  Stream<List<UserProgressModel>> progressStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('progress')
        .snapshots()
        .map(
          (qs) => qs.docs
              .map((doc) => UserProgressModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addCompletedAchievement(String uid, String achievementId) async {
    try {
      await _db.collection('users').doc(uid).set({
        'completedAchievements': FieldValue.arrayUnion([achievementId]),
      }, SetOptions(merge: true));
    } catch (e) {
      _logger.e('Error adding completed achievement: $e');
      rethrow;
    }
  }

  Future<void> addBadgeToUser(String uid, String badgeId) async {
    try {
      await _db.collection('users').doc(uid).set({
        'badges': FieldValue.arrayUnion([badgeId]),
      }, SetOptions(merge: true));
    } catch (e) {
      _logger.e('Error adding badge to user: $e');
      rethrow;
    }
  }

  Future<void> addCompletedModule(String uid, String moduleId) async {
    try {
      await _db.collection('users').doc(uid).set({
        'completedModules': FieldValue.arrayUnion([moduleId]),
      }, SetOptions(merge: true));
    } catch (e) {
      _logger.e('Error adding completed module: $e');
      rethrow;
    }
  }

  Stream<UserModel?> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _db.collection('users').doc(uid).delete();
      _logger.i("User document deleted from Firestore: $uid");
    } catch (e) {
      _logger.e("Error deleting user from Firestore: $e");
      rethrow;
    }
  }
}
