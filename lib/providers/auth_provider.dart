import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/auth_response.dart';

class AuthProvider extends ChangeNotifier {
  String? token;
  String? role;
  bool isAuthenticated = false;

  AuthProvider() {
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    role = prefs.getString("role");

    if (token != null) {
      isAuthenticated = true;
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    AuthResponse? authResponse = await AuthService.login(username, password);
    if (authResponse != null) {
      token = authResponse.token;
      role = authResponse.role;
      isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password, String email) async {
    bool success = await AuthService.register(username, password, email);
    notifyListeners();
    return success;
  }

  void logout() {
    AuthService.logout();
    token = null;
    role = null;
    isAuthenticated = false;
    notifyListeners();
  }
}
