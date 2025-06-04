import 'package:flutter/foundation.dart';
import 'api_service.dart';

class StatsService {
  final ApiService _apiService = ApiService();

  /// Fetch system statistics (admin only)
  /// GET /api/admin/systemstats
  Future<Map<String, dynamic>?> getSystemStats() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        debugPrint("No token available for system stats request");
        return null;
      }
      
      final response = await _apiService.get("/api/admin/system-stats", token: token);
      debugPrint("System Stats Response: $response");
      
      if (response.containsKey("error")) {
        debugPrint("Error getting system stats: ${response['error']}");
        return null;
      }

      // Check if response is wrapped in a data field
      if (response.containsKey('data') && response['data'] is Map<String, dynamic>) {
        return response['data'];
      }
      
      // Ensure response includes expected fields
      if (!response.containsKey('totalUsers') && !response.containsKey('totalTransactions')) {
        debugPrint("System stats response missing expected fields: $response");
        
        // Try to find fields by checking if they exist in any inner map
        for (var key in response.keys) {
          if (response[key] is Map<String, dynamic> && 
              (response[key].containsKey('totalUsers') || response[key].containsKey('totalTransactions'))) {
            return response[key];
          }
        }
        
        // Create default values if missing
        return {
          'totalUsers': 0,
          'totalTransactions': 0,
          'totalBalance': 0,
          'averageBalance': 0,
        };
      }
      
      return response;
    } catch (e) {
      debugPrint("Exception in getSystemStats: $e");
      return null;
    }
  }
} 