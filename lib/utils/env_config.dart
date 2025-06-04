import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;
import 'package:flutter/foundation.dart';

class EnvConfig {
  static Future<void> load() async {
    try {
      await dot_env.dotenv.load(fileName: '.env.development');
    } catch (e) {
      debugPrint('Error loading .env file: $e');
    }
  }

  static String get(String key, {String fallback = ''}) {
    try {
      return dot_env.dotenv.get(key, fallback: fallback);
    } catch (e) {
      debugPrint('Error getting env value for $key: $e');
      return fallback;
    }
  }
} 