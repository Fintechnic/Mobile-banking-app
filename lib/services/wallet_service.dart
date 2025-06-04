import 'package:flutter/foundation.dart';
import 'api_service.dart';

class WalletService {
  final ApiService _apiService = ApiService();
  /// Top up user wallet by admin
  Future<Map<String, dynamic>> adminTopUp(String phoneNumber, double amount, {String? description}) async {
    final token = await _apiService.getToken();
    if (token == null) return {"error": "Not authenticated"};
    
    final Map<String, dynamic> requestBody = {
      "phoneNumber": phoneNumber,
      "amount": amount,
    };
    
    if (description != null && description.isNotEmpty) {
      requestBody["description"] = description;
    }

    final response = await _apiService.post(
      "/api/admin/transaction/top-up",
      requestBody,
      token: token
    );

    debugPrint("Admin Top-up Response: $response");
    return response;
  }

  /// Lấy tổng quan về ví (dành cho admin)
  Future<Map<String, dynamic>?> getWalletSummary() async {
    final token = await _apiService.getToken();
    if (token == null) return null;

    final response = await _apiService.get("/api/admin/wallet/summary", token: token);
    debugPrint("Wallet Summary Response: $response");
    
    if (response.containsKey("error")) {
      return null;
    }
    
    return response;
  }
}