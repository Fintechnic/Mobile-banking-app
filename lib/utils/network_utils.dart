import 'package:connectivity_plus/connectivity_plus.dart' as connectivity;
import 'package:flutter/foundation.dart';

class NetworkUtils {
  static Future<bool> checkConnection() async {
    try {
      final List<connectivity.ConnectivityResult> results = await connectivity.Connectivity().checkConnectivity();
      // Check if the list contains any connectivity result other than 'none'
      return !results.contains(connectivity.ConnectivityResult.none);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }
} 