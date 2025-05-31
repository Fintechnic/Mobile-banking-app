import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class UserService {
  /// Tìm kiếm và lấy danh sách người dùng (admin)
  static Future<List<dynamic>> searchUsers({Map<String, dynamic>? filter}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return [];
    final response = await ApiService.post(
      "/api/admin/user",
      filter ?? {},
      token: token,
    );
    if (response.containsKey("users")) {
      return response["users"];
    }
    // Nếu backend trả về list trực tiếp
    if (response is List) return response;
    return [];
  }

  /// Lấy chi tiết người dùng theo userId (admin)
  static Future<Map<String, dynamic>?> getUserDetail(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return null;
    final response = await ApiService.get("/api/admin/$userId", token: token);
    if (response.isNotEmpty) return response;
    return null;
  }

  /// Reset mật khẩu người dùng theo userId (admin)
  static Future<bool> resetUserPassword(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return false;
    final response = await ApiService.post(
      "/api/admin/user/$userId/reset-password",
      {},
      token: token,
    );
    // Giả định backend trả về success hoặc message
    return response['success'] == true || response['message'] == 'Reset password successful';
  }

  /// Thay đổi role người dùng theo userId (admin)
  static Future<bool> updateUserRole(String userId, String newRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return false;
    final response = await ApiService.post(
      "/api/admin/user/$userId/update-role",
      {"role": newRole},
      token: token,
    );
    // Giả định backend trả về success hoặc message
    return response['success'] == true || response['message'] == 'Update role successful';
  }

  /// Mở khóa người dùng theo userId (admin)
  static Future<bool> unlockUser(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return false;
    final response = await ApiService.post(
      "/api/admin/user/unlock",
      {"userId": userId},
      token: token,
    );
    // Giả định backend trả về success hoặc message
    return response['success'] == true || response['message'] == 'Unlock successful';
  }
} 