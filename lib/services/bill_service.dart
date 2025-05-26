import 'package:flutter/foundation.dart';
import 'api_service.dart';

class BillService {
  final ApiService _apiService = ApiService();

  /// Get user bills
  Future<List<dynamic>> getUserBills() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return [];

      final response = await _apiService.get("/api/bills", token: token);
      if (!response.containsKey("error")) {
        return response["bills"] ?? [];
      }
      return [];
    } catch (e) {
      debugPrint("Get bills error: $e");
      return [];
    }
  }

  /// Pay bill
  Future<bool> payBill(String billId) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.post(
        "/api/bills/$billId/pay",
        {},
        token: token,
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Pay bill error: $e");
      return false;
    }
  }

  /// Create new bill (Admin only)
  Future<bool> createBill({
    required String type,
    required String phoneNumber,
    required double amount,
  }) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.post(
        "/api/admin/new-bill",
        {
          "type": type,
          "phoneNumber": phoneNumber,
          "amount": amount,
        },
        token: token,
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Create bill error: $e");
      return false;
    }
  }
}