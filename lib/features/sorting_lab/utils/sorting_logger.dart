class SortingLogger {
  final List<String> _logs = [];

  void log(String message) {
    final _ = DateTime.now().toIso8601String();
    _logs.add('[\$t] \$message');
    // ignore: avoid_print
    print('[SortingLogger] \$message');
  }

  List<String> get all => List.unmodifiable(_logs);
  void clear() => _logs.clear();
}
