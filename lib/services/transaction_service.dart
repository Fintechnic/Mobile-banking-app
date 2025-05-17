import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class TransactionService {
  /// Transfer money to another user by phone number
  static Future<bool> transferMoney(String phoneNumber, double amount, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return false;
    final response = await ApiService.post(
      "/api/transaction/transfer",
      {
        "phoneNumber": phoneNumber,
        "amount": amount,
        "description": description
      },
      token: token
    );

    debugPrint("Transfer Money Response: $response");
    return response.containsKey("success") && response["success"] == true;
  }

  /// Withdraw money from user account
  static Future<bool> withdrawMoney(double amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return false;

    final response = await ApiService.post(
      "/api/transaction/withdraw",
      {
        "amount": amount
      },
      token: token
    );
    debugPrint("Withdraw Money Response: $response");
    return response.containsKey("success") && response["success"] == true;
  }

  /// Get transaction history for current user
  static Future<List<dynamic>> getTransactionHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return [];
    final response = await ApiService.get("/api/transaction/history", token: token);
    debugPrint("Transaction History Response: $response");
    if (response.containsKey("transactions")) {
      return response["transactions"];
    }

    return [];
  }

  /// Admin function to get all transactions
  static Future<List<dynamic>> getAdminTransactionHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return [];
    final response = await ApiService.get("/api/admin/history", token: token);
    debugPrint("Admin Transaction History Response: $response");
    if (response.containsKey("transactions")) {
      return response["transactions"];
    }

    return [];
  }

  /// Admin function to filter transactions
  static Future<List<dynamic>> filterTransactions({
    String sortBy = "createdAt",
    String sortDirection = "DESC",
    int page = 0,
    int size = 10
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return [];
    final response = await ApiService.post(
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
    if (response.containsKey("transactions")) {
      return response["transactions"];
    }

    return [];
  }
}
