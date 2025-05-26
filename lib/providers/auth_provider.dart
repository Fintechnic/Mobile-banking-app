import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../models/auth_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;


class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();
  
  String? token;
  String? role;
  String? username;
  bool isAuthenticated = false;
  String? userId;
  Map<String, dynamic>? userData;
  bool isLoading = false;
  String? error;

  AuthProvider() {
    checkAuthStatus();
  }

  /// Check authentication status on app start
  Future<void> checkAuthStatus() async {
    try {
      isLoading = true;
      notifyListeners();

      token = await _apiService.getToken();
      if (token != null) {
        role = await _authService.getStoredRole();
        username = await _authService.getStoredUsername();
        final response = await _authService.getUserData();
        if (response != null) {
          _handleAuthSuccess(response);
        } else {
          await logout();
        }
      }
    } catch (e) {
      error = e.toString();
      await logout();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Login user
  Future<bool> login(String username, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _authService.login(username, password);
      
      if (response != null) {
        _handleAuthSuccess(response);
        return true;
      } else {
        error = 'Login failed';
        return false;
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Register new account
  Future<bool> register(String username, String password, String email, String phoneNumber) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _authService.register(
        username: username,
        password: password,
        email: email,
        phoneNumber: phoneNumber,
      );
      
      if (response != null) {
        return true;
      } else {
        error = 'Registration failed';
        return false;
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      isLoading = true;
      notifyListeners();

      if (username != null) {
        await _authService.logout(username!);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      // Clear all auth data regardless of logout API success
      token = null;
      role = null;
      username = null;
      userId = null;
      userData = null;
      isAuthenticated = false;
      await _apiService.deleteToken();
      
      isLoading = false;
      notifyListeners();
    }
  }

  /// Get user data
  Future<void> getUserData() async {
    try {
      if (token == null) return;
      
      isLoading = true;
      notifyListeners();
      
      final response = await _authService.getUserData();
      if (response != null) {
        userData = response;
        userId = response['id']?.toString();
      } else {
        error = 'Failed to get user data';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      return await _authService.resetPassword(email);
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Verify reset password token
  Future<bool> verifyResetToken(String token) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      return await _authService.verifyResetToken(token);
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Set new password after reset
  Future<bool> setNewPassword(String token, String newPassword) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      return await _authService.setNewPassword(token, newPassword);
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    error = null;
    notifyListeners();
  }

  /// Check if user is admin
  bool isAdmin() {
    return role?.toUpperCase() == "ADMIN";
  }

  /// Check if user is agent
  bool isAgent() {
    return role?.toUpperCase() == "AGENT";
  }

  /// Handle successful authentication
  void _handleAuthSuccess(Map<String, dynamic> response) {
    final authResponse = AuthResponse.fromJson(response);
    token = authResponse.token;
    role = authResponse.role;
    username = authResponse.username;
    userId = authResponse.userId;
    userData = response;
    isAuthenticated = true;
    error = null;
  }
}