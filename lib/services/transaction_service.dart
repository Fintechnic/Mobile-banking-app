import 'package:flutter/foundation.dart';
import 'api_service.dart';

class TransactionService {
  final ApiService _apiService = ApiService();

  /// Chuyển tiền cho người dùng khác qua số điện thoại
  Future<bool> transferMoney(String phoneNumber, double amount,
      {String? description}) async {
    final token = await _apiService.getToken();
    if (token == null) return false;

    final Map<String, dynamic> requestBody = {
      "phoneNumber": phoneNumber,
      "amount": amount,
    };

    if (description != null) {
      requestBody["description"] = description;
    }

    final response = await _apiService
        .post("/api/transaction/transfer", requestBody, token: token);

    debugPrint("Transfer Money Response: $response");
    return !response.containsKey("error");
  }

  /// Rút tiền từ tài khoản
  Future<bool> withdrawMoney(double amount) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await withdraw(amount, token: token);

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Withdraw Money Error: $e");
      return false;
    }
  }

  /// Lấy lịch sử giao dịch của người dùng hiện tại
  Future<List<dynamic>> getTransactionHistory() async {
    final token = await _apiService.getToken();
    debugPrint(
        "Token for transaction history: ${token != null ? 'exists' : 'null'}");

    if (token == null) return [];

    try {
      final response =
          await _apiService.get("/api/transaction/history", token: token);
      debugPrint("Transaction History Full Response: $response");

      if (response.containsKey("error")) {
        debugPrint("Transaction History Error: ${response['error']}");
        return [];
      }

      List<dynamic> result = [];
      if (!response.containsKey("data")) {
        debugPrint("Transaction History Response has no data key: $response");
        // If the API doesn't wrap the response in a data field, check if the response itself is the data
        if (response.containsKey("transactions")) {
          debugPrint("Found transactions key in response");
          result = response["transactions"] ?? [];
        }

        // If we have an array directly in the response
        else if (response.containsKey("content") &&
            response["content"] is List) {
          debugPrint("Found content key with list in response");
          result = response["content"] ?? [];
        }

        // Try to determine if the response itself is the list of transactions
        else if (response.values.any((v) => v is List)) {
          for (var key in response.keys) {
            if (response[key] is List) {
              debugPrint("Found list in response at key: $key");
              result = response[key];
              break;
            }
          }
        }

        // Last resort: return the response itself as a single-item list
        else {
          debugPrint("Returning response map as a single-item list");
          result = [response];
        }
      } else {
        final data = response["data"];
        debugPrint(
            "Transaction History Data: $data (type: ${data.runtimeType})");

        if (data is List) {
          result = data;
        } else if (data is Map<String, dynamic>) {
          // Some APIs might wrap the transactions in another object
          if (data.containsKey("transactions")) {
            result = data["transactions"] ?? [];
          }
          // Or use a 'content' field (Spring Data pattern)
          else if (data.containsKey("content") && data["content"] is List) {
            result = data["content"] ?? [];
          } else {
            // Single transaction returned as a map
            result = [data];
          }
        }
      }

      // Enhanced logging - inspect each transaction
      debugPrint("Parsed ${result.length} transactions from API response");
      for (var i = 0; i < result.length; i++) {
        var tx = result[i];
        debugPrint("Transaction $i: id=${tx['id']}, amount=${tx['amount']}, "
            "type=${tx['type'] ?? tx['transaction_code']}, "
            "description=${tx['description']}");
      }

      return result;
    } catch (e) {
      debugPrint("Exception in getTransactionHistory: $e");
      return [];
    }
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
  Future<List<dynamic>> filterTransactions(
      {String sortBy = "createdAt",
      String sortDirection = "DESC",
      int page = 0,
      int size = 10,
      String? type,
      String? status,
      DateTime? startDate,
      DateTime? endDate,
      double? minAmount,
      double? maxAmount}) async {
    final token = await _apiService.getToken();
    debugPrint(
        "Token for filter transactions: ${token != null ? 'exists' : 'null'}");

    if (token == null) return [];

    final requestBody = {
      "sortBy": sortBy,
      "sortDirection": sortDirection,
      "page": page,
      "size": size
    };

    // Add optional filters if provided
    if (type != null) requestBody["type"] = type;
    if (status != null) requestBody["status"] = status;
    if (startDate != null) {
      requestBody["startDate"] = startDate.toIso8601String();
    }
    if (endDate != null) requestBody["endDate"] = endDate.toIso8601String();
    if (minAmount != null) requestBody["minAmount"] = minAmount;
    if (maxAmount != null) requestBody["maxAmount"] = maxAmount;

    debugPrint("Filter Transactions Request: $requestBody");

    final response =
        await _apiService.post("/api/admin/filter", requestBody, token: token);

    debugPrint("Filter Transactions Full Response: $response");

    if (response.containsKey("error")) {
      debugPrint("Filter Transactions Error: ${response['error']}");
      return [];
    }

    if (!response.containsKey("data")) {
      debugPrint("Filter Transactions Response has no data key: $response");

      // If the API doesn't wrap the response in a data field, check for other common patterns
      if (response.containsKey("transactions")) {
        debugPrint("Found transactions key in response");
        return response["transactions"] ?? [];
      }

      // Check for Spring Data pagination format
      if (response.containsKey("content") && response["content"] is List) {
        debugPrint("Found content key with list in response");
        return response["content"] ?? [];
      }

      // Try to determine if the response itself is the list of transactions
      if (response.values.any((v) => v is List)) {
        for (var key in response.keys) {
          if (response[key] is List) {
            debugPrint("Found list in response at key: $key");
            return response[key];
          }
        }
      }

      // Last resort: return the response itself if it's a map
      debugPrint("Returning response map as a single-item list");
      return [response];
    }

    final data = response["data"];
    debugPrint("Filter Transactions Data: $data (type: ${data.runtimeType})");

    if (data is List) {
      return data;
    } else if (data is Map<String, dynamic>) {
      // Some APIs might wrap the transactions in another object
      if (data.containsKey("transactions")) {
        return data["transactions"] ?? [];
      }
      // Or use a 'content' field (Spring Data pattern)
      if (data.containsKey("content") && data["content"] is List) {
        return data["content"] ?? [];
      }

      // Single transaction returned as a map
      return [data];
    }

    return [];
  }

  // Withdraw money from user's wallet
  Future<Map<String, dynamic>> withdraw(double amount, {String? token}) async {
    try {
      final actualToken = token ?? await _apiService.getToken();
      if (actualToken == null) {
        return {"error": "No authentication token available"};
      }

      final response = await _apiService.post(
        '/api/transaction/withdraw',
        {'amount': amount},
        token: actualToken,
      );
      return response;
    } catch (e) {
      debugPrint("Withdraw Error: $e");
      return {"error": e.toString()};
    }
  }

  /// Tìm kiếm giao dịch
  Future<List<dynamic>> searchTransactionHistory(String query) async {
    final token = await _apiService.getToken();
    debugPrint(
        "Token for transaction search: ${token != null ? 'exists' : 'null'}");

    if (token == null) return [];

    // Build query parameters
    final params = {'query': query};

    try {
      final response = await _apiService.get("/api/transaction/history",
          token: token,
          queryParams:
              params // Ensure this matches the parameter name in _apiService.get method
          );

      debugPrint("Transaction Search Response: $response");

      if (response.containsKey("error")) {
        debugPrint("Transaction Search Error: ${response['error']}");
        return [];
      }

      if (!response.containsKey("data")) {
        debugPrint("Transaction Search Response has no data key: $response");
        // Handle various response formats like in getTransactionHistory
        if (response.containsKey("transactions")) {
          return response["transactions"] ?? [];
        }

        if (response.containsKey("content") && response["content"] is List) {
          return response["content"] ?? [];
        }

        if (response.values.any((v) => v is List)) {
          for (var key in response.keys) {
            if (response[key] is List) {
              return response[key];
            }
          }
        }

        return [response];
      }

      final data = response["data"];

      if (data is List) {
        return data;
      } else if (data is Map<String, dynamic>) {
        if (data.containsKey("transactions")) {
          return data["transactions"] ?? [];
        }
        if (data.containsKey("content") && data["content"] is List) {
          return data["content"] ?? [];
        }

        return [data];
      }

      return [];
    } catch (e) {
      debugPrint("Error in searchTransactionHistory: $e");
      return [];
    }
  }
}
