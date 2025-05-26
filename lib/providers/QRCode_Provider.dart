import 'package:flutter/material.dart';
import '../services/qrcode_service.dart';

class QRCodeProvider extends ChangeNotifier {
  final QRCodeService _qrCodeService = QRCodeService();
  
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? qrData;

  /// Generate QR code for payment
  Future<bool> generateQRCode({
    required String userId,
    required double amount,
    String? description,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _qrCodeService.generateQRCode(
        userId: userId,
        amount: amount,
        description: description,
      );

      if (response.containsKey("error")) {
        error = response["error"];
        return false;
      }

      qrData = response;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Verify QR code
  Future<bool> verifyQRCode(String qrData) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final result = await _qrCodeService.verifyQRCode(qrData);
      if (!result) {
        error = "Invalid QR code";
      }
      return result;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    error = null;
    notifyListeners();
  }

  /// Clear QR data
  void clearQRData() {
    qrData = null;
    notifyListeners();
  }
}