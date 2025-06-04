import 'package:flutter/foundation.dart';
import 'package:fintechnic/models/admin_transaction.dart';
import 'package:fintechnic/services/admin_transaction_service.dart';

class AdminTransactionProvider with ChangeNotifier {
  final AdminTransactionService _transactionService = AdminTransactionService();
  
  List<AdminTransaction> _transactions = [];
  PaginationData? _pagination;
  bool _isLoading = false;
  String? _error;
  TransactionFilter _currentFilter = TransactionFilter();
  
  // Getters
  List<AdminTransaction> get transactions => _transactions;
  PaginationData? get pagination => _pagination;
  bool get isLoading => _isLoading;
  String? get error => _error;
  TransactionFilter get currentFilter => _currentFilter;
  
  // Pagination helpers
  int get currentPage => _pagination?.number ?? 0;
  int get totalPages => _pagination?.totalPages ?? 1;
  bool get hasNextPage => currentPage < (totalPages - 1);
  bool get hasPreviousPage => currentPage > 0;
  
  // Initialize by fetching transactions
  Future<void> fetchTransactions({int page = 0, int size = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final result = await _transactionService.getTransactions(
        page: page,
        size: size,
      );
      
      if (result.containsKey("error")) {
        _error = result["error"];
        _transactions = [];
      } else {
        _transactions = result["transactions"] as List<AdminTransaction>;
        _pagination = result["pagination"] as PaginationData;
        _currentFilter = TransactionFilter(); // Reset filter
      }
    } catch (e) {
      _error = e.toString();
      _transactions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Apply a filter to the transactions
  Future<void> applyFilter(TransactionFilter filter, {int page = 0, int size = 10}) async {
    _isLoading = true;
    _error = null;
    _currentFilter = filter;
    notifyListeners();
    
    try {
      final result = await _transactionService.filterTransactions(
        filter,
        page: page,
        size: size,
      );
      
      if (result.containsKey("error")) {
        _error = result["error"];
        _transactions = [];
      } else {
        _transactions = result["transactions"] as List<AdminTransaction>;
        _pagination = result["pagination"] as PaginationData;
      }
    } catch (e) {
      _error = e.toString();
      _transactions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Clear any applied filters
  void clearFilters() {
    _currentFilter = TransactionFilter();
    fetchTransactions();
  }
  
  // Navigate to next page
  Future<void> nextPage({int size = 10}) async {
    if (!hasNextPage) return;
    
    final nextPage = currentPage + 1;
    if (_currentFilter.transactionType != null || 
        _currentFilter.minAmount != null || 
        _currentFilter.maxAmount != null || 
        _currentFilter.keyword != null ||
        _currentFilter.transactionStatus != null ||
        _currentFilter.fromDate != null ||
        _currentFilter.fromWalletId != null ||
        _currentFilter.transactionCode != null ||
        _currentFilter.toWalletId != null) {
      // We have an active filter
      await applyFilter(_currentFilter, page: nextPage, size: size);
    } else {
      // No filter active, just fetch next page
      await fetchTransactions(page: nextPage, size: size);
    }
  }
  
  // Navigate to previous page
  Future<void> previousPage({int size = 10}) async {
    if (!hasPreviousPage) return;
    
    final prevPage = currentPage - 1;
    if (_currentFilter.transactionType != null || 
        _currentFilter.minAmount != null || 
        _currentFilter.maxAmount != null || 
        _currentFilter.keyword != null ||
        _currentFilter.transactionStatus != null ||
        _currentFilter.fromDate != null ||
        _currentFilter.fromWalletId != null ||
        _currentFilter.transactionCode != null ||
        _currentFilter.toWalletId != null) {
      // We have an active filter
      await applyFilter(_currentFilter, page: prevPage, size: size);
    } else {
      // No filter active, just fetch previous page
      await fetchTransactions(page: prevPage, size: size);
    }
  }
} 