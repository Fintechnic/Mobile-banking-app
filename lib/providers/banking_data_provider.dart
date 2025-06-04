import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

/// Provider to manage banking data
class BankingDataProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final NumberFormat _currencyFormatter = NumberFormat('#,###', 'en_US');
  String _balance = '0';
  String _username = '';
  List<QuickAccessItem> _quickAccessItems = [];
  List<PromoItem> _promos = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  String get balance => _balance;
  String get username => _username;
  List<QuickAccessItem> get quickAccessItems => _quickAccessItems;
  List<PromoItem> get promos => _promos;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> fetchData() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // Get token from ApiService
      final token = await _apiService.getToken();
      
      // Fetch banking data from the backend
      final response = await _apiService.get(
        '/api/home',
        token: token,
      );

      if (!response.containsKey('error')) {
        // Parse username, balance data
        _username = response['username'] ?? '';
        
        // Format balance with VND suffix if it's a number
        if (response['balance'] != null) {
          if (response['balance'] is num) {
            final formattedBalance = _currencyFormatter.format(response['balance']);
            _balance = '$formattedBalance VND';
          } else {
            _balance = response['balance'].toString();
          }
        } else {
          _balance = '0 VND';
        }
        
        // Initialize quick access items
        _initializeQuickAccessItems();
        
        // Parse promos from API response
        if (response['promos'] != null && response['promos'] is List) {
          _promos = (response['promos'] as List).map((promoData) => PromoItem(
            title: promoData['title'] ?? '',
            description: promoData['description'] ?? '',
            expiry: promoData['expiry'] ?? '',
            backgroundColor: Colors.blue.shade50,
          )).toList();
        } else {
          _initializePromos(); // Fallback to mock promos
        }
      } else {
        // If there's an API error, use mock data
        _username = 'User';
        _balance = '1.000.000 VND';
        _initializeQuickAccessItems();
        _initializePromos();
        
        _errorMessage = response['error'] ?? 'Failed to load banking data';
        _hasError = true;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // If there's an exception, use mock data and show error
      _username = 'User';
      _balance = '1.000.000 VND';
      _initializeQuickAccessItems();
      _initializePromos();
      
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _initializeQuickAccessItems() {
    _quickAccessItems = [
      QuickAccessItem(type: "transfer", label: "Transfer", isMultiLine: false),
      QuickAccessItem(type: "withdraw", label: "Withdraw", isMultiLine: false),
      QuickAccessItem(type: "bill", label: "Bill\nPayment", isMultiLine: true),
    ];
  }

  void _initializePromos() {
    _promos = [
      PromoItem(
        title: '50% off transfer fees',
        description:
            'Applicable for all money transfers until 30/04/2025',
        expiry: '30/04/2025',
        backgroundColor: Colors.blue.shade50,
      ),
      PromoItem(
        title: '10% cashback',
        description: 'For first-time bill payments',
        expiry: '15/05/2025',
        backgroundColor: Colors.green.shade50,
      ),
    ];
  }
}

class QuickAccessItem {
  final String type;
  final String label;
  final bool isMultiLine;

  QuickAccessItem({
    required this.type,
    required this.label,
    required this.isMultiLine,
  });
}

class PromoItem {
  final String title;
  final String description;
  final String expiry;
  final Color backgroundColor;

  PromoItem({
    required this.title,
    required this.description,
    required this.expiry,
    required this.backgroundColor,
  });
} 