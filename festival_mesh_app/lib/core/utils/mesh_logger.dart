class MeshLogger {
  static final MeshLogger _instance = MeshLogger._internal();
  factory MeshLogger() => _instance;
  MeshLogger._internal();

  final List<String> _logs = [];
  
  void log(String message) {
    final time = DateTime.now().toIso8601String().substring(11, 19);
    _logs.insert(0, "[$time] $message");
    if (_logs.length > 50) _logs.removeLast();
  }

  List<String> get logs => List.unmodifiable(_logs);
}
