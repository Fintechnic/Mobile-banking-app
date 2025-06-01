import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fintechnic/services/transaction_service.dart';
import 'package:fintechnic/models/transaction.dart' as app_transaction;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A3A6B),
        fontFamily: 'SF Pro Display',
      ),
      home: const TransactionHistoryScreen(),
    );
  }
}

enum TransactionType {
  all,
  income,
  expense,
  deposit,
  withdraw,
  transfer,
  billPayment,
  topUp,
  investment,
  saving,
}

extension TransactionTypeExtension on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.all:
        return 'All';
      case TransactionType.income:
        return 'Income';
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.withdraw:
        return 'Withdraw';
      case TransactionType.transfer:
        return 'Transfer';
      case TransactionType.billPayment:
        return 'Bill Payment';
      case TransactionType.topUp:
        return 'Top Up';
      case TransactionType.investment:
        return 'Investment';
      case TransactionType.saving:
        return 'Saving';
    }
  }
}

class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String category;
  final String status;
  final TransactionType type;
  final String? counterparty;

  Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.status,
    required this.type,
    this.counterparty,
  });

  bool get isExpense => amount < 0;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id']?.toString() ?? '',
      title: json['counterparty'] ?? 'Transaction',
      description: json['description'] ?? '',
      amount: _parseAmount(json['amount']),
      date: _parseDate(json['createdAt']),
      category: _getCategoryFromType(json['type']),
      status: json['status'] ?? 'Completed',
      type: _mapTransactionType(json['type']),
      counterparty: json['counterparty'],
    );
  }

  static double _parseAmount(dynamic amount) {
    if (amount == null) return 0.0;
    if (amount is double) return amount;
    if (amount is int) return amount.toDouble();
    try {
      return double.parse(amount.toString());
    } catch (e) {
      return 0.0;
    }
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    try {
      return DateTime.parse(date);
    } catch (e) {
      return DateTime.now();
    }
  }

  static String _getCategoryFromType(String? type) {
    if (type == null) return 'Other';
    
    switch (type.toLowerCase()) {
      case 'deposit':
        return 'Deposit';
      case 'withdraw':
        return 'Withdrawal';
      case 'transfer':
        return 'Transfer';
      case 'bill_payment':
        return 'Bill Payment';
      case 'top_up':
        return 'Top Up';
      case 'expense':
        return 'Expense';
      case 'income':
        return 'Income';
      default:
        return 'Other';
    }
  }

  static TransactionType _mapTransactionType(String? type) {
    if (type == null) return TransactionType.expense;
    
    switch (type.toLowerCase()) {
      case 'deposit':
        return TransactionType.deposit;
      case 'withdraw':
        return TransactionType.withdraw;
      case 'transfer':
        return TransactionType.transfer;
      case 'bill_payment':
        return TransactionType.billPayment;
      case 'top_up':
        return TransactionType.topUp;
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      default:
        return TransactionType.expense;
    }
  }
}

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  TransactionType _selectedFilter = TransactionType.all;
  String _selectedPeriod = 'Last 30 days';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCustomDateRange = false;
  bool _isLoading = false;
  String? _errorMessage;
  final TransactionService _transactionService = TransactionService();

  final List<String> _periodOptions = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last 6 months',
    'This year',
    'Custom range',
  ];

  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _updateDateRange(_selectedPeriod);

    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint("Fetching transaction history...");
      
      List<dynamic> transactionData;
      
      // Use search API if search text is provided
      if (_searchController.text.isNotEmpty) {
        debugPrint("Searching for: ${_searchController.text}");
        transactionData = await _transactionService.searchTransactionHistory(_searchController.text);
      } else {
        transactionData = await _transactionService.getTransactionHistory();
      }
      
      debugPrint("Transaction data received: ${transactionData.length} items");
      
      if (transactionData.isEmpty) {
        debugPrint("Transaction data is empty");
        setState(() {
          _transactions = [];
          _isLoading = false;
        });
        return;
      }
      
      List<Transaction> transactions = [];
      
      for (var i = 0; i < transactionData.length; i++) {
        try {
          var data = transactionData[i];
          debugPrint("Processing transaction $i: $data");
          
          // Convert from API format to UI format
          final appTransaction = app_transaction.Transaction.fromJson(data);
          
          transactions.add(Transaction(
            id: appTransaction.id.toString(),
            title: appTransaction.counterparty ?? 'Transaction',
            description: appTransaction.description ?? '',
            amount: appTransaction.amount,
            date: DateTime.parse(appTransaction.createdAt),
            category: appTransaction.type,
            status: appTransaction.status ?? 'Completed',
            type: _mapTransactionType(appTransaction.type),
            counterparty: appTransaction.counterparty,
          ));
        } catch (e) {
          debugPrint("Error processing transaction: $e");
        }
      }
      
      debugPrint("Processed ${transactions.length} transactions");
      
      // Apply date filters
      final filteredTransactions = transactions.where((transaction) {
        final isInDateRange = transaction.date.isAfter(_startDate!) && 
                              transaction.date.isBefore(_endDate!.add(const Duration(days: 1)));
                              
        final matchesFilter = _selectedFilter == TransactionType.all || 
                              transaction.type == _selectedFilter;
        
        // If we already searched on the server, no need to filter by search text again
        return isInDateRange && matchesFilter;
      }).toList();

      debugPrint("Filtered to ${filteredTransactions.length} transactions");

      setState(() {
        _transactions = filteredTransactions;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error in _fetchTransactions: $e");
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });

      _loadMockData();
    }
  }
  
  TransactionType _mapTransactionType(String apiType) {
    switch (apiType.toLowerCase()) {
      case 'deposit':
        return TransactionType.deposit;
      case 'withdraw':
        return TransactionType.withdraw;
      case 'transfer':
        return TransactionType.transfer;
      case 'bill_payment':
        return TransactionType.billPayment;
      case 'top_up':
        return TransactionType.topUp;
      default:
        return apiType.toLowerCase().contains('expense') 
            ? TransactionType.expense 
            : TransactionType.income;
    }
  }

  void _loadMockData() {
    _transactions = [
      Transaction(
        id: '1',
        title: 'Salary',
        description: 'Monthly salary payment',
        amount: 25000000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Income',
        status: 'Completed',
        type: TransactionType.income,
        counterparty: null,
      ),
      Transaction(
        id: '2',
        title: 'Electricity Bill',
        description: 'EVN - Monthly payment',
        amount: -1250000,
        date: DateTime.now().subtract(const Duration(days: 5)),
        category: 'Utilities',
        status: 'Completed',
        type: TransactionType.billPayment,
        counterparty: 'EVN',
      ),
      Transaction(
        id: '3',
        title: 'Transfer to Nguyen Van A',
        description: 'Personal transfer',
        amount: -5000000,
        date: DateTime.now().subtract(const Duration(days: 7)),
        category: 'Transfer',
        status: 'Completed',
        type: TransactionType.transfer,
        counterparty: 'Nguyen Van A',
      ),
      Transaction(
        id: '4',
        title: 'ATM Withdrawal',
        description: 'ATM Transaction',
        amount: -2000000,
        date: DateTime.now().subtract(const Duration(days: 12)),
        category: 'Withdrawal',
        status: 'Completed',
        type: TransactionType.withdraw,
        counterparty: null,
      ),
      Transaction(
        id: '5',
        title: 'Deposit at Branch',
        description: 'Cash deposit',
        amount: 10000000,
        date: DateTime.now().subtract(const Duration(days: 15)),
        category: 'Deposit',
        status: 'Completed',
        type: TransactionType.deposit,
        counterparty: null,
      ),
      Transaction(
        id: '6',
        title: 'Mobile Top Up',
        description: 'Viettel prepaid',
        amount: -100000,
        date: DateTime.now().subtract(const Duration(days: 18)),
        category: 'Top Up',
        status: 'Completed',
        type: TransactionType.topUp,
        counterparty: 'Viettel',
      ),
      Transaction(
        id: '7',
        title: 'Investment Fund',
        description: 'Monthly investment',
        amount: -5000000,
        date: DateTime.now().subtract(const Duration(days: 22)),
        category: 'Investment',
        status: 'Completed',
        type: TransactionType.investment,
        counterparty: 'Investment Fund',
      ),
      Transaction(
        id: '8',
        title: 'Savings Deposit',
        description: 'Term deposit',
        amount: -20000000,
        date: DateTime.now().subtract(const Duration(days: 25)),
        category: 'Saving',
        status: 'Completed',
        type: TransactionType.saving,
        counterparty: 'Savings Account',
      ),
    ];
  }

  void _updateDateRange(String period) {
    final now = DateTime.now();

    switch (period) {
      case 'Last 7 days':
        _startDate = now.subtract(const Duration(days: 7));
        _endDate = now;
        _isCustomDateRange = false;
        break;
      case 'Last 30 days':
        _startDate = now.subtract(const Duration(days: 30));
        _endDate = now;
        _isCustomDateRange = false;
        break;
      case 'Last 3 months':
        _startDate = DateTime(now.year, now.month - 3, now.day);
        _endDate = now;
        _isCustomDateRange = false;
        break;
      case 'Last 6 months':
        _startDate = DateTime(now.year, now.month - 6, now.day);
        _endDate = now;
        _isCustomDateRange = false;
        break;
      case 'This year':
        _startDate = DateTime(now.year, 1, 1);
        _endDate = now;
        _isCustomDateRange = false;
        break;
      case 'Custom range':
        _isCustomDateRange = true;

        if (_startDate == null || _endDate == null) {
          _startDate = now.subtract(const Duration(days: 30));
          _endDate = now;
        }
        _showDateRangePicker();
        break;
    }

    if (!_isCustomDateRange) {
      _fetchTransactions();
    }
  }

  Future<void> _showDateRangePicker() async {
    final initialDateRange = DateTimeRange(
      start: _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      end: _endDate ?? DateTime.now(),
    );

    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A3A6B),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
      });

      _fetchTransactions();
    }
  }

  List<Transaction> get filteredTransactions {
    List<Transaction> result = List.from(_transactions);

    if (_selectedFilter != TransactionType.all) {
      result = result
          .where((transaction) => transaction.type == _selectedFilter)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      result = result
          .where(
            (transaction) =>
                transaction.title.toLowerCase().contains(query) ||
                transaction.description.toLowerCase().contains(query) ||
                transaction.category.toLowerCase().contains(query),
          )
          .toList();
    }

    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A3A6B), Color(0xFF5A8ED0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Transaction History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        _isSearching ? Icons.close : Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSearching = !_isSearching;
                          if (!_isSearching) {
                            _searchController.clear();
                            _fetchTransactions();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.download_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              if (_isSearching)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        // Don't refresh on every change
                      },
                      onSubmitted: (value) {
                        _fetchTransactions();
                      },
                      decoration: InputDecoration(
                        hintText: 'Search transactions',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF5A8ED0),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                  _fetchTransactions();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<TransactionType>(
                            value: _selectedFilter,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF5A8ED0),
                            ),
                            isExpanded: true,
                            onChanged: (TransactionType? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedFilter = newValue;
                                });
                                _fetchTransactions();
                              }
                            },
                            items: TransactionType.values
                                .map<DropdownMenuItem<TransactionType>>((
                              TransactionType type,
                            ) {
                              return DropdownMenuItem<TransactionType>(
                                value: type,
                                child: Text(
                                  type.displayName,
                                  style: const TextStyle(
                                    color: Color(0xFF1A3A6B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPeriod,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF5A8ED0),
                            ),
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedPeriod = newValue;
                                });
                                _updateDateRange(_selectedPeriod);
                              }
                            },
                            items:
                                _periodOptions.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Color(0xFF1A3A6B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_startDate != null && _endDate != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${DateFormat('MMM d, yyyy').format(_startDate!)} - ${DateFormat('MMM d, yyyy').format(_endDate!)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_isCustomDateRange) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: _showDateRangePicker,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? _buildLoadingState()
                      : _errorMessage != null
                          ? _buildErrorState()
                          : filteredTransactions.isEmpty
                              ? _buildEmptyState()
                              : _buildTransactionList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF1A3A6B)),
          SizedBox(height: 16),
          Text(
            'Loading transactions...',
            style: TextStyle(
              color: Color(0xFF1A3A6B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error loading transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchTransactions,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3A6B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing your filters or search term',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedFilter = TransactionType.all;
                _selectedPeriod = 'Last 30 days';
                _updateDateRange(_selectedPeriod);
                _searchController.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3A6B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    Map<String, List<Transaction>> groupedTransactions = {};

    for (var transaction in filteredTransactions) {
      final dateStr = DateFormat('MMMM d, yyyy').format(transaction.date);
      if (!groupedTransactions.containsKey(dateStr)) {
        groupedTransactions[dateStr] = [];
      }
      groupedTransactions[dateStr]!.add(transaction);
    }

    final sortedDates = groupedTransactions.keys.toList()
      ..sort(
        (a, b) => DateFormat(
          'MMMM d, yyyy',
        ).parse(b).compareTo(DateFormat('MMMM d, yyyy').parse(a)),
      );

    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final transactions = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1A3A6B),
                ),
              ),
            ),
            ...transactions.map(
              (transaction) => _buildTransactionItem(transaction),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final formattedAmount = currencyFormat.format(transaction.amount);
    final timeStr = DateFormat('HH:mm').format(transaction.date);

    return InkWell(
      onTap: () {
        _showTransactionDetails(transaction);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: transaction.isExpense
                    ? const Color(0xFFFFE8E8)
                    : const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(transaction.type),
                color: transaction.isExpense
                    ? const Color(0xFFE53935)
                    : const Color(0xFF43A047),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.description,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          transaction.status,
                          style: TextStyle(
                            color: _getStatusColor(transaction.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeStr,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.isExpense
                      ? formattedAmount 
                      : '+$formattedAmount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: transaction.isExpense
                        ? const Color(0xFFE53935)
                        : const Color(0xFF43A047),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    transaction.type.displayName,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Icons.account_balance_wallet;
      case TransactionType.expense:
        return Icons.shopping_cart;
      case TransactionType.deposit:
        return Icons.savings;
      case TransactionType.withdraw:
        return Icons.atm;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.billPayment:
        return Icons.receipt_long;
      case TransactionType.topUp:
        return Icons.phone_android;
      case TransactionType.investment:
        return Icons.trending_up;
      case TransactionType.saving:
        return Icons.account_balance;
      default:
        return Icons.receipt;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFF43A047);
      case 'Pending':
        return const Color(0xFFFFA000);
      case 'Failed':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF1A3A6B);
    }
  }

  void _showTransactionDetails(Transaction transaction) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final formattedAmount = currencyFormat.format(transaction.amount);
    final dateStr = DateFormat('MMMM d, yyyy - HH:mm').format(transaction.date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3A6B),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      transaction.isExpense
                          ? formattedAmount 
                          : '+$formattedAmount',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: transaction.isExpense
                            ? const Color(0xFFE53935)
                            : const Color(0xFF43A047),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          transaction.status,
                        ).withAlpha(26),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        transaction.status,
                        style: TextStyle(
                          color: _getStatusColor(transaction.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildDetailItem('Date & Time', dateStr),
                    _buildDetailItem('Type', transaction.type.displayName),
                    _buildDetailItem('Description', transaction.description),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.receipt_outlined,
                          label: 'Receipt',
                          onTap: () {},
                        ),
                        _buildActionButton(
                          icon: Icons.repeat,
                          label: 'Repeat',
                          onTap: () {},
                        ),
                        _buildActionButton(
                          icon: Icons.share_outlined,
                          label: 'Share',
                          onTap: () {},
                        ),
                        _buildActionButton(
                          icon: Icons.help_outline,
                          label: 'Support',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1A3A6B)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Report an Issue',
                          style: TextStyle(
                            color: Color(0xFF1A3A6B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F7FA),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1A3A6B), size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
