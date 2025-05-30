import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QRCodeService {
  final ApiService _apiService = ApiService();

  // Return the API host
  String getApiHost() {
    return dotenv.get('API_HOST', fallback: ApiService.defaultHost);
  }
  
  // Return the API port
  String getApiPort() {
    return dotenv.get('API_PORT', fallback: ApiService.defaultPort);
  }
  
  // Get authentication token
  Future<String?> getMyToken() async {
    return await _apiService.getToken();
  }

  /// Generate QR code for payment
  Future<Map<String, dynamic>> generateQRCode({
    required String userId,
    required double amount,
    String? description,
  }) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return {"error": "No token found"};

      final response = await _apiService.post(
        "/api/qrcode/generate",
        {
          "userId": userId,
          "amount": amount,
          if (description != null) "description": description,
        },
        token: token,
      );

      if (!response.containsKey("error")) {
        return response;
      }
      return {"error": "Failed to generate QR code"};
    } catch (e) {
      debugPrint("Generate QR code error: $e");
      return {"error": e.toString()};
    }
  }

  /// Get current user's QR code
  Future<String?> getMyQRCode() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        debugPrint("QR Code error: No authentication token available");
        return null;
      }
      
      // For security, only show part of the token in logs
      final tokenPreview = token.length > 10 ? "${token.substring(0, 10)}..." : token;
      debugPrint("Making request to /api/qrcode/myqrcode with token: $tokenPreview");
      
      final Map<String, dynamic> response = await _apiService.get(
        "/api/qrcode/myqrcode",
        token: token,
      );
      
      // Debug: Print the full response to see what's being returned
      debugPrint("QR Code API Response: $response");
      
      if (response.containsKey("error")) {
        debugPrint("Error in QR code response: ${response["error"]}");
        return null;
      }
      
      // Check known field names first
      final possibleFields = ["qrCodeData", "data", "qrcode", "code", "content", "value"];
      
      for (final field in possibleFields) {
        if (response.containsKey(field)) {
          final value = response[field];
          if (value != null) {
            debugPrint("Found QR code in '$field' field");
            return value.toString();
          }
        }
      }
      
      // Look for responseBody or body fields if statusCode is present
      if (response.containsKey("statusCode")) {
        final bodyFields = ["responseBody", "body"];
        for (final field in bodyFields) {
          if (response.containsKey(field)) {
            final value = response[field];
            if (value != null) {
              return value.toString();
            }
          }
        }
      }
      
      // Look for any string field with reasonable length for a QR code
      for (final key in response.keys) {
        final value = response[key];
        if (value is String && value.length > 20) {
          return value;
        }
      }
      
      // Last resort - try to use first string value
      if (response.isNotEmpty) {
        final firstValue = response[response.keys.first];
        if (firstValue != null) {
          return firstValue.toString();
        }
      }
      
      debugPrint("No suitable QR code data found in response");
      return null;
    } catch (e) {
      debugPrint("Get QR code error: $e");
      return null;
    }
  }

  /// Scan QR code for money transfer
  Future<Map<String, dynamic>?> scanQRCode(String encryptedData) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return null;
      
      final response = await _apiService.post(
        "/api/qrcode/scanner",
        {"encryptedData": encryptedData},
        token: token,
      );

      if (!response.containsKey("error")) {
        return {
          "userId": response["userId"],
          "phoneNumber": response["phoneNumber"]
        };
      }
      return null;
    } catch (e) {
      debugPrint("Scan QR code error: $e");
      return null;
    }
  }