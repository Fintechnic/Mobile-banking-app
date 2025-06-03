import 'package:flutter/foundation.dart';
import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  /// Get list of all users with optional username filter
  /// POST /api/admin/user
  Future<Map<String, dynamic>?> getUsers({
    String? username,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        debugPrint("No token available for user list request");
        return null;
      }
      
      final Map<String, dynamic> requestBody = {
        "page": page,
        "size": size,
      };
      
      // Add username filter if provided
      if (username != null && username.isNotEmpty) {
        requestBody["username"] = username;
      }
      
      final response = await _apiService.post(
        "/api/admin/user",
        requestBody,
        token: token,
      );
      
      debugPrint("Get Users Response: $response");
      
      if (response.containsKey("error")) {
        debugPrint("Error getting users: ${response['error']}");
        return null;
      }
      
      return response;
    } catch (e) {
      debugPrint("Exception in getUsers: $e");
      return null;
    }
  }

  /// Get detailed user information by ID
  /// GET /api/admin/user/{userId}
  Future<Map<String, dynamic>?> getUserDetails(int userId) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        debugPrint("No token available for user details request");
        return null;
      }
      
      final response = await _apiService.get(
        "/api/admin/user/$userId",
        token: token,
      );
      
      debugPrint("Get User Details Response: $response");
      
      if (response.containsKey("error")) {
        debugPrint("Error getting user details: ${response['error']}");
        return null;
      }
      
      return response;
    } catch (e) {
      debugPrint("Exception in getUserDetails: $e");
      return null;
    }
  }

  /// Unlock account by username
  /// POST /api/admin/user/unlock
  Future<bool> unlockUserByUsername(String username) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;
      
      final response = await _apiService.post(
        "/api/admin/user/unlock",
        {"username": username},
        token: token,
      );
      
      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Exception in unlockUserByUsername: $e");
      return false;
    }
  }

  /// Update user role
  /// POST /api/admin/user/{userId}/update-role
  Future<bool> updateUserRole(int userId, String newRole) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;
      
      // Make sure the role is one of the valid roles and is uppercase
      final validRole = newRole.trim().toUpperCase();
      debugPrint("Updating user $userId to role: $validRole");
      
      // Create the request body with the new role
      final Map<String, dynamic> requestBody = {"newRole": validRole};
      debugPrint("Request body: $requestBody");
      
      final response = await _apiService.post(
        "/api/admin/user/$userId/update-role",
        requestBody,
        token: token,
      );
      
      debugPrint("Update user role response: $response");
      
      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Exception in updateUserRole: $e");
      return false;
    }
  }

  /// Reset user password
  Future<bool> resetUserPassword(int userId) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;
      
      debugPrint("Resetting password for user $userId (auto-generate)");
      
      final response = await _apiService.post(
        "/api/admin/user/$userId/reset-password",
        {},  // Empty body
        token: token,
      );
      
      debugPrint("Reset password response: $response");
      
      // If we have success or success flag, consider it successful
      if (response.containsKey("success") || !response.containsKey("error")) {
        return true;
      }
      
      debugPrint("Reset password failed: ${response['error']}");
      return false;
    } catch (e) {
      debugPrint("Exception in resetUserPassword: $e");
      return false;
    }
  }
  
  /// Reset user password with custom password
  /// POST /api/admin/user/{userId}/reset-password
  Future<bool> resetUserPasswordWithCustomPassword(int userId, String newPassword) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;
      
      debugPrint("Resetting password for user $userId with custom password");
      
      // Create request body with the new password
      final Map<String, dynamic> requestBody = {"newPassword": newPassword};
      debugPrint("Request body: $requestBody");
      
      final response = await _apiService.post(
        "/api/admin/user/$userId/reset-password",
        requestBody,
        token: token,
      );
      
      debugPrint("Reset password with custom password response: $response");
      
      // If we have success or success flag, consider it successful
      if (response.containsKey("success") || !response.containsKey("error")) {
        return true;
      }
      
      debugPrint("Reset password with custom password failed: ${response['error']}");
      return false;
    } catch (e) {
      debugPrint("Exception in resetUserPasswordWithCustomPassword: $e");
      return false;
    }
  }
} 