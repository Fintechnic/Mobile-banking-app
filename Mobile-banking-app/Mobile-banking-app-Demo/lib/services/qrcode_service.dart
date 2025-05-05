import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class QRCodeService {
  static Future<String?> getMyQRCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return null;
    final response = await ApiService.get("/api/qrcode/myqrcode", token: token);
    debugPrint("Get QR Code Response: $response");
    if (response.containsKey("qrCodeData")) {
      return response["qrCodeData"];
    }

    return null;
  }

  /// Scan a QR code
  static Future<Map<String, dynamic>?> scanQRCode(String encryptedData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return null;
    final response = await ApiService.post(
      "/api/qrcode/scanner",
      {
        "encryptedData": encryptedData
      },
      token: token
    );

    debugPrint("Scan QR Code Response: $response");
    if (response.containsKey("userData")) {
      return response["userData"];
    }

    return null;
  }
}
