import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/auth_response.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  String? token;
  String? role;
  bool isAuthenticated = false;
  String? userId;
  Map<String, dynamic>? userData;

  AuthProvider() {
    _loadUserSession();
  }

  /// Load session từ local storage
  Future<void> _loadUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    role = prefs.getString("role");
    isAuthenticated = token != null;
    if (isAuthenticated) {
      await getUserData();
    }
    notifyListeners();
  }

  /// Đăng nhập
  Future<bool> login(String username, String password) async {
    AuthResponse? authResponse = await AuthService.login(username, password);
    if (authResponse != null) {
      token = authResponse.token;
      role = authResponse.role;
      isAuthenticated = true;
      await getUserData();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Đăng ký
  Future<bool> register(String username, String password, String email) async {
    bool success = await AuthService.register(username, password, email);
    notifyListeners();
    return success;
  }

  /// Đăng xuất
  void logout() {
    AuthService.logout();
    token = null;
    role = null;
    isAuthenticated = false;
    userId = null;
    userData = null;
    notifyListeners();
  }

  /// Lấy thông tin người dùng sau khi đăng nhập
  Future<void> getUserData() async {
    if (token == null) return;
    final response = await ApiService.get("qrcode/myqrcode", token: token!);
    userData = response;
    userId = response['id']?.toString();
    notifyListeners();
  }
}
