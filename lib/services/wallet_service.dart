import 'package:flutter/foundation.dart';
import 'api_service.dart';

class WalletService {
  final ApiService _apiService = ApiService();

  /// Tìm kiếm ví theo tên người dùng (dành cho admin)
  Future<Map<String, dynamic>?> searchWallet(String username) async {
    final token = await _apiService.getToken();
    if (token == null) return null;
    
    final response = await _apiService.post(
      "/api/admin/transaction/search-wallet",
      {
        "username": username
      },
      token: token
    );

    debugPrint("Search Wallet Response: $response");
    
    if (response.containsKey("error")) {
      return null;
    }
    
    return response;
  }

  /// Nạp tiền vào ví đại lý (dành cho admin)
  Future<bool> topUpAgentWallet(String phoneNumber, double amount, String description) async {
    final token = await _apiService.getToken();
    if (token == null) return false;

    final response = await _apiService.post(
      "/api/admin/transaction/top-up",
      {
        "phoneNumber": phoneNumber,
        "amount": amount,
        "description": description
      },
      token: token
    );

    debugPrint("Top Up Agent Wallet Response: $response");
    return !response.containsKey("error");
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