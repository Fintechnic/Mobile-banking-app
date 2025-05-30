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
  static const defaultHost = '192.168.31.181'; // Android Emulator localhost
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
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        _logger.e(
          'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          error: e.message
        );
        _logger.e('ERROR RESPONSE: ${e.response?.data}');
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

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<Map<String, dynamic>> get(String path, {String? token, Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      
      if (response.statusCode != null && response.statusCode! >= 400) {
        return {'error': response.data?.toString() ?? 'Request failed with status: ${response.statusCode}'};
      }
      
      return response.data is Map<String, dynamic> 
          ? response.data
          : {'data': response.data, 'statusCode': response.statusCode};
    } on DioException catch (e) {
      _handleError(e);
      if (e.response?.data is Map<String, dynamic>) {
        return {'error': e.response?.data['message'] ?? e.message};
      }
      return {'error': e.message ?? 'Network error occurred'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> post(String path, dynamic data, {String? token}) async {
    try {
      _logger.i('Making POST request to: $path');
      _logger.i('Request data: $data');
      
      final response = await _dio.post(
        path,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      
      _logger.i('Response status code: ${response.statusCode}');
      _logger.i('Response data: ${response.data}');
      
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
      
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.data is String) {
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
      _handleError(e);
      _logger.e('DioException: ${e.message}');
      _logger.e('Response data: ${e.response?.data}');
      
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
      
      if (response.statusCode != null && response.statusCode! >= 400) {
        return {'error': response.data?.toString() ?? 'Request failed with status: ${response.statusCode}'};
      }
      
      return response.data is Map<String, dynamic> 
          ? response.data
          : {'data': response.data, 'statusCode': response.statusCode};
    } on DioException catch (e) {
      _handleError(e);
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
      
      if (response.statusCode != null && response.statusCode! >= 400) {
        return {'error': response.data?.toString() ?? 'Request failed with status: ${response.statusCode}'};
      }
      
      return response.data is Map<String, dynamic> 
          ? response.data
          : {'data': response.data, 'statusCode': response.statusCode};
    } on DioException catch (e) {
      _handleError(e);
      if (e.response?.data is Map<String, dynamic>) {
        return {'error': e.response?.data['message'] ?? e.message};
      }
      return {'error': e.message ?? 'Network error occurred'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  void _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException();
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 401:
            throw UnauthorizedException();
          case 403:
            throw ForbiddenException();
          case 404:
            throw NotFoundException();
          case 500:
            throw ServerException();
          default:
            throw OtherException(e.message);
        }
      case DioExceptionType.cancel:
        throw RequestCancelledException();
      default:
        throw OtherException(e.message);
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