import 'package:algo_lab/features/home/domain/entities/algorithm_entity.dart';
import 'package:algo_lab/features/home/domain/usecases/get_algorithms_usecase.dart';
import 'package:algo_lab/features/home/presentation/provider/home_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_provider_test.mocks.dart';

@GenerateMocks([GetAlgorithmsUseCase])
void main() {
  late HomeProvider homeProvider;
  late MockGetAlgorithmsUseCase mockGetAlgorithmsUseCase;

  setUp(() {
    mockGetAlgorithmsUseCase = MockGetAlgorithmsUseCase();
    homeProvider = HomeProvider(getAlgorithmsUseCase: mockGetAlgorithmsUseCase);
  });

  tearDown(() {
    homeProvider.dispose();
  });

  group('HomeProvider - Initialization', () {
    test('initial state is correct', () {
      expect(homeProvider.algorithms, isEmpty);
      expect(homeProvider.filteredAlgorithms, isEmpty);
      expect(homeProvider.loading, false);
      expect(homeProvider.searchQuery, '');
      expect(homeProvider.selectedCategory, 'all');
    });
  });

  group('HomeProvider - Fetch Algorithms', () {
    final mockAlgorithms = [
      AlgorithmEntity(
        titleKey: 'bubble_sort',
        descriptionKey: 'bubble_sort_desc',
        title: {'en': 'Bubble Sort', 'id': 'Bubble Sort'},
        description: {'en': 'Sorting algorithm', 'id': 'Algoritma sorting'},
        icon: '🫧',
        colorHex: '#8B5CF6',
      ),
      AlgorithmEntity(
        titleKey: 'dijkstra',
        descriptionKey: 'dijkstra_desc',
        title: {'en': 'Dijkstra', 'id': 'Dijkstra'},
        description: {'en': 'Graph algorithm', 'id': 'Algoritma graph'},
        icon: '🗺️',
        colorHex: '#F97316',
      ),
    ];

    test('fetchAlgorithms successfully loads algorithms', () async {
      when(mockGetAlgorithmsUseCase()).thenAnswer((_) async => mockAlgorithms);

      await homeProvider.fetchAlgorithms();

      expect(homeProvider.algorithms.length, 2);
      expect(homeProvider.filteredAlgorithms.length, 2);
      expect(homeProvider.loading, false);
      verify(mockGetAlgorithmsUseCase()).called(1);
    });

    test('fetchAlgorithms sets loading state correctly', () async {
      when(mockGetAlgorithmsUseCase()).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 100),
          () => mockAlgorithms,
        ),
      );

      final future = homeProvider.fetchAlgorithms();
      expect(homeProvider.loading, true);

      await future;
      expect(homeProvider.loading, false);
    });

    test('fetchAlgorithms handles errors gracefully', () async {
      when(mockGetAlgorithmsUseCase()).thenThrow(Exception('Failed to load'));

      await homeProvider.fetchAlgorithms();

      expect(homeProvider.algorithms, isEmpty);
      expect(homeProvider.filteredAlgorithms, isEmpty);
      expect(homeProvider.loading, false);
    });
  });

  group('HomeProvider - Search Functionality', () {
    final mockAlgorithms = [
      AlgorithmEntity(
        titleKey: 'bubble_sort',
        descriptionKey: 'bubble_sort_desc',
        title: {'en': 'Bubble Sort', 'id': 'Bubble Sort'},
        description: {'en': 'Sorting algorithm', 'id': 'Algoritma sorting'},
        icon: '🫧',
        colorHex: '#8B5CF6',
      ),
      AlgorithmEntity(
        titleKey: 'binary_search',
        descriptionKey: 'binary_search_desc',
        title: {'en': 'Binary Search', 'id': 'Binary Search'},
        description: {'en': 'Search algorithm', 'id': 'Algoritma search'},
        icon: '🔍',
        colorHex: '#3B82F6',
      ),
    ];

    setUp(() async {
      when(mockGetAlgorithmsUseCase()).thenAnswer((_) async => mockAlgorithms);
      await homeProvider.fetchAlgorithms();
    });

    test('updateSearchQuery filters algorithms correctly', () {
      homeProvider.updateSearchQuery('bubble');

      expect(homeProvider.searchQuery, 'bubble');
      expect(homeProvider.filteredAlgorithms.length, greaterThan(0));
    });

    test('updateSearchQuery is case insensitive', () {
      homeProvider.updateSearchQuery('BUBBLE');

      expect(homeProvider.filteredAlgorithms.length, greaterThan(0));
    });

    test('updateSearchQuery with empty string shows all', () {
      homeProvider.updateSearchQuery('bubble');
      homeProvider.updateSearchQuery('');

      expect(homeProvider.filteredAlgorithms.length, 2);
    });

    test('updateSearchQuery does not notify if query is same', () {
      var notifyCount = 0;
      homeProvider.addListener(() => notifyCount++);

      homeProvider.updateSearchQuery('test');
      homeProvider.updateSearchQuery('test');

      expect(notifyCount, 1); // Only notified once
    });
  });

  group('HomeProvider - Category Filter', () {
    final mockAlgorithms = [
      AlgorithmEntity(
        titleKey: 'bubble_sort',
        descriptionKey: 'bubble_sort_desc',
        title: {'en': 'Bubble Sort', 'id': 'Bubble Sort'},
        description: {'en': 'Sorting algorithm', 'id': 'Algoritma sorting'},
        icon: '🫧',
        colorHex: '#8B5CF6',
      ),
      AlgorithmEntity(
        titleKey: 'dijkstra',
        descriptionKey: 'dijkstra_desc',
        title: {'en': 'Dijkstra', 'id': 'Dijkstra'},
        description: {'en': 'Graph algorithm', 'id': 'Algoritma graph'},
        icon: '🗺️',
        colorHex: '#F97316',
      ),
    ];

    setUp(() async {
      when(mockGetAlgorithmsUseCase()).thenAnswer((_) async => mockAlgorithms);
      await homeProvider.fetchAlgorithms();
    });

    test('selectCategory filters by sorting', () {
      homeProvider.selectCategory('sorting');

      expect(homeProvider.selectedCategory, 'sorting');
      expect(homeProvider.filteredAlgorithms.length, greaterThan(0));
    });

    test('selectCategory filters by graph', () {
      homeProvider.selectCategory('graph');

      expect(homeProvider.selectedCategory, 'graph');
      expect(homeProvider.filteredAlgorithms.length, greaterThan(0));
    });

    test('selectCategory does not notify if category is same', () {
      var notifyCount = 0;
      homeProvider.addListener(() => notifyCount++);

      homeProvider.selectCategory('sorting');
      homeProvider.selectCategory('sorting');

      expect(notifyCount, 1);
    });
  });

  group('HomeProvider - Clear Filters', () {
    setUp(() async {
      when(mockGetAlgorithmsUseCase()).thenAnswer(
        (_) async => [
          AlgorithmEntity(
            titleKey: 'test',
            descriptionKey: 'test_desc',
            title: {'en': 'Test', 'id': 'Test'},
            description: {'en': 'Test algorithm', 'id': 'Algoritma test'},
            icon: '🔍',
            colorHex: '#000000',
          ),
        ],
      );
      await homeProvider.fetchAlgorithms();
    });

    test('clearFilters resets search and category', () {
      homeProvider.updateSearchQuery('test');
      homeProvider.selectCategory('sorting');

      homeProvider.clearFilters();

      expect(homeProvider.searchQuery, '');
      expect(homeProvider.selectedCategory, 'all');
    });
  });
}
