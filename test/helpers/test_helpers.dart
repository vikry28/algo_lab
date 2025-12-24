import 'package:flutter_test/flutter_test.dart';

/// Test helper utilities for Algo Lab tests
class TestHelpers {
  /// Creates a matcher for checking if a list is sorted in ascending order
  static Matcher isSortedAscending() {
    return predicate<List<int>>((list) {
      for (int i = 0; i < list.length - 1; i++) {
        if (list[i] > list[i + 1]) return false;
      }
      return true;
    }, 'is sorted in ascending order');
  }

  /// Creates a matcher for checking if a list is sorted in descending order
  static Matcher isSortedDescending() {
    return predicate<List<int>>((list) {
      for (int i = 0; i < list.length - 1; i++) {
        if (list[i] < list[i + 1]) return false;
      }
      return true;
    }, 'is sorted in descending order');
  }

  /// Generates a random array of integers
  static List<int> generateRandomArray(int size, {int max = 100}) {
    return List.generate(size, (index) => index % max);
  }

  /// Generates a reverse sorted array
  static List<int> generateReverseSortedArray(int size) {
    return List.generate(size, (index) => size - index);
  }

  /// Generates an already sorted array
  static List<int> generateSortedArray(int size) {
    return List.generate(size, (index) => index);
  }

  /// Generates an array with all same values
  static List<int> generateUniformArray(int size, int value) {
    return List.filled(size, value);
  }

  /// Checks if two arrays have the same elements (ignoring order)
  static bool haveSameElements(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    final sortedA = List<int>.from(a)..sort();
    final sortedB = List<int>.from(b)..sort();
    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }
}

/// Mock data for testing
class MockData {
  static const smallArray = [3, 1, 4, 1, 5, 9, 2, 6];
  static const sortedArray = [1, 2, 3, 4, 5];
  static const reverseSortedArray = [5, 4, 3, 2, 1];
  static const duplicatesArray = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3];
  static const singleElement = [42];
  static const twoElements = [2, 1];
  static const emptyArray = <int>[];

  static const sampleMessages = [
    'HELLO',
    'WORLD',
    'TEST',
    'A',
    'AB',
    'ALGORITHM',
  ];

  static const learningModuleIds = [
    'sort1',
    'sort2',
    'sort3',
    'sort4',
    'graph1',
    'graph2',
    'search1',
    'crypto1',
  ];
}
