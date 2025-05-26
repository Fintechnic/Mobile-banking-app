import 'package:flutter/foundation.dart';
import 'api_service.dart';

class StatsService {
  final ApiService _apiService = ApiService();

  /// Lấy thống kê tổng quan hệ thống (dành cho admin)
  Future<Map<String, dynamic>?> getSystemStats() async {
    final token = await _apiService.getToken();
    if (token == null) return null;
    
    final response = await _apiService.get("/api/admin/system-stats", token: token);
    debugPrint("System Stats Response: $response");
    
    if (response.containsKey("error")) {
      return null;
    }
    
    return response;
  }
} 