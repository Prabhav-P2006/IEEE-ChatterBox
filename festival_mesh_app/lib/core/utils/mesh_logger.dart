import 'package:flutter/foundation.dart';

class MeshLogger {
  static final MeshLogger _instance = MeshLogger._internal();
  factory MeshLogger() => _instance;
  MeshLogger._internal();

  final List<String> _logs = [];
  
  void log(String message) {
    final time = DateTime.now().toIso8601String().substring(11, 19);
    final formatted = "[$time] [MESH] $message";
    debugPrint(formatted);
    _logs.insert(0, formatted);
    if (_logs.length > 50) _logs.removeLast();
  }

  List<String> get logs => List.unmodifiable(_logs);
}
