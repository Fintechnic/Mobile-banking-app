import 'package:flutter/foundation.dart';
import 'api_service.dart';

class TransactionService {
  final ApiService _apiService = ApiService();

  /// Chuyển tiền cho người dùng khác qua số điện thoại
  Future<bool> transferMoney(String phoneNumber, double amount, String description) async {
    final token = await _apiService.getToken();
    if (token == null) return false;
    
    final response = await _apiService.post(
      "/api/transaction/transfer",
      {
        "phoneNumber": phoneNumber,
        "amount": amount,
        "description": description
      },
      token: token
    );

    debugPrint("Transfer Money Response: $response");
    return !response.containsKey("error");
  }

  /// Rút tiền từ tài khoản
  Future<bool> withdrawMoney(double amount) async {
    final token = await _apiService.getToken();
    if (token == null) return false;

    final response = await _apiService.post(
      "/api/transaction/withdraw",
      {
        "amount": amount
      },
      token: token
    );
    
    debugPrint("Withdraw Money Response: $response");
    return !response.containsKey("error");
  }

  /// Lấy lịch sử giao dịch của người dùng hiện tại
  Future<List<dynamic>> getTransactionHistory() async {
    final token = await _apiService.getToken();
    if (token == null) return [];
    
    final response = await _apiService.get("/api/transaction/history", token: token);
    debugPrint("Transaction History Response: $response");
    
    return response["data"] ?? [];
  }

  /// Lấy lịch sử giao dịch (dành cho admin)
  Future<List<dynamic>> getAdminTransactionHistory() async {
    final token = await _apiService.getToken();
    if (token == null) return [];
    
    final response = await _apiService.get("/api/admin/history", token: token);
    debugPrint("Admin Transaction History Response: $response");
    
    return response["data"] ?? [];
  }

  /// Lọc giao dịch (dành cho admin)
  Future<List<dynamic>> filterTransactions({
    String sortBy = "createdAt",
    String sortDirection = "DESC",
    int page = 0,
    int size = 10
  }) async {
    final token = await _apiService.getToken();
    if (token == null) return [];
    
    final response = await _apiService.post(
      "/api/admin/filter",
      {
        "sortBy": sortBy,
        "sortDirection": sortDirection,
        "page": page,
        "size": size
      },
      token: token
    );

    debugPrint("Filter Transactions Response: $response");
    return response["data"] ?? [];
  }
}