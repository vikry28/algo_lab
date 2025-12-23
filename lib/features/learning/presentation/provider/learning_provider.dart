import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_icons.dart';
import '../../domain/entities/learning_category_entity.dart';
import '../../domain/entities/learning_entity.dart';
import '../../domain/usecases/get_learning_items.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../profile/data/models/user_model.dart';
import '../../../../core/di/service_locator.dart';

class LearningProvider extends ChangeNotifier {
  final GetLearningItems getLearningItems;
  final Logger _logger = Logger();

  StreamSubscription? _userStreamSubscription;
  StreamSubscription? _progressStreamSubscription;
  StreamSubscription? _authSubscription;

  LearningProvider({required this.getLearningItems}) {
    _init();
  }

  void _init() {
    _authSubscription = sl<AuthService>().user.listen((user) {
      if (user != null) {
        _loadAllProgress();
        _startWatchingFirestoreStreams(user.uid);
      } else {
        _userStreamSubscription?.cancel();
        _progressStreamSubscription?.cancel();
      }
    });
  }

  void _startWatchingFirestoreStreams(String uid) {
    _userStreamSubscription?.cancel();
    _progressStreamSubscription?.cancel();

    final firestore = sl<FirestoreService>();

    _userStreamSubscription = firestore.userStream(uid).listen((
      userModel,
    ) async {
      if (userModel == null) return;
      try {
        final prefs = await SharedPreferences.getInstance();
        bool changed = false;
        if (userModel.totalXP != _totalXP && userModel.totalXP > _totalXP) {
          _totalXP = userModel.totalXP;
          await prefs.setInt('user_total_xp', _totalXP);
          changed = true;
        }
        if (userModel.streak != _streak && userModel.streak >= 0) {
          _streak = userModel.streak;
          await prefs.setInt('user_streak', _streak);
          changed = true;
        }
        if (userModel.todayXP != _todayXP) {
          _todayXP = userModel.todayXP;
          await prefs.setInt('user_today_xp', _todayXP);
          changed = true;
        }
        if (userModel.lastLearnTimestamp != _lastLearnTimestamp &&
            userModel.lastLearnTimestamp > _lastLearnTimestamp) {
          _lastLearnTimestamp = userModel.lastLearnTimestamp;
          await prefs.setInt('user_last_learn_timestamp', _lastLearnTimestamp);
          changed = true;
        }
        if (userModel.lastLearnedModuleId != null &&
            userModel.lastLearnedModuleId != _lastLearnedModuleId) {
          _lastLearnedModuleId = userModel.lastLearnedModuleId;
          await prefs.setString(
            'user_last_learned_module_id',
            _lastLearnedModuleId!,
          );
          changed = true;
        }

        if (changed) notifyListeners();
      } catch (e) {
        _logger.e('Error applying user stream update: $e');
      }
    });

    _progressStreamSubscription = firestore.progressStream(uid).listen((
      progressList,
    ) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        bool changed = false;
        DateTime? latestSync;
        for (var p in progressList) {
          final localP = _progressMap[p.moduleId] ?? 0.0;
          if (p.progress > localP) {
            _progressMap[p.moduleId] = p.progress;
            _completedMap[p.moduleId] = p.completed;
            await prefs.setDouble('${p.moduleId}_progress', p.progress);
            await prefs.setBool('${p.moduleId}_completed', p.completed);
            changed = true;
          }
          if (latestSync == null || p.lastUpdated.isAfter(latestSync)) {
            latestSync = p.lastUpdated;
          }
        }

        if (latestSync != null &&
            latestSync.millisecondsSinceEpoch > _lastLearnTimestamp) {
          _lastLearnTimestamp = latestSync.millisecondsSinceEpoch;
          await prefs.setInt('user_last_learn_timestamp', _lastLearnTimestamp);
          changed = true;
        }

        if (changed) notifyListeners();
      } catch (e) {
        _logger.e('Error applying progress stream update: $e');
      }
    });
  }

  List<LearningCategoryEntity> _categories = [];
  List<LearningCategoryEntity> get categories => _categories;

  List<LearningCategoryEntity> _allCategories = [];

  // Filter Logic
  int _selectedFilterIndex = 0;
  int get selectedFilterIndex => _selectedFilterIndex;

  final List<String> filters = [
    "all",
    "sorting",
    "graph",
    "search",
    "cryptography",
  ];

  String? _error;
  String? get error => _error;

  final Map<String, Map<String, dynamic>> _metaData = {
    'sort': {
      'color': const Color(0xFF8B5CF6),
      'icon': AppIcons.selection,
      'label': 'sorting',
    },
    'graph': {
      'color': const Color(0xFFF97316),
      'icon': AppIcons.graph,
      'label': 'graph',
    },
    'search': {
      'color': const Color(0xFF3B82F6),
      'icon': AppIcons.search,
      'label': 'search',
    },
    'crypto': {
      'color': const Color(0xFF10B981),
      'icon': AppIcons.rsa,
      'label': 'cryptography',
    },
    'tree': {
      'color': const Color(0xFFEC4899),
      'icon': AppIcons.astar,
      'label': 'tree',
    },
  };

  // State
  final Map<String, double> _progressMap = {};
  final Map<String, bool> _completedMap = {};
  int _streak = 0;
  int _todayXP = 0;
  int _totalXP = 0;
  int _sessionsCount = 0;
  String _lastLearnDate = "";
  int _lastLearnTimestamp = 0;
  String? _lastLearnedModuleId;
  bool _isInitialLoaded = false;

  // Getters
  int get streak => _streak;
  int get sessionsCount => _sessionsCount;
  int get todayXP => _todayXP;
  int get totalXP => _totalXP;
  double getProgress(String id) => _progressMap[id] ?? 0.0;
  bool isCompleted(String id) => _completedMap[id] ?? false;

  bool isLocked(String id) {
    if (_allCategories.isEmpty) return false;
    final all = _allCategories.expand((c) => c.items).toList();
    final index = all.indexWhere((e) => e.id == id);
    if (index <= 0) return false;
    final prevId = all[index - 1].id;
    return !isCompleted(prevId);
  }

  Color getColor(String id) {
    final prefix = id.split(RegExp(r'\d+')).first;
    return _metaData[prefix]?['color'] ?? Colors.blue;
  }

  IconData getIcon(String id) {
    final prefix = id.split(RegExp(r'\d+')).first;
    return _metaData[prefix]?['icon'] ?? AppIcons.code;
  }

  String getCategoryLabel(String id) {
    final prefix = id.split(RegExp(r'\d+')).first;
    return _metaData[prefix]?['label'] ?? 'general';
  }

  List<LearningEntity> get popularModules {
    final all = _allCategories.expand((c) => c.items).toList();
    return all.where((e) => e.id.startsWith('crypto')).take(5).toList();
  }

  String _searchQuery = '';

  List<LearningEntity> get filteredModules {
    final all = _allCategories.expand((c) => c.items).toList();
    List<LearningEntity> results = all;

    if (_selectedFilterIndex != 0) {
      final filterKey = filters[_selectedFilterIndex];
      if (filterKey == 'cryptography') {
        results = results.where((e) => e.id.startsWith('crypto')).toList();
      } else {
        results = results
            .where((e) => getCategoryLabel(e.id) == filterKey)
            .toList();
      }
    }

    if (_searchQuery.isNotEmpty) {
      results = results
          .where(
            (item) =>
                item.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    return results;
  }

  void setFilter(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }

  Future<void> loadLearningItems() async {
    try {
      final allItems = await getLearningItems();
      final Map<String, List<LearningEntity>> grouped = {};
      for (var item in allItems) {
        final prefix = item.id.split(RegExp(r'\d+')).first;
        grouped.putIfAbsent(prefix, () => []);
        grouped[prefix]!.add(item);
      }
      _categories = grouped.entries.map((entry) {
        final prefix = entry.key;
        final title = _metaData[prefix]?['label'] ?? prefix;
        return LearningCategoryEntity(
          id: prefix,
          title: title,
          items: entry.value,
        );
      }).toList();
      _allCategories = List.from(_categories);

      if (!_isInitialLoaded) {
        await _loadAllProgress();
        _isInitialLoaded = true;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _loadAllProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final all = _allCategories.expand((c) => c.items).toList();

      // 1. Map local values immediately
      for (var item in all) {
        _progressMap[item.id] = prefs.getDouble('${item.id}_progress') ?? 0.0;
        _completedMap[item.id] = prefs.getBool('${item.id}_completed') ?? false;
      }

      _streak = prefs.getInt('user_streak') ?? 0;
      _todayXP = prefs.getInt('user_today_xp') ?? 0;
      _totalXP = prefs.getInt('user_total_xp') ?? 0;
      _sessionsCount = prefs.getInt('user_sessions_count') ?? 0;
      _lastLearnDate = prefs.getString('user_last_learn_date') ?? "";
      _lastLearnTimestamp = prefs.getInt('user_last_learn_timestamp') ?? 0;
      _lastLearnedModuleId = prefs.getString('user_last_learned_module_id');

      _checkAndResetDailyStats(prefs);
      notifyListeners(); // Immediate local UI update

      // 2. Sync with Firestore
      final auth = sl<AuthService>();
      final firestore = sl<FirestoreService>();
      if (auth.currentUser != null) {
        final uid = auth.currentUser!.uid;
        _logger.i("Syncing learning data with Firestore for: $uid");

        // Sync main stats
        final userModel = await firestore.getUser(uid);
        if (userModel != null) {
          bool changed = false;
          if (userModel.totalXP > _totalXP) {
            _totalXP = userModel.totalXP;
            _streak = userModel.streak;
            _todayXP = userModel.todayXP;
            _lastLearnDate = userModel.lastLearnDate;
            _lastLearnTimestamp = userModel.lastLearnTimestamp;
            _lastLearnedModuleId = userModel.lastLearnedModuleId;
            await prefs.setInt('user_total_xp', _totalXP);
            await prefs.setInt('user_streak', _streak);
            await prefs.setInt('user_today_xp', _todayXP);
            await prefs.setString('user_last_learn_date', _lastLearnDate);
            await prefs.setInt(
              'user_last_learn_timestamp',
              _lastLearnTimestamp,
            );
            if (_lastLearnedModuleId != null) {
              await prefs.setString(
                'user_last_learned_module_id',
                _lastLearnedModuleId!,
              );
            }
            changed = true;
          }

          // Sync individual module progress
          final firestoreProgress = await firestore.getAllProgress(uid);
          DateTime? latestSync;
          for (var p in firestoreProgress) {
            final localP = _progressMap[p.moduleId] ?? 0.0;
            if (p.progress > localP) {
              _progressMap[p.moduleId] = p.progress;
              _completedMap[p.moduleId] = p.completed;
              await prefs.setDouble('${p.moduleId}_progress', p.progress);
              await prefs.setBool('${p.moduleId}_completed', p.completed);
              changed = true;
            }
            if (latestSync == null || p.lastUpdated.isAfter(latestSync)) {
              latestSync = p.lastUpdated;
            }
          }

          if (latestSync != null &&
              latestSync.millisecondsSinceEpoch > _lastLearnTimestamp) {
            _lastLearnTimestamp = latestSync.millisecondsSinceEpoch;
            await prefs.setInt(
              'user_last_learn_timestamp',
              _lastLearnTimestamp,
            );
            changed = true;
          }

          if (changed) notifyListeners();
        }
      }
    } catch (e) {
      _logger.e("Error loading progress: $e");
    }
  }

  void _checkAndResetDailyStats(SharedPreferences prefs) {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    if (_lastLearnDate != todayStr) {
      if (_lastLearnDate.isNotEmpty) {
        final yesterday = now.subtract(const Duration(days: 1));
        final yesterdayStr =
            "${yesterday.year}-${yesterday.month}-${yesterday.day}";
        if (_lastLearnDate != yesterdayStr) {
          _streak = 0;
          prefs.setInt('user_streak', 0);
        }
      }
      _todayXP = 0;
      prefs.setInt('user_today_xp', 0);
    }
  }

  Future<void> updateProgress(String id, double progress) async {
    final prefs = await SharedPreferences.getInstance();
    final oldProgress = _progressMap[id] ?? 0.0;

    if (progress > oldProgress) {
      final xpGained = ((progress - oldProgress) * 100).round();
      _progressMap[id] = progress;
      await prefs.setDouble('${id}_progress', progress);
      _lastLearnTimestamp = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt('user_last_learn_timestamp', _lastLearnTimestamp);
      _lastLearnedModuleId = id;
      await prefs.setString('user_last_learned_module_id', id);

      if (progress >= 1.0) {
        _completedMap[id] = true;
        await prefs.setBool('${id}_completed', true);
        // Persist completed module to user's profile document for visibility in profile
        final auth = sl<AuthService>();
        if (auth.currentUser != null) {
          try {
            await sl<FirestoreService>().addCompletedModule(
              auth.currentUser!.uid,
              id,
            );
          } catch (e) {
            _logger.e('Error adding completed module to Firestore: $e');
          }
        }
      }

      await _updateActivityStats(prefs, xpGained);

      final auth = sl<AuthService>();
      if (auth.currentUser != null) {
        await sl<FirestoreService>().updateProgress(
          auth.currentUser!.uid,
          UserProgressModel(
            moduleId: id,
            progress: progress,
            completed: progress >= 1.0,
            lastUpdated: DateTime.now(),
          ),
        );
      }
      notifyListeners();
    }
  }

  Future<void> updateLastAccessed(String id) async {
    final prefs = await SharedPreferences.getInstance();

    // Update local state
    _lastLearnTimestamp = DateTime.now().millisecondsSinceEpoch;
    _lastLearnedModuleId = id;

    // Persist local
    await prefs.setInt('user_last_learn_timestamp', _lastLearnTimestamp);
    await prefs.setString('user_last_learned_module_id', id);

    // Persist remote
    final auth = sl<AuthService>();
    if (auth.currentUser != null) {
      try {
        await sl<FirestoreService>().updateUserStats(
          uid: auth.currentUser!.uid,
          streak: _streak,
          totalXP: _totalXP,
          todayXP: _todayXP,
          lastLearnDate: _lastLearnDate,
          lastLearnTimestamp: _lastLearnTimestamp,
          lastLearnedModuleId: _lastLearnedModuleId,
        );
      } catch (e) {
        _logger.e('Error updating last accessed stats: $e');
      }
    }

    notifyListeners();
  }

  Future<void> addXP(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    _totalXP += amount;
    _todayXP += amount;
    await prefs.setInt('user_total_xp', _totalXP);
    await prefs.setInt('user_today_xp', _todayXP);

    final auth = sl<AuthService>();
    if (auth.currentUser != null) {
      await sl<FirestoreService>().updateUserStats(
        uid: auth.currentUser!.uid,
        streak: _streak,
        totalXP: _totalXP,
        todayXP: _todayXP,
        lastLearnDate: _lastLearnDate,
        lastLearnTimestamp: _lastLearnTimestamp,
        lastLearnedModuleId: _lastLearnedModuleId,
      );
    }
    notifyListeners();
  }

  Future<void> _updateActivityStats(
    SharedPreferences prefs,
    int xpGained,
  ) async {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    _todayXP += xpGained;
    _totalXP += xpGained;
    await prefs.setInt('user_today_xp', _todayXP);
    await prefs.setInt('user_total_xp', _totalXP);

    if (_lastLearnDate != todayStr) {
      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayStr =
          "${yesterday.year}-${yesterday.month}-${yesterday.day}";
      if (_lastLearnDate == yesterdayStr) {
        _streak++;
      } else {
        _streak = 1;
      }
      _lastLearnDate = todayStr;
      await prefs.setInt('user_streak', _streak);
      await prefs.setString('user_last_learn_date', todayStr);
    }

    final auth = sl<AuthService>();
    if (auth.currentUser != null) {
      await sl<FirestoreService>().updateUserStats(
        uid: auth.currentUser!.uid,
        streak: _streak,
        totalXP: _totalXP,
        todayXP: _todayXP,
        lastLearnDate: _lastLearnDate,
        lastLearnTimestamp: _lastLearnTimestamp,
        lastLearnedModuleId: _lastLearnedModuleId,
      );
    }
  }

  Future<void> refreshProgress() async {
    await _loadAllProgress();
  }

  Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final all = _allCategories.expand((c) => c.items).toList();
    for (var item in all) {
      await prefs.remove('${item.id}_progress');
      await prefs.remove('${item.id}_completed');
    }
    await prefs.remove('user_streak');
    await prefs.remove('user_today_xp');
    await prefs.remove('user_total_xp');
    await prefs.remove('user_sessions_count');
    await prefs.remove('user_last_learn_date');
    await prefs.remove('user_last_learn_timestamp');
    await prefs.remove('user_last_learned_module_id');

    _progressMap.clear();
    _completedMap.clear();
    _streak = 0;
    _todayXP = 0;
    _totalXP = 0;
    _sessionsCount = 0;
    _lastLearnDate = "";
    _lastLearnTimestamp = 0;
    _lastLearnedModuleId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _userStreamSubscription?.cancel();
    _progressStreamSubscription?.cancel();
    super.dispose();
  }

  void filterItems(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  int get completedCount => _completedMap.values.where((c) => c).length;
  int get totalModulesCount => _allCategories.expand((c) => c.items).length;
  int get overallProgressPercentage => totalModulesCount == 0
      ? 0
      : ((completedCount / totalModulesCount) * 100).round();

  int get currentLevel => _totalXP == 0 ? 1 : (_totalXP / 500).floor() + 1;
  double get levelProgress => (_totalXP % 500) / 500;

  Map<String, dynamic>? get lastLearnedModule {
    try {
      if (_allCategories.isEmpty) return null;
      final all = _allCategories.expand((c) => c.items).toList();
      LearningEntity? lastModule;

      if (_lastLearnedModuleId != null) {
        try {
          lastModule = all.firstWhere((e) => e.id == _lastLearnedModuleId);
        } catch (_) {}
      }

      if (lastModule == null) {
        double maxProgress = 0;
        for (var module in all) {
          final progress = _progressMap[module.id] ?? 0.0;
          if (progress > 0 && progress >= maxProgress) {
            maxProgress = progress;
            lastModule = module;
          }
        }
      }

      if (lastModule == null) return null;
      return {
        'id': lastModule.id,
        'titleKey': lastModule.title,
        'descriptionKey': lastModule.description,
        'progress': _progressMap[lastModule.id] ?? 0.0,
        'icon': getIcon(lastModule.id),
        'color': getColor(lastModule.id),
        'timestamp': _lastLearnTimestamp,
      };
    } catch (e) {
      return null;
    }
  }
}
