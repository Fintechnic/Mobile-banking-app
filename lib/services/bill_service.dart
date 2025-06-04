import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import '../models/bill.dart';
import '../utils/icon_utils.dart';

class BillService {
  final ApiService _apiService = ApiService();

  /// Get service categories for bill payment
  Future<List<ServiceCategory>> getServiceCategories() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        // For development, return mock data if no token
        return _getMockServiceCategories();
      }

      final response = await _apiService.get("/api/bills/categories", token: token);
      if (!response.containsKey("error")) {
        final List<dynamic> categoriesData = response["categories"] ?? [];
        return categoriesData.map((data) => ServiceCategory.fromJson(data)).toList();
      }
      return _getMockServiceCategories();
    } catch (e) {
      debugPrint("Get service categories error: $e");
      return _getMockServiceCategories();
    }
  }

  /// Get user bills
  Future<List<Bill>> getUserBills() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        // For development, return mock data if no token
        return _getMockBills();
      }

      final response = await _apiService.get("/api/bills", token: token);
      if (!response.containsKey("error")) {
        final List<dynamic> billsData = response["bills"] ?? [];
        return billsData.map((data) => Bill.fromJson(data)).toList();
      }
      return _getMockBills();
    } catch (e) {
      debugPrint("Get bills error: $e");
      return _getMockBills();
    }
  }

  /// Pay bill
  Future<bool> payBill(String billId) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.post(
        "/api/bills/$billId/pay",
        {},
        token: token,
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Pay bill error: $e");
      return false;
    }
  }

  /// Add new bill (subscribe to a service)
  Future<bool> addNewBill(String serviceId, {String? accountNumber}) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.post(
        "/api/bills/subscribe",
        {
          "serviceId": serviceId,
          if (accountNumber != null) "accountNumber": accountNumber,
        },
        token: token,
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Add new bill error: $e");
      return false;
    }
  }

  /// Create new bill (Admin only)
  Future<bool> createBill({
    required String type,
    required String phoneNumber,
    required double amount,
  }) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.post(
        "/api/admin/new-bill",
        {
          "type": type,
          "phoneNumber": phoneNumber,
          "amount": amount,
        },
        token: token,
      );

      return !response.containsKey("error");
    } catch (e) {
      debugPrint("Create bill error: $e");
      return false;
    }
  }

  // Helper methods for mock data
  List<ServiceCategory> _getMockServiceCategories() {
    return [
      ServiceCategory(
        id: 'electricity',
        name: 'Electricity',
        icon: Icons.bolt,
        color: const Color(0xFF1A3A6B),
      ),
      ServiceCategory(
        id: 'water',
        name: 'Water',
        icon: Icons.water_drop_outlined,
        color: const Color(0xFF1A3A6B),
      ),
      ServiceCategory(
        id: 'cable',
        name: 'Cable TV',
        icon: Icons.tv,
        color: const Color(0xFF1A3A6B),
      ),
      ServiceCategory(
        id: 'mobile',
        name: 'Mobile phone',
        icon: Icons.smartphone,
        color: const Color(0xFF1A3A6B),
      ),
      ServiceCategory(
        id: 'tuition',
        name: 'Tuition',
        icon: Icons.school,
        color: const Color(0xFF1A3A6B),
      ),
      ServiceCategory(
        id: 'internet',
        name: 'Internet',
        icon: Icons.wifi,
        color: const Color(0xFF1A3A6B),
      ),
    ];
  }

  List<Bill> _getMockBills() {
    return [
      Bill(
        id: 'bill1',
        serviceId: 'electricity',
        serviceName: 'Electricity',
        serviceIcon: Icons.bolt,
        accountNumber: 'EL-123456789',
        amount: 78.50,
        dueDate: DateTime.now().add(const Duration(days: 5)),
      ),
      Bill(
        id: 'bill2',
        serviceId: 'internet',
        serviceName: 'Internet',
        serviceIcon: Icons.wifi,
        accountNumber: 'IN-987654321',
        amount: 45.00,
        dueDate: DateTime.now().add(const Duration(days: 10)),
      ),
    ];
  }
}

class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: IconUtils.getIconFromString(json['icon'] as String? ?? 'receipt_long'),
      color: const Color(0xFF1A3A6B),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': IconUtils.getStringFromIcon(icon),
    };
  }
}