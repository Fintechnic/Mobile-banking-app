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
  
  /// Tìm kiếm ví (Admin)
  Future<Map<String, dynamic>?> searchWallet(String username) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final result = await _walletService.searchWallet(username);
      
      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return null;
    }
  }
  
  /// Nạp tiền vào ví đại lý (Admin)
  Future<bool> topUpAgentWallet(String phoneNumber, double amount, String description) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _walletService.topUpAgentWallet(phoneNumber, amount, description);
      
      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  /// Xóa thông báo lỗi
  void clearError() {
    error = null;
    notifyListeners();
  }
}