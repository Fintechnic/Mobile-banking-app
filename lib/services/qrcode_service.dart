import 'package:flutter/foundation.dart';
import 'api_service.dart';

class QRCodeService {
  final ApiService _apiService = ApiService();

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

  /// Verify QR code
  Future<bool> verifyQRCode(String qrData) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.post(
        "/api/qrcode/verify",
        {"qrData": qrData},
        token: token,
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Verify QR code error: $e");
      return false;
    }
  }

  /// Get current user's QR code
  Future<String?> getMyQRCode() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return null;
      
      final response = await _apiService.get(
        "/api/qrcode/myqrcode",
        token: token,
      );
      
      if (!response.containsKey("error")) {
        return response["qrCodeData"];
      }
      return null;
    } catch (e) {
      debugPrint("Get QR code error: $e");
      return null;
    }
  }

  /// Scan QR code
  Future<Map<String, dynamic>?> scanQRCode(String encryptedData) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return null;
      
      final response = await _apiService.post(
        "/api/qrcode/scan",
        {"encryptedData": encryptedData},
        token: token,
      );

      if (!response.containsKey("error")) {
        return response;
      }
      return null;
    } catch (e) {
      debugPrint("Scan QR code error: $e");
      return null;
    }
  }
}