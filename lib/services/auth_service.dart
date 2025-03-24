import '../models/auth_response.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // ✅ Import this for debugPrint

class AuthService {
  static Future<AuthResponse?> login(String username, String password) async {
    final response = await ApiService.post("login", {"username": username, "password": password});

    debugPrint("Login API Response: $response");

    if (response.containsKey("token")) {
      AuthResponse authResponse = AuthResponse.fromJson(response);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", authResponse.token);
      await prefs.setString("role", authResponse.role);
      return authResponse;
    }
    return null;
  }



  static Future<bool> register(String username, String password, String email) async {
    final response = await ApiService.post("register", {
      "username": username,
      "password": password,
      "email": email,
    });

    return response.containsKey("username");
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("role");
  }
}
