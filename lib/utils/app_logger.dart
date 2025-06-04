import 'package:flutter/foundation.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  
  factory AppLogger() {
    return _instance;
  }
  
  AppLogger._internal();
  
  void d(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('DEBUG: $message');
      if (error != null) debugPrint('ERROR: $error');
      if (stackTrace != null) debugPrint('STACK: $stackTrace');
    }
  }
  
  void i(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('INFO: $message');
      if (error != null) debugPrint('ERROR: $error');
      if (stackTrace != null) debugPrint('STACK: $stackTrace');
    }
  }
  
  void w(String message, {Object? error, StackTrace? stackTrace}) {
    debugPrint('WARNING: $message');
    if (error != null) debugPrint('ERROR: $error');
    if (stackTrace != null) debugPrint('STACK: $stackTrace');
  }
  
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    debugPrint('ERROR: $message');
    if (error != null) debugPrint('ERROR: $error');
    if (stackTrace != null) debugPrint('STACK: $stackTrace');
  }
} 