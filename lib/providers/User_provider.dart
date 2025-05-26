import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();
  
  List<dynamic> _users = [];
  Map<String, dynamic>? _userDetail;
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? userData;
  
  List<dynamic> get users => _users;
  Map<String, dynamic>? get userDetail => _userDetail;
  
  /// Search users (Admin)
  Future<void> searchUsers({String? username, String? email}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      _users = await _authService.searchUsers(username: username, email: email);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  /// Get user details (Admin)
  Future<void> getUserDetail(String userId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      _userDetail = await _authService.getUserDetail(userId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  /// Reset password (Admin)
  Future<bool> resetUserPassword(String userId, String newPassword) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _authService.updateRole(userId, newPassword);
      return success;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  /// Update role (Admin)
  Future<bool> updateRole(String userId, String newRole) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _authService.updateRole(userId, newRole);
      return success;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  /// Unlock user (Admin)
  Future<bool> unlockUser(String userId, String username) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _authService.unlockUser(userId, username);
      return success;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  /// Get user profile data
  Future<void> getUserProfile() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _authService.getUserData();
      if (response != null) {
        userData = response;
      } else {
        error = "Failed to get user data";
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? email,
    String? phoneNumber,
    String? fullName,
    String? address,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.put(
        "/api/users/profile",
        {
          if (email != null) "email": email,
          if (phoneNumber != null) "phoneNumber": phoneNumber,
          if (fullName != null) "fullName": fullName,
          if (address != null) "address": address,
        },
        token: token,
      );

      if (!response.containsKey("error")) {
        userData = response;
        return true;
      }
      error = response["error"];
      return false;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.put(
        "/api/users/password",
        {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        },
        token: token,
      );

      if (response.containsKey("error")) {
        error = response["error"];
        return false;
      }
      return true;
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
}