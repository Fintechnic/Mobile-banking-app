import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class BillService {
  static Future<List<dynamic>> getUserBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return [];
    final response = await ApiService.get("/api/bills", token: token);
    debugPrint("Get Bills Response: $response");
    if (response.containsKey("bills")) {
      return response["bills"];
    }
    
    return [];
  }
  
  /// Pay a specific bill by ID
  static Future<bool> payBill(int billId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return false;
    final response = await ApiService.post(
      "/api/bills/$billId/pay", 
      {}, 
      token: token
    );
    
    debugPrint("Pay Bill Response: $response");
    return response.containsKey("success") && response["success"] == true;
  }
  
  /// Admin function to create a new bill
  static Future<bool> createBill(String type, String phoneNumber, double amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return false;
    final response = await ApiService.post(
      "/api/admin/new-bill", 
      {
        "type": type,
        "phoneNumber": phoneNumber,
        "amount": amount
      },
      token: token
    );
    
    debugPrint("Create Bill Response: $response");
    
    return response.containsKey("id"); 
  }
}
