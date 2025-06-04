import 'package:flutter/material.dart';
import '../services/bill_service.dart';

class BillProvider extends ChangeNotifier {
  final BillService _billService = BillService();
  
  List<dynamic> _bills = [];
  bool isLoading = false;
  String? error;
  
  List<dynamic> get bills => _bills;
  
  /// Lấy danh sách hóa đơn
  Future<void> fetchBills() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      _bills = await _billService.getUserBills();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }
  
  /// Thanh toán hóa đơn
  Future<bool> payBill(String billId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _billService.payBill(billId);
      
      if (success) {
        // Cập nhật trạng thái hóa đơn trong danh sách
        for (int i = 0; i < _bills.length; i++) {
          if (_bills[i]['id'] == billId) {
            _bills[i]['paid'] = true;
            _bills[i]['paidDate'] = DateTime.now().toIso8601String();
            break;
          }
        }
      }
      
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
  
  /// Tạo hóa đơn mới (Admin)
  Future<bool> createBill({
    required String type,
    required String phoneNumber,
    required double amount,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      
      final success = await _billService.createBill(
        type: type,
        phoneNumber: phoneNumber,
        amount: amount,
      );
      
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