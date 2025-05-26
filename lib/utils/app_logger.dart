import 'package:flutter/foundation.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  
  factory AppLogger() {
    return _instance;
  }
  
  AppLogger._internal();
  
  void d(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('DEBUG: $message');
      if (error != null) print('ERROR: $error');
      if (stackTrace != null) print('STACK: $stackTrace');
    }
  }
  
  void i(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('INFO: $message');
      if (error != null) print('ERROR: $error');
      if (stackTrace != null) print('STACK: $stackTrace');
    }
  }
  
  void w(String message, {Object? error, StackTrace? stackTrace}) {
    print('WARNING: $message');
    if (error != null) print('ERROR: $error');
    if (stackTrace != null) print('STACK: $stackTrace');
  }
  
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    print('ERROR: $message');
    if (error != null) print('ERROR: $error');
    if (stackTrace != null) print('STACK: $stackTrace');
  }
} 