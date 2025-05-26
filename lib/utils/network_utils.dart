import 'package:connectivity_plus/connectivity_plus.dart' as connectivity;

class NetworkUtils {
  static Future<bool> checkConnection() async {
    try {
      final result = await connectivity.Connectivity().checkConnectivity();
      return result != connectivity.ConnectivityResult.none;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }
} 