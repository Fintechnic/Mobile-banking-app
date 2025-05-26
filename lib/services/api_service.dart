import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fintechnic/utils/app_logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final Dio _dio;
  final _logger = AppLogger();

  // Development configuration
  static const defaultHost = '10.0.2.2'; // Android Emulator localhost
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
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
        final token = await getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        _logger.e(
          'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          error: e.message
        );
        return handler.next(e);
      },
    ));
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

  Future<Map<String, dynamic>> get(String path, {String? token}) async {
    try {
      final response = await _dio.get(
        path,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      return {'error': e.message};
    }
  }

  Future<Map<String, dynamic>> post(String path, dynamic data, {String? token}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      return {'error': e.message};
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
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      return {'error': e.message};
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
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      return {'error': e.message};
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