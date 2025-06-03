import 'package:flutter/foundation.dart';
import 'package:fintechnic/models/admin_transaction.dart';
import 'api_service.dart';

class AdminTransactionService {
  final ApiService _apiService = ApiService();

  /// Get all transactions with pagination
  /// GET /api/admin/history
  Future<Map<String, dynamic>> getTransactions({int page = 0, int size = 10}) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        debugPrint("No token available for admin transactions request");
        return {"error": "Not authenticated"};
      }
      
      final response = await _apiService.get(
        "/api/admin/history",
        token: token,
        queryParams: {
          "page": page,
          "size": size,
        },
      );
      
      debugPrint("Admin Transactions Response: $response");
      
      if (response.containsKey("error")) {
        debugPrint("Error getting admin transactions: ${response['error']}");
        return {"error": response['error']};
      }
      
      // Transform the response data
      final List<AdminTransaction> transactions = [];
      final rawContent = response['content'] as List<dynamic>? ?? [];
      
      for (var item in rawContent) {
        try {
          final transaction = AdminTransaction.fromJson(item);
          transactions.add(transaction);
        } catch (e) {
          debugPrint("Error parsing transaction: $e");
        }
      }
      
      // Create the pagination data
      final pageInfo = response['page'] as Map<String, dynamic>? ?? {};
      final paginationData = PaginationData.fromJson(pageInfo);
      
      return {
        "transactions": transactions,
        "pagination": paginationData,
      };
    } catch (e) {
      debugPrint("Exception in getTransactions: $e");
      return {"error": e.toString()};
    }
  }

  /// Filter transactions
  /// POST /api/admin/filter
  Future<Map<String, dynamic>> filterTransactions(
    TransactionFilter filter, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        debugPrint("No token available for filter transactions request");
        return {"error": "Not authenticated"};
      }
      
      // Add pagination to the filter data
      final Map<String, dynamic> requestData = filter.toJson();
      requestData['page'] = page;
      requestData['size'] = size;
      
      debugPrint("Filter request data: $requestData");
      
      final response = await _apiService.post(
        "/api/admin/filter",
        requestData,
        token: token,
      );
      
      debugPrint("Filter Transactions Response: $response");
      
      if (response.containsKey("error")) {
        debugPrint("Error filtering transactions: ${response['error']}");
        return {"error": response['error']};
      }
      
      // Transform the response data
      final List<AdminTransaction> transactions = [];
      final rawContent = response['content'] as List<dynamic>? ?? [];
      
      for (var item in rawContent) {
        try {
          final transaction = AdminTransaction.fromJson(item);
          transactions.add(transaction);
        } catch (e) {
          debugPrint("Error parsing transaction: $e");
        }
      }
      
      // Create the pagination data
      final pageInfo = response['page'] as Map<String, dynamic>? ?? {};
      final paginationData = PaginationData.fromJson(pageInfo);
      
      return {
        "transactions": transactions,
        "pagination": paginationData,
      };
    } catch (e) {
      debugPrint("Exception in filterTransactions: $e");
      return {"error": e.toString()};
    }
  }
} 