import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://192.168.0.25:8080";

  /// Hàm POST chung,có thể truyền hoặc không truyền token
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
      body: json.encode(data),
    );

    return json.decode(response.body);
  }

  /// Hàm POST luôn truyền token (dùng cho admin/user)
  static Future<Map<String, dynamic>> postWithToken(String endpoint, Map<String, dynamic> data, String token) async {
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
      body: json.encode(data),
    );

    return json.decode(response.body);
  }

  /// Hàm GET chung
  static Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
    );

    return json.decode(response.body);
  }

  /// Lấy tổng hợp thông tin toàn hệ thống (system stats)
  static Future<Map<String, dynamic>?> getSystemStats({String? token}) async {
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    final response = await http.get(
      Uri.parse("$baseUrl/api/admin/system-stats"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }
}
