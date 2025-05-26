import 'package:flutter/foundation.dart';
import '../services/stats_service.dart';

class StatsProvider with ChangeNotifier {
  final StatsService _statsService = StatsService();
  Map<String, dynamic>? _systemStats;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get systemStats => _systemStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Lấy thống kê tổng quan hệ thống
  Future<void> fetchSystemStats() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final stats = await _statsService.getSystemStats();
      
      if (stats != null) {
        _systemStats = stats;
        _error = null;
      } else {
        _error = "Failed to fetch system stats";
      }
    } catch (e) {
      _error = e.toString();
      debugPrint("Error fetching system stats: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}   