import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../models/auth_response.dart';


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
      debugPrint("Auth status check error: $e");
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

      if (username.isEmpty || password.isEmpty) {
        error = "Username and password cannot be empty";
        return false;
      }

      final response = await _authService.login(username, password);
      
      if (response != null) {
        _handleAuthSuccess(response);
        return true;
      } else {
        error = 'Login failed. Please check your username and password.';
        return false;
      }
    } catch (e) {
      debugPrint("Login provider error: $e");
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

      // Basic validation
      if (username.isEmpty || password.isEmpty || email.isEmpty || phoneNumber.isEmpty) {
        error = "All fields are required";
        return false;
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        error = "Please enter a valid email address";
        return false;
      }
      
      // Phone number validation
      if (!phoneNumber.startsWith('0') || phoneNumber.length < 10 || phoneNumber.length > 11) {
        error = "Please enter a valid phone number (starting with 0)";
        return false;
      }
      
      if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
        error = "Phone number should only contain digits";
        return false;
      }

      final response = await _authService.register(
        username: username,
        password: password,
        email: email,
        phoneNumber: phoneNumber,
      );
      
      if (response != null) {
        // Check if there's an error in the response
        if (response.containsKey("error")) {
          error = response["error"];
          
          // If we have a specific field with an error, enhance the error message
          if (response.containsKey("field")) {
            String field = response["field"];
            if (field == "phoneNumber") {
              error = "Phone number validation failed: $error";
            } else if (field == "email") {
              error = "Email validation failed: $error";
            } else if (field == "username") {
              error = "Username validation failed: $error";
            } else if (field == "password") {
              error = "Password validation failed: $error";
            }
          }
          
          return false;
        }
        return true;
      } else {
        error = 'Registration failed. Please check your information and try again.';
        return false;
      }
    } catch (e) {
      debugPrint("Register provider error: $e");
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
      debugPrint("Logout provider error: $e");
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
      debugPrint("Get user data provider error: $e");
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
      debugPrint("Reset password provider error: $e");
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
      debugPrint("Verify reset token provider error: $e");
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
      debugPrint("Set new password provider error: $e");
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
    try {
      final authResponse = AuthResponse.fromJson(response);
      token = authResponse.token;
      role = authResponse.role;
      username = authResponse.username;
      userId = authResponse.userId;
      userData = response;
      isAuthenticated = true;
      error = null;
    } catch (e) {
      debugPrint("Auth response parsing error: $e");
      error = "Failed to parse authentication response";
      isAuthenticated = false;
    }
  }
}