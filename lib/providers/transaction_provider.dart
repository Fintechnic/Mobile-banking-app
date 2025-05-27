import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  
  List<dynamic> _transactions = [];
  bool isLoading = false;
  String? error;
  
  List<dynamic> get transactions => _transactions;
  
  /// Lấy lịch sử giao dịch
  Future<void> fetchTransactions() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      _transactions = await _transactionService.getTransactionHistory();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }
  
  /// Chuyển tiền
  Future<bool> transferMoney(String phoneNumber, double amount, {String? description}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _transactionService.transferMoney(phoneNumber, amount, description: description);
      
      if (success) {
        // Cập nhật lịch sử giao dịch
        await fetchTransactions();
      } else {
        isLoading = false;
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  /// Rút tiền
  Future<bool> withdrawMoney(double amount) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _transactionService.withdrawMoney(amount);
      
      if (success) {
        // Cập nhật lịch sử giao dịch
        await fetchTransactions();
      } else {
        isLoading = false;
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  /// Lấy lịch sử giao dịch (Admin)
  Future<void> fetchAdminTransactions() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      _transactions = await _transactionService.getAdminTransactionHistory();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }
  
  /// Lọc giao dịch (Admin)
  Future<void> filterTransactions({
    String sortBy = "createdAt",
    String sortDirection = "DESC",
    int page = 0,
    int size = 10
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      _transactions = await _transactionService.filterTransactions(
        sortBy: sortBy,
        sortDirection: sortDirection,
        page: page,
        size: size
      );
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }
  
  /// Xóa thông báo lỗi
  void clearError() {
    error = null;
    notifyListeners();
  }
}