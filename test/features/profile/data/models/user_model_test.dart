import 'package:algo_lab/features/profile/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel Tests', () {
    test('UserModel can be created with required fields', () {
      final userModel = UserModel(
        uid: 'test_uid_123',
        email: 'test@example.com',
        displayName: 'Test User',
        photoURL: 'https://example.com/photo.jpg',
        lastLogin: DateTime.now(),
        streak: 0,
        totalXP: 0,
        todayXP: 0,
        lastLearnDate: '',
      );

      expect(userModel.uid, 'test_uid_123');
      expect(userModel.email, 'test@example.com');
      expect(userModel.displayName, 'Test User');
    });

    test('UserModel handles null optional fields', () {
      final userModel = UserModel(
        uid: 'test_uid_123',
        email: null,
        displayName: 'Test User',
        photoURL: null,
        lastLogin: DateTime.now(),
        streak: 0,
        totalXP: 0,
        todayXP: 0,
        lastLearnDate: '',
      );

      expect(userModel.uid, 'test_uid_123');
      expect(userModel.email, isNull);
      expect(userModel.photoURL, isNull);
    });
  });
}
