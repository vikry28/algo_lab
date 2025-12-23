import 'package:algo_lab/core/services/auth_service.dart';
import 'package:algo_lab/core/services/firestore_service.dart';
import 'package:algo_lab/features/learning/domain/entities/learning_entity.dart';
import 'package:algo_lab/features/learning/domain/usecases/get_learning_items.dart';
import 'package:algo_lab/features/learning/presentation/provider/learning_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'learning_provider_test.mocks.dart';

@GenerateMocks([GetLearningItems, AuthService, FirestoreService, User])
void main() {
  late LearningProvider provider;
  late MockGetLearningItems mockGetLearningItems;
  late MockAuthService mockAuthService;
  late MockFirestoreService mockFirestoreService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockGetLearningItems = MockGetLearningItems();
    mockAuthService = MockAuthService();
    mockFirestoreService = MockFirestoreService();

    // Default stubs
    when(mockAuthService.user).thenAnswer((_) => Stream.value(null));
    when(mockAuthService.currentUser).thenReturn(null);
    when(mockGetLearningItems.call()).thenAnswer((_) async => []);

    provider = LearningProvider(
      getLearningItems: mockGetLearningItems,
      authService: mockAuthService,
      firestoreService: mockFirestoreService,
    );
  });

  group('LearningProvider', () {
    test('initial state is correct', () {
      expect(provider.categories, isEmpty);
      expect(provider.streak, 0);
      expect(provider.overallProgressPercentage, 0);
    });

    test('loadLearningItems populates categories', () async {
      final items = [
        LearningEntity(id: 'sort1', title: 'Bubble Sort', description: 'desc'),
        LearningEntity(id: 'sort2', title: 'Merge Sort', description: 'desc'),
        LearningEntity(id: 'graph1', title: 'DFS', description: 'desc'),
      ];
      when(mockGetLearningItems.call()).thenAnswer((_) async => items);

      await provider.loadLearningItems();

      expect(provider.categories.length, 2); // sort and graph

      final sortCat = provider.categories.firstWhere((c) => c.id == 'sort');
      expect(sortCat.items.length, 2);
    });

    test('updateProgress updates local state', () async {
      final items = [LearningEntity(id: 'sort1', title: 'Bubble Sort')];
      when(mockGetLearningItems.call()).thenAnswer((_) async => items);
      await provider.loadLearningItems();

      await provider.updateProgress('sort1', 0.5);

      expect(provider.getProgress('sort1'), 0.5);
      expect(provider.isCompleted('sort1'), false);

      await provider.updateProgress('sort1', 1.0);
      expect(provider.getProgress('sort1'), 1.0);
      expect(provider.isCompleted('sort1'), true);
    });

    test('isLocked returns correct status', () async {
      final items = [
        LearningEntity(id: 'sort1', title: 'Bubble Sort'),
        LearningEntity(id: 'sort2', title: 'Merge Sort'),
      ];
      when(mockGetLearningItems.call()).thenAnswer((_) async => items);
      await provider.loadLearningItems();

      // First item should not be locked
      expect(provider.isLocked('sort1'), false);

      // Second item should be locked initially because sort1 is not completed
      expect(provider.isLocked('sort2'), true);

      // Complete sort1
      await provider.updateProgress('sort1', 1.0);

      // Now sort2 should be unlocked
      expect(provider.isLocked('sort2'), false);
    });
  });
}
