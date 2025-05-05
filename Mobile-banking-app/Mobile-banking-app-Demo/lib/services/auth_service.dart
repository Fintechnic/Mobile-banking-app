import '../models/auth_response.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // ✅ Dùng debugPrint để log

class AuthService {
  /// Đăng nhập người dùng
  static Future<AuthResponse?> login(String username, String password) async {
    final response = await ApiService.post("/api/auth/login", {
      "username": username,
      "password": password,
    });

    debugPrint("Login API Response: $response");

    if (response.containsKey("token")) {
      AuthResponse authResponse = AuthResponse.fromJson(response);
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", authResponse.token);
      await prefs.setString("role", authResponse.role);
      await prefs.setString("username", username); // ✅ Lưu username để dùng khi logout
      
      return authResponse;
    }

    return null;
  }

  /// Đăng ký tài khoản mới
  static Future<bool> register(String username, String password, String email) async {
    final response = await ApiService.post("/api/auth/register", {
      "username": username,
      "password": password,
      "email": email,
    });

    return response.containsKey("username");
  }

  /// Đăng xuất người dùng hiện tại
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final username = prefs.getString("username");

    // Nếu đã login, gọi API logout (không bắt buộc nếu backend không yêu cầu)
    if (token != null && username != null) {
      try {
        await ApiService.post("/api/auth/logout", {"username": username}, token: token);
      } catch (e) {
        debugPrint("Logout API error: $e");
      }
    }

    // Xoá token và role trong local
    await prefs.remove("token");
    await prefs.remove("role");
    await prefs.remove("username");
  }

  /// Mở khóa người dùng (dành cho admin)
  static Future<bool> unlockUser(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return false;

    final response = await ApiService.post("/api/auth/unlock", {
      "username": username,
    }, token: token);

    return response['message'] == 'Unlock successful';
  }
}
