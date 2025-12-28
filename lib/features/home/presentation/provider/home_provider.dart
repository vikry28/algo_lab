import 'package:flutter/material.dart';
import '../../domain/entities/algorithm_entity.dart';
import '../../domain/usecases/get_algorithms_usecase.dart';

class HomeProvider extends ChangeNotifier {
  final GetAlgorithmsUseCase getAlgorithmsUseCase;

  HomeProvider({required this.getAlgorithmsUseCase});

  List<AlgorithmEntity> _algorithms = [];
  List<AlgorithmEntity> get algorithms => _algorithms;

  List<AlgorithmEntity> _filteredAlgorithms = [];
  List<AlgorithmEntity> get filteredAlgorithms => _filteredAlgorithms;

  bool _loading = false;
  bool get loading => _loading;

  // Search and Filter State
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategory = 'all';
  String get selectedCategory => _selectedCategory;

  // Update filtered list
  void _updateFilteredAlgorithms() {
    var filtered = _algorithms;

    // Apply category filter
    if (_selectedCategory != 'all') {
      filtered = filtered.where((algo) {
        return algo.category == _selectedCategory;
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((algo) {
        final searchLower = _searchQuery.toLowerCase();
        return algo.getTitle('en').toLowerCase().contains(searchLower) ||
            algo.getDescription('en').toLowerCase().contains(searchLower);
      }).toList();
    }

    _filteredAlgorithms = filtered;
    notifyListeners();
  }

  // Update search query
  void updateSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _updateFilteredAlgorithms();
  }

  // Update selected category
  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _updateFilteredAlgorithms();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'all';
    _updateFilteredAlgorithms();
  }

  Future<void> fetchAlgorithms() async {
    _loading = true;
    notifyListeners();

    try {
      _algorithms = await getAlgorithmsUseCase();
      _filteredAlgorithms = _algorithms;
    } catch (e) {
      // Handle error if needed
      _algorithms = [];
      _filteredAlgorithms = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
