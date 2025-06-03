import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fintechnic/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final Dio _dio;
  final _logger = AppLogger();

  // Development configuration
  static const defaultHost = '192.168.100.221'; // Android Emulator localhost
  static const defaultPort = '8080';     // Spring Boot default port
  
  factory ApiService() {
    return _instance;
  }

  ApiService._internal() { 
    final host = dotenv.get('API_HOST', fallback: defaultHost);
    final port = dotenv.get('API_PORT', fallback: defaultPort);
    final apiUrl = dotenv.get('API_URL', fallback: 'http://$host:$port');
    
    _logger.i('Initializing API Service with URL: $apiUrl');

    _dio = Dio(BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: Duration(milliseconds: int.parse(dotenv.get('API_TIMEOUT', fallback: '30000'))),
      receiveTimeout: Duration(milliseconds: int.parse(dotenv.get('API_TIMEOUT', fallback: '30000'))),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500; // Accept all status codes below 500
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
        _logger.i('REQUEST DATA: ${options.data}');
        final token = await getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        _logger.i('RESPONSE DATA: ${response.data}');
        
        // Handle empty responses
        if (response.data == null || (response.data is String && response.data.toString().isEmpty)) {
          response.data = {"success": true};
        }
        
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        _logger.e(
          'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          error: e.message
        );
        _logger.e('ERROR RESPONSE: ${e.response?.data}');
        
        // Convert empty error responses to a success response if status code is success
        if (e.response != null && 
            e.response!.statusCode != null && 
            e.response!.statusCode! < 400 &&
            (e.response!.data == null || (e.response!.data is String && e.response!.data.toString().isEmpty))) {
          final response = e.response!;
          response.data = {"success": true};
          return handler.resolve(response);
        }
        
        return handler.next(e);
      },
    ));
    
    // Add extra logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<String?> getPhoneNumber() async {
    return await _storage.read(key: 'phone_number');
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> saveUserData(String userId, String phoneNumber) async {
    await _storage.write(key: 'user_id', value: userId);
    await _storage.write(key: 'phone_number', value: phoneNumber);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<Map<String, dynamic>> get(String path, {String? token, Map<String, dynamic>? queryParams}) async {
    try {
      _logger.i('Making GET request to: $path');
      _logger.i('Query parameters: $queryParams');
      
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          responseType: ResponseType.plain, // Get raw response to handle empty responses better
        ),
      );
      
      _logger.i('Response status code: ${response.statusCode}');
      _logger.i('Response data: ${response.data}');
      
      // Handle empty responses immediately
      final rawData = response.data;
      if (rawData == null || (rawData is String && rawData.toString().isEmpty)) {
        _logger.i('Empty response detected, returning success');
        return {'success': true, 'statusCode': response.statusCode};
      }

      // Handle non-empty string data by trying to parse as JSON
      if (rawData is String && rawData.isNotEmpty) {
        try {
          _logger.i('Attempting to parse response as JSON');
          final Map<String, dynamic> parsedJson = jsonDecode(rawData);
          return parsedJson;
        } catch (e) {
          _logger.w('JSON parse error: $e');
          // If not valid JSON, but status is success, return success object
          if (response.statusCode != null && response.statusCode! < 400) {
            return {'success': true, 'statusCode': response.statusCode, 'data': rawData};
          }
          // For error statuses, return the error
          return {'error': 'Invalid JSON response: $rawData'};
        }
      }
      
      // Handle successful status code but non-JSON response
      if (response.statusCode != null && response.statusCode! < 400) {
        return {'success': true, 'statusCode': response.statusCode};
      }
      
      // Default error handling
      if (response.statusCode != null && response.statusCode! >= 400) {
        String errorMsg = '';
        
        // Handle different error formats
        if (response.data is Map<String, dynamic>) {
          errorMsg = response.data['message'] ?? response.data['error'] ?? response.data.toString();
        } else if (response.data is String) {
          errorMsg = response.data;
        } else {
          errorMsg = 'Request failed with status: ${response.statusCode}';
        }
        
        _logger.e('Error response: $errorMsg');
        return {'error': errorMsg};
      }
      
      return {'data': response.data, 'statusCode': response.statusCode};
    } on DioException catch (e) {
      _logger.e('DioException in get request: ${e.message}');
      _logger.e('Response data: ${e.response?.data}');
      
      // Special case: Empty response with successful status code
      if (e.response != null && e.response!.statusCode != null && e.response!.statusCode! < 400) {
        final responseData = e.response!.data;
        if (responseData == null || (responseData is String && responseData.toString().isEmpty)) {
          return {'success': true, 'statusCode': e.response!.statusCode};
        }
        
        // Try to parse as JSON if it's a string
        if (responseData is String && responseData.isNotEmpty) {
          try {
            final Map<String, dynamic> parsedJson = jsonDecode(responseData);
            return parsedJson;
          } catch (parseError) {
            // Return success on format exception for success status codes
            return {'success': true, 'statusCode': e.response!.statusCode, 'data': responseData};
          }
        }
      }
      
      if (e.response?.data is Map<String, dynamic>) {
        return {'error': e.response?.data['message'] ?? e.message};
      }
      
      return {'error': e.message ?? 'Network error occurred'};
    } catch (e) {
      _logger.e('General error in GET request: $e');
      if (e is FormatException) {
        _logger.w('This is a FormatException, likely from empty response');
        return {'success': true};
      }
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> post(String path, dynamic data, {String? token}) async {
    try {
      _logger.i('Making POST request to: $path');
      _logger.i('Request data: $data');
      
      // Ensure the data is properly converted to JSON
      final jsonData = data is String ? data : jsonEncode(data);
      
      final response = await _dio.post(
        path,
        data: jsonData,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          contentType: 'application/json',
          responseType: ResponseType.plain, // Get raw response to handle empty responses better
        ),
      );
      
      _logger.i('Response status code: ${response.statusCode}');
      _logger.i('Response data: ${response.data}');
      
      // Handle empty responses immediately
      final rawData = response.data;
      if (rawData == null || (rawData is String && rawData.toString().isEmpty)) {
        _logger.i('Empty response detected, returning success');
        return {'success': true, 'statusCode': response.statusCode};
      }

      // Handle non-empty string data by trying to parse as JSON
      if (rawData is String && rawData.isNotEmpty) {
        try {
          _logger.i('Attempting to parse response as JSON');
          final Map<String, dynamic> parsedJson = jsonDecode(rawData);
          return parsedJson;
        } catch (e) {
          _logger.w('JSON parse error: $e');
          // If not valid JSON, but status is success, return success object
          if (response.statusCode != null && response.statusCode! < 400) {
            return {'success': true, 'statusCode': response.statusCode, 'data': rawData};
          }
          // For error statuses, return the error
          return {'error': 'Invalid JSON response: $rawData'};
        }
      }
      
      // Handle successful status code but non-JSON response
      if (response.statusCode != null && response.statusCode! < 400) {
        return {'success': true, 'statusCode': response.statusCode};
      }
      
      // Default error handling
      if (response.statusCode != null && response.statusCode! >= 400) {
        String errorMsg = '';
        
        // Handle different error formats
        if (response.data is Map<String, dynamic>) {
          errorMsg = response.data['message'] ?? response.data['error'] ?? response.data.toString();
        } else if (response.data is String) {
          errorMsg = response.data;
        } else {
          errorMsg = 'Request failed with status: ${response.statusCode}';
        }
        
        _logger.e('Error response: $errorMsg');
        return {'error': errorMsg};
      }
      
      return {'data': response.data, 'statusCode': response.statusCode};
    } on DioException catch (e) {
      _logger.e('DioException in post request: ${e.message}');
      _logger.e('Response data: ${e.response?.data}');
      
      // Special case: Empty response with successful status code
      if (e.response != null && e.response!.statusCode != null && e.response!.statusCode! < 400) {
        final responseData = e.response!.data;
        if (responseData == null || (responseData is String && responseData.toString().isEmpty)) {
          _logger.i('Empty error response with success status code, treating as success');
          return {'success': true, 'statusCode': e.response!.statusCode};
        }
        
        // Try to parse as JSON if it's a string
        if (responseData is String && responseData.isNotEmpty) {
          try {
            final Map<String, dynamic> parsedJson = jsonDecode(responseData);
            return parsedJson;
          } catch (parseError) {
            _logger.w('JSON parse error in error handler: $parseError');
            // Return success on format exception for success status codes
            return {'success': true, 'statusCode': e.response!.statusCode, 'data': responseData};
          }
        }
      }
      
      // Handle validation errors specially
      if (e.response?.data is String && 
          e.response!.data.toString().contains('Validation failed')) {
        return {'error': e.response!.data};
      }
      
      if (e.response?.data is Map<String, dynamic>) {
        return {'error': e.response?.data['message'] ?? e.message};
      }
      
      return {'error': e.message ?? 'Network error occurred'};
    } catch (e) {
      _logger.e('General error in POST request: $e');
      if (e is FormatException) {
        _logger.w('This is a FormatException, likely from empty response');
        return {'success': true};
      }
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> put(String path, dynamic data, {String? token}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      
      // Handle empty responses
      if (response.data == null || (response.data is String && response.data.toString().isEmpty)) {
        if (response.statusCode != null && response.statusCode! < 400) {
          // Empty response with success status code should be treated as success
          return {'success': true, 'statusCode': response.statusCode};
        }
      }
      
      if (response.statusCode != null && response.statusCode! >= 400) {
        return {'error': response.data?.toString() ?? 'Request failed with status: ${response.statusCode}'};
      }
      
      if (response.data == null) {
        // Null data with success status code is considered success
        return {'success': true, 'statusCode': response.statusCode};
      } else if (response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.data is String && !response.data.toString().isEmpty) {
        // Try to parse string as JSON
        try {
          final jsonData = jsonDecode(response.data);
          if (jsonData is Map<String, dynamic>) {
            return jsonData;
          }
        } catch (e) {
          // Not JSON, just return as data
        }
      }
      
      return {'data': response.data, 'statusCode': response.statusCode};
    } on DioException catch (e) {
      // Special case: Empty response with successful status code
      if (e.response != null && e.response!.statusCode != null && e.response!.statusCode! < 400) {
        if (e.response!.data == null || (e.response!.data is String && e.response!.data.toString().isEmpty)) {
          return {'success': true, 'statusCode': e.response!.statusCode};
        }
      }
      
      if (e.response?.data is Map<String, dynamic>) {
        return {'error': e.response?.data['message'] ?? e.message};
      }
      return {'error': e.message ?? 'Network error occurred'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> delete(String path, {String? token}) async {
    try {
      final response = await _dio.delete(
        path,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      
      // Handle empty responses
      if (response.data == null || (response.data is String && response.data.toString().isEmpty)) {
        if (response.statusCode != null && response.statusCode! < 400) {
          // Empty response with success status code should be treated as success
          return {'success': true, 'statusCode': response.statusCode};
        }
      }
      
      if (response.statusCode != null && response.statusCode! >= 400) {
        return {'error': response.data?.toString() ?? 'Request failed with status: ${response.statusCode}'};
      }
      
      if (response.data == null) {
        // Null data with success status code is considered success
        return {'success': true, 'statusCode': response.statusCode};
      } else if (response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.data is String && !response.data.toString().isEmpty) {
        // Try to parse string as JSON
        try {
          final jsonData = jsonDecode(response.data);
          if (jsonData is Map<String, dynamic>) {
            return jsonData;
          }
        } catch (e) {
          // Not JSON, just return as data
        }
      }
      
      return {'data': response.data, 'statusCode': response.statusCode};
    } on DioException catch (e) {
      // Special case: Empty response with successful status code
      if (e.response != null && e.response!.statusCode != null && e.response!.statusCode! < 400) {
        if (e.response!.data == null || (e.response!.data is String && e.response!.data.toString().isEmpty)) {
          return {'success': true, 'statusCode': e.response!.statusCode};
        }
      }
      
      if (e.response?.data is Map<String, dynamic>) {
        return {'error': e.response?.data['message'] ?? e.message};
      }
      return {'error': e.message ?? 'Network error occurred'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

}

class TimeoutException implements Exception {}
class UnauthorizedException implements Exception {}
class ForbiddenException implements Exception {}
class NotFoundException implements Exception {}
class ServerException implements Exception {}
class RequestCancelledException implements Exception {}
class OtherException implements Exception {
  final String? message;
  OtherException(this.message);
}