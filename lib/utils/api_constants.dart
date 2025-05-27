import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Base URL for API calls - get from environment or use default
  static String get baseUrl {
    if (kDebugMode) {
      final host = dotenv.get('API_HOST', fallback: '192.168.100.221');
      final port = dotenv.get('API_PORT', fallback: '8080');
      return dotenv.get('API_URL', fallback: 'http://$host:$port');
    } else {
      return dotenv.get('API_URL', fallback: 'https://your-production-api.com');
    }
  }

  // Headers for API calls
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Get auth token from secure storage
  static String getToken() {
    try {
      // This is just a synchronous wrapper - the actual implementation
      // would be better with async, but we're adapting to the current code structure
      return _token ?? '';
    } catch (e) {
      debugPrint('Error getting token: $e');
      return '';
    }
  }

  // Cache token in memory for quick access
  static String? _token;

  // Load token from secure storage (call this at app startup)
  static Future<void> loadToken() async {
    try {
      _token = await _storage.read(key: 'token');
      debugPrint('Token loaded from secure storage: ${_token != null}');
    } catch (e) {
      debugPrint('Error loading token: $e');
    }
  }

  // No need to implement setToken and clearToken as they're handled by ApiService
} 