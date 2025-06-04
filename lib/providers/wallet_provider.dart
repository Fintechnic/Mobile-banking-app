import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  final WalletService _walletService = WalletService();
  
  Map<String, dynamic>? _walletData;
  bool isLoading = false;
  String? error;
  
  Map<String, dynamic>? get walletData => _walletData;
  
  /// Lấy thông tin ví
  Future<void> fetchWalletSummary() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      _walletData = await _walletService.getWalletSummary();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }
  
  /// Admin top-up user wallet
  Future<Map<String, dynamic>> adminTopUp(String phoneNumber, double amount, {String? description}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final result = await _walletService.adminTopUp(phoneNumber, amount, description: description);
      
      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return {"error": e.toString()};
    }
  }
  
  /// Xóa thông báo lỗi
  void clearError() {
    error = null;
    notifyListeners();
  }
}