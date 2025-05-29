import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  
  List<dynamic> _transactions = [];
  bool isLoading = false;
  String? error;
  
  // Filter parameters
  String sortBy = "createdAt";
  String sortDirection = "DESC";
  int page = 0;
  int size = 10;
  String? selectedType;
  String? selectedStatus;
  double? minAmount;
  double? maxAmount;
  DateTime? startDate;
  DateTime? endDate;
  
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
    String? sortBy,
    String? sortDirection,
    int? page,
    int? size,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      // Update filter parameters with new values if provided
      this.sortBy = sortBy ?? this.sortBy;
      this.sortDirection = sortDirection ?? this.sortDirection;
      this.page = page ?? this.page;
      this.size = size ?? this.size;
      this.selectedType = type ?? this.selectedType;
      this.selectedStatus = status ?? this.selectedStatus;
      this.startDate = startDate ?? this.startDate;
      this.endDate = endDate ?? this.endDate;
      this.minAmount = minAmount ?? this.minAmount;
      this.maxAmount = maxAmount ?? this.maxAmount;
      
      _transactions = await _transactionService.filterTransactions(
        sortBy: this.sortBy,
        sortDirection: this.sortDirection,
        page: this.page,
        size: this.size,
        type: this.selectedType,
        status: this.selectedStatus,
        startDate: this.startDate,
        endDate: this.endDate,
        minAmount: this.minAmount,
        maxAmount: this.maxAmount
      );
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }
  
  /// Reset all filters to default values
  void resetFilters() {
    sortBy = "createdAt";
    sortDirection = "DESC";
    page = 0;
    size = 10;
    selectedType = null;
    selectedStatus = null;
    startDate = null;
    endDate = null;
    minAmount = null;
    maxAmount = null;
    notifyListeners();
  }
  
  /// Xóa thông báo lỗi
  void clearError() {
    error = null;
    notifyListeners();
  }
}