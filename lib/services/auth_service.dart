import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Login user
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      debugPrint("Logging in user: $username");
      final response = await _apiService.post(
        "/api/auth/login",
        {
          "username": username,
          "password": password,
        },
      );

      if (!response.containsKey("error")) {
        debugPrint("Login successful: ${response["token"] != null}");
        await _apiService.saveToken(response["token"]);
        // Store username and role in secure storage
        await _storage.write(key: 'username', value: username);
        if (response.containsKey("role")) {
          await _storage.write(key: 'role', value: response["role"]);
        }
        return response;
      }
      debugPrint("Login response error: ${response["error"]}");
      return null;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  /// Register new user
  Future<Map<String, dynamic>?> register({
    required String username,
    required String password,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      debugPrint("Registering user: $username, email: $email, phone: $phoneNumber");
      final response = await _apiService.post(
        "/api/auth/register",
        {
          "username": username,
          "password": password,
          "email": email,
          "phoneNumber": phoneNumber,
        },
      );

      if (!response.containsKey("error")) {
        debugPrint("Registration successful: $response");
        return response;
      }
      
      // Log the specific error
      String errorMessage = response["error"] ?? "Unknown error";
      debugPrint("Registration error: $errorMessage");
      
      // Extract specific validation errors if available
      if (errorMessage.contains("Validation failed") && errorMessage.contains("propertyPath=")) {
        // Try to extract the field and message from the validation error
        RegExp regex = RegExp('propertyPath=(\\w+).*?interpolatedMessage=\'([^\']+)\'');
        final match = regex.firstMatch(errorMessage);
        if (match != null && match.groupCount >= 2) {
          final field = match.group(1);
          final message = match.group(2);
          return { 
            "error": message ?? "Validation error",
            "field": field ?? "unknown",
          };
        }
      }
      
      return {"error": errorMessage};
    } catch (e) {
      debugPrint("Register error: $e");
      return {"error": e.toString()};
    }
  }

  /// Logout user
  Future<bool> logout(String username) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.post(
        "/api/auth/logout",
        {"username": username},
        token: token,
      );

      await _apiService.deleteToken();
      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Logout error: $e");
      return false;
    }
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return null;

      final response = await _apiService.get(
        "/api/users/me",
        token: token,
      );

      if (!response.containsKey("error")) {
        return response;
      }
      debugPrint("Get user data error: ${response["error"]}");
      return null;
    } catch (e) {
      debugPrint("Get user data error: $e");
      return null;
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      final response = await _apiService.post(
        "/api/auth/reset-password",
        {"email": email},
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Reset password error: $e");
      return false;
    }
  }

  /// Verify reset password token
  Future<bool> verifyResetToken(String token) async {
    try {
      final response = await _apiService.post(
        "/api/auth/verify-reset-token",
        {"token": token},
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Verify reset token error: $e");
      return false;
    }
  }

  /// Set new password after reset
  Future<bool> setNewPassword(String token, String newPassword) async {
    try {
      final response = await _apiService.post(
        "/api/auth/set-new-password",
        {
          "token": token,
          "newPassword": newPassword,
        },
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Set new password error: $e");
      return false;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null;
  }

  /// Get stored user role
  Future<String?> getStoredRole() async {
    return await _storage.read(key: 'role');
  }

  /// Get stored username
  Future<String?> getStoredUsername() async {
    return await _storage.read(key: 'username');
  }

  // Admin functions
  /// Unlock user (admin only)
  Future<bool> unlockUser(String userId, String username) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.post(
        "/api/admin/user/$userId/unlock",
        {"username": username},
        token: token,
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Unlock user error: $e");
      return false;
    }
  }

  /// Update user role (admin only)
  Future<bool> updateRole(String userId, String newRole) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.post(
        "/api/admin/user/$userId/update-role",
        {"newRole": newRole},
        token: token,
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Update role error: $e");
      return false;
    }
  }

  /// Search users (admin only)
  Future<List<dynamic>> searchUsers({String? username, String? email}) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return [];

      final response = await _apiService.post(
        "/api/admin/users/search",
        {
          if (username != null) "username": username,
          if (email != null) "email": email,
        },
        token: token,
      );

      return response["users"] ?? [];
    } catch (e) {
      debugPrint("Search users error: $e");
      return [];
    }
  }

  /// Get user details (admin only)
  Future<Map<String, dynamic>?> getUserDetail(String userId) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return null;

      final response = await _apiService.get(
        "/api/admin/user/$userId",
        token: token,
      );

      if (!response.containsKey("error")) {
        return response;
      }
      return null;
    } catch (e) {
      debugPrint("Get user detail error: $e");
      return null;
    }
  }
}