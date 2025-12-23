import 'package:algo_lab/core/services/analytics_service.dart';
import 'package:algo_lab/core/services/auth_service.dart';
import 'package:algo_lab/core/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  GoogleSignIn,
  UserCredential,
  User,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  AnalyticsService,
  FirestoreService,
])
void main() {
  late AuthService authService;
  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockAnalyticsService mockAnalyticsService;
  late MockFirestoreService mockFirestoreService;
  late MockUser mockUser;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockAnalyticsService = MockAnalyticsService();
    mockFirestoreService = MockFirestoreService();
    mockUser = MockUser();

    authService = AuthService(
      firebaseAuth: mockAuth,
      googleSignIn: mockGoogleSignIn,
      analyticsService: mockAnalyticsService,
      firestoreService: mockFirestoreService,
    );
  });

  group('AuthService Tests', () {
    test('isPasswordAuth returns true if provider is password', () {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(
        mockUser.providerData,
      ).thenReturn([FakeUserInfo(providerId: 'password', uid: '123')]);
      expect(authService.isPasswordAuth, true);
    });

    test('isPasswordAuth returns false if user is null', () {
      when(mockAuth.currentUser).thenReturn(null);
      expect(authService.isPasswordAuth, false);
    });

    test('signOut calls signOut on dependencies', () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.email).thenReturn('test@example.com');

      await authService.signOut();

      verify(mockGoogleSignIn.signOut()).called(1);
      verify(mockAuth.signOut()).called(1);
      verify(mockAnalyticsService.logEvent(name: 'logout')).called(1);
    });

    test('deleteAccount deletes from firestore and auth', () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('uid123');

      await authService.deleteAccount();

      verify(mockFirestoreService.deleteUser('uid123')).called(1);
      verify(mockUser.delete()).called(1);
    });
  });
}

class FakeUserInfo extends Fake implements UserInfo {
  @override
  final String providerId;

  @override
  final String uid;

  FakeUserInfo({required this.providerId, required this.uid});
}
