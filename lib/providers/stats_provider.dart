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

  // Convenience getters for system statistics
  int get totalUsers => _systemStats?['totalUsers'] ?? 0;
  int get totalTransactions => _systemStats?['totalTransactions'] ?? 0;
  double get totalBalance => 
      _parseDouble(_systemStats?['totalBalance']) ?? 0.0;
  double get averageBalance => 
      _parseDouble(_systemStats?['averageBalance']) ?? 0.0;
  
  /// Parse double value safely
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Fetch system statistics
  Future<void> fetchSystemStats() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final stats = await _statsService.getSystemStats();
      
      if (stats != null) {
        _systemStats = stats;
        _error = null;
        debugPrint("System stats fetched successfully: $_systemStats");
      } else {
        _error = "Failed to fetch system stats";
        debugPrint("Failed to fetch system stats");
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