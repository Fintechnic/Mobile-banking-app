import 'package:fintechnic/services/api_service.dart';
import 'package:fintechnic/utils/app_logger.dart';

class ApiTestService {
  final ApiService _apiService = ApiService();
  final _logger = AppLogger();

  Future<bool> testConnection() async {
    try {
      _logger.i('Testing API connection...');
      
      // Thử gọi một endpoint health check hoặc endpoint public
      final response = await _apiService.get('/api/health');
      
      if (response.containsKey('error')) {
        _logger.e('Connection test failed', error: response['error']);
        return false;
      }
      
      _logger.i('Connection test successful: ${response.toString()}');
      return true;
    } catch (e) {
      _logger.e('Connection test failed', error: e);
      return false;
    }
  }
} 