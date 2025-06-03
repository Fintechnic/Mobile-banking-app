import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();
  final UserService _userService = UserService();
  
  List<User> _users = [];
  User? _selectedUser;
  Map<String, dynamic>? _userDetail;
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? userData;
  
  // Pagination data
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  int _pageSize = 10;
  
  List<User> get users => _users;
  User? get selectedUser => _selectedUser;
  Map<String, dynamic>? get userDetail => _userDetail;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  int get pageSize => _pageSize;
  bool get hasNextPage => _currentPage < _totalPages - 1;
  bool get hasPreviousPage => _currentPage > 0;
  
  /// Get list of users for admin dashboard
  Future<void> fetchUsers({String? usernameFilter, bool resetPage = true}) async {
    try {
      isLoading = true;
      error = null;
      
      if (resetPage) {
        _currentPage = 0;
      }
      
      notifyListeners();
      
      final response = await _userService.getUsers(
        username: usernameFilter,
        page: _currentPage,
        size: _pageSize,
      );
      
      if (response != null && response.containsKey('content')) {
        final List<dynamic> userList = response['content'];
        _users = userList.map((json) => User.fromJson(json)).toList();
        
        // Update pagination info if available
        if (response.containsKey('page')) {
          final pageInfo = response['page'];
          _totalPages = pageInfo['totalPages'] ?? 1;
          _totalElements = pageInfo['totalElements'] ?? userList.length;
          _currentPage = pageInfo['number'] ?? 0;
          _pageSize = pageInfo['size'] ?? 10;
        }
      } else {
        error = "Failed to load users";
        _users = [];
      }
    } catch (e) {
      error = e.toString();
      _users = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load the next page of users
  Future<void> nextPage({String? usernameFilter}) async {
    if (hasNextPage) {
      _currentPage++;
      await fetchUsers(usernameFilter: usernameFilter, resetPage: false);
    }
  }
  
  /// Load the previous page of users
  Future<void> previousPage({String? usernameFilter}) async {
    if (hasPreviousPage) {
      _currentPage--;
      await fetchUsers(usernameFilter: usernameFilter, resetPage: false);
    }
  }
  
  /// Get user details by ID
  Future<void> getUserDetailsById(int userId) async {
    try {
      isLoading = true;
      error = null;
      _selectedUser = null;
      notifyListeners();
      
      final response = await _userService.getUserDetails(userId);
      
      if (response != null) {
        _userDetail = response;
        _selectedUser = User.fromJson(response);
      } else {
        error = "Failed to get user details";
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  /// Unlock user by username
  Future<bool> unlockUserByUsername(String username) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _userService.unlockUserByUsername(username);
      
      if (!success) {
        error = "Failed to unlock user account";
      }
      
      return success;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  /// Update user role
  Future<bool> updateUserRole(int userId, String newRole) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _userService.updateUserRole(userId, newRole);
      
      if (success) {
        // Refresh user details
        await getUserDetailsById(userId);
      } else {
        error = "Failed to update user role";
      }
      
      return success;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  /// Reset user password
  Future<bool> resetUserPassword(int userId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _userService.resetUserPassword(userId);
      
      if (!success) {
        error = "Failed to reset user password";
      }
      
      return success;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  /// Reset user password with custom password
  Future<bool> resetUserPasswordWithCustomPassword(int userId, String newPassword) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _userService.resetUserPasswordWithCustomPassword(userId, newPassword);
      
      if (!success) {
        error = "Failed to reset user password";
      }
      
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