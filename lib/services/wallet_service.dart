import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class WalletService {
  /// Admin function to search for a wallet by username
  static Future<Map<String, dynamic>?> searchWallet(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return null;
    final response = await ApiService.post(
      "/api/admin/transaction/search-wallet",
      {
        "username": username
      },
      token: token
    );

    debugPrint("Search Wallet Response: $response");
    if (response.containsKey("wallet")) {
      return response["wallet"];
    }

    return null;
  }


  static Future<bool> topUpAgentWallet(String phoneNumber, double amount, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return false;

    final response = await ApiService.post(
      "/api/admin/transaction/top-up",
      {
        "phoneNumber": phoneNumber,
        "amount": amount,
        "description": description
      },
      token: token
    );

    debugPrint("Top Up Agent Wallet Response: $response");

    return response.containsKey("success") && response["success"] == true;
  }

  /// Admin function to get wallet summary
  static Future<Map<String, dynamic>?> getWalletSummary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return null;

    final response = await ApiService.get("/api/admin/wallet/summary", token: token);

    debugPrint("Wallet Summary Response: $response");

    if (response.containsKey("summary")) {
      return response["summary"];
    }

    return null;
  }
}
