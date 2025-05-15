import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transfer App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TransferScreen(),
    );
  }
}

// Data models
class Account {
  final String id;
  final String name;
  final double balance;
  final String currency;

  Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.currency,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      balance: json['balance'].toDouble(),
      currency: json['currency'],
    );
  }

  String get formattedBalance {
    return '${balance.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )} $currency';
  }
}

class Recipient {
  final String id;
  final String name;
  final String bankName;
  final String accountNumber;

  Recipient({
    required this.id,
    required this.name,
    required this.bankName,
    required this.accountNumber,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['id'],
      name: json['name'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
    );
  }

  String get formattedAccount {
    return '$bankName - $accountNumber';
  }
}

class Transaction {
  final String id;
  final String recipientName;
  final String recipientAccount;
  final String bankName;
  final double amount;
  final String currency;
  final DateTime date;
  final String? note;

  Transaction({
    required this.id,
    required this.recipientName,
    required this.recipientAccount,
    required this.bankName,
    required this.amount,
    required this.currency,
    required this.date,
    this.note,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      recipientName: json['recipientName'],
      recipientAccount: json['recipientAccount'],
      bankName: json['bankName'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }

  String get formattedAmount {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )} $currency';
  }

  String get formattedDate {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String get formattedAccount {
    return '$bankName - $recipientAccount';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

// API Service
class TransferService {
  static const String baseUrl = 'https://api.example.com'; // Replace with your API URL
  
  // Fetch user accounts
  static Future<List<Account>> getUserAccounts() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // In a real app, you would make an actual API call:
      // final response = await http.get(Uri.parse('$baseUrl/accounts'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   return data.map((json) => Account.fromJson(json)).toList();
      // } else {
      //   throw Exception('Failed to load accounts');
      // }
      
      // Mock data for demonstration
      return [
        Account(
          id: 'acc1',
          name: 'Salary Account',
          balance: 25000000,
          currency: 'VND',
        ),
        Account(
          id: 'acc2',
          name: 'Savings Account',
          balance: 50000000,
          currency: 'VND',
        ),
        Account(
          id: 'acc3',
          name: 'Business Account',
          balance: 100000000,
          currency: 'VND',
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load accounts: $e');
    }
  }
  
  // Fetch recipients
  static Future<List<Recipient>> getRecipients() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // In a real app, you would make an actual API call:
      // final response = await http.get(Uri.parse('$baseUrl/recipients'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   return data.map((json) => Recipient.fromJson(json)).toList();
      // } else {
      //   throw Exception('Failed to load recipients');
      // }
      
      // Mock data for demonstration
      return [
        Recipient(
          id: 'rec1',
          name: 'Nguyen Van A',
          bankName: 'Fintechnic',
          accountNumber: '31410000123456',
        ),
        Recipient(
          id: 'rec2',
          name: 'Tran Thi B',
          bankName: 'Fintechnic',
          accountNumber: '31410000789012',
        ),
        Recipient(
          id: 'rec3',
          name: 'Le Van C',
          bankName: 'Fintechnic',
          accountNumber: '31410000345678',
        ),
        Recipient(
          id: 'rec4',
          name: 'Pham Thi D',
          bankName: 'Fintechnic',
          accountNumber: '31410000901234',
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load recipients: $e');
    }
  }
  
  // Fetch recent transactions
  static Future<List<Transaction>> getRecentTransactions() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 1200));
      
      // In a real app, you would make an actual API call:
      // final response = await http.get(Uri.parse('$baseUrl/transactions/recent'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   return data.map((json) => Transaction.fromJson(json)).toList();
      // } else {
      //   throw Exception('Failed to load transactions');
      // }
      
      // Mock data for demonstration
      return [
        Transaction(
          id: 'tx1',
          recipientName: 'Nguyen Van A',
          recipientAccount: '31410000123456',
          bankName: 'Fintechnic',
          amount: 5000000,
          currency: 'VND',
          date: DateTime(2025, 4, 12),
          note: 'Monthly rent',
        ),
        Transaction(
          id: 'tx2',
          recipientName: 'Tran Thi B',
          recipientAccount: '31410000789012',
          bankName: 'Fintechnic',
          amount: 2500000,
          currency: 'VND',
          date: DateTime(2025, 4, 10),
          note: 'Dinner payment',
        ),
        Transaction(
          id: 'tx3',
          recipientName: 'Le Van C',
          recipientAccount: '31410000345678',
          bankName: 'Fintechnic',
          amount: 1000000,
          currency: 'VND',
          date: DateTime(2025, 4, 5),
          note: 'Shared expenses',
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }
  
  // Submit transfer
  static Future<bool> submitTransfer({
    required String fromAccountId,
    required String toRecipientId,
    required double amount,
    String? note,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, you would make an actual API call:
      // final response = await http.post(
      //   Uri.parse('$baseUrl/transfer'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'fromAccountId': fromAccountId,
      //     'toRecipientId': toRecipientId,
      //     'amount': amount,
      //     'note': note,
      //   }),
      // );
      // return response.statusCode == 200;
      
      // For demonstration, validate amount and return success
      if (amount <= 0) {
        throw Exception('Amount must be greater than 0');
      }
      
      // Simulate a 90% success rate
      final random = DateTime.now().millisecondsSinceEpoch % 10;
      if (random < 9) {
        return true;
      } else {
        throw Exception('Transfer failed. Please try again later.');
      }
    } catch (e) {
      throw Exception('Failed to submit transfer: $e');
    }
  }
}

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  bool _isLoadingAccounts = true;
  bool _isLoadingRecipients = true;
  bool _isLoadingTransactions = true;
  bool _isSubmitting = false;
  
  bool _hasAccountsError = false;
  bool _hasRecipientsError = false;
  bool _hasTransactionsError = false;
  
  String _accountsErrorMessage = '';
  String _recipientsErrorMessage = '';
  String _transactionsErrorMessage = '';
  
  List<Account> _accounts = [];
  List<Recipient> _recipients = [];
  List<Transaction> _transactions = [];
  
  Account? _selectedAccount;
  Recipient? _selectedRecipient;
  
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _loadAccounts();
    _loadRecipients();
    _loadTransactions();
  }

  Future<void> _loadAccounts() async {
    setState(() {
      _isLoadingAccounts = true;
      _hasAccountsError = false;
    });

    try {
      final accounts = await TransferService.getUserAccounts();
      setState(() {
        _accounts = accounts;
        _selectedAccount = accounts.isNotEmpty ? accounts[0] : null;
        _isLoadingAccounts = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingAccounts = false;
        _hasAccountsError = true;
        _accountsErrorMessage = e.toString();
      });
    }
  }

  Future<void> _loadRecipients() async {
    setState(() {
      _isLoadingRecipients = true;
      _hasRecipientsError = false;
    });

    try {
      final recipients = await TransferService.getRecipients();
      setState(() {
        _recipients = recipients;
        _selectedRecipient = recipients.isNotEmpty ? recipients[0] : null;
        _isLoadingRecipients = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingRecipients = false;
        _hasRecipientsError = true;
        _recipientsErrorMessage = e.toString();
      });
    }
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoadingTransactions = true;
      _hasTransactionsError = false;
    });

    try {
      final transactions = await TransferService.getRecentTransactions();
      setState(() {
        _transactions = transactions;
        _isLoadingTransactions = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTransactions = false;
        _hasTransactionsError = true;
        _transactionsErrorMessage = e.toString();
      });
    }
  }

  Future<void> _submitTransfer() async {
    // Validate amount
    if (_amountController.text.isEmpty) {
      setState(() {
        _amountError = 'Please enter an amount';
      });
      return;
    }
    
    final amount = double.tryParse(_amountController.text.replaceAll(',', ''));
    if (amount == null) {
      setState(() {
        _amountError = 'Please enter a valid amount';
      });
      return;
    }
    
    if (amount <= 0) {
      setState(() {
        _amountError = 'Amount must be greater than 0';
      });
      return;
    }
    
    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a source account')),
      );
      return;
    }
    
    if (_selectedRecipient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a recipient')),
      );
      return;
    }
    
    if (amount > _selectedAccount!.balance) {
      setState(() {
        _amountError = 'Insufficient funds';
      });
      return;
    }
    
    setState(() {
      _amountError = null;
      _isSubmitting = true;
    });
    
    try {
      final success = await TransferService.submitTransfer(
        fromAccountId: _selectedAccount!.id,
        toRecipientId: _selectedRecipient!.id,
        amount: amount,
        note: _noteController.text,
      );
      
      setState(() {
        _isSubmitting = false;
      });
      
      if (success) {
        _showSuccessDialog(amount);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Transfer Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'You have successfully transferred ${amount.toStringAsFixed(0).replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              )} VND to ${_selectedRecipient!.name}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset form
              _amountController.clear();
              _noteController.clear();
              // Reload data
              _loadData();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
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
              // App bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle back button
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Transfer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    child: ListView(
                      padding: const EdgeInsets.all(20.0),
                      children: [
                        const SizedBox(height: 20),
                        // From account
                        const Text(
                          'From',
                          style: TextStyle(
                            color: Color(0xFF1A3A6B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _isLoadingAccounts
                            ? _buildLoadingDropdown()
                            : _hasAccountsError
                                ? _buildErrorDropdown(_accountsErrorMessage, _loadAccounts)
                                : _buildAccountDropdown(),
                        const SizedBox(height: 30),
                        // To recipient
                        const Text(
                          'To',
                          style: TextStyle(
                            color: Color(0xFF1A3A6B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _isLoadingRecipients
                            ? _buildLoadingDropdown()
                            : _hasRecipientsError
                                ? _buildErrorDropdown(_recipientsErrorMessage, _loadRecipients)
                                : _buildRecipientDropdown(),
                        const SizedBox(height: 30),
                        // Amount
                        const Text(
                          'Amount',
                          style: TextStyle(
                            color: Color(0xFF1A3A6B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            // Clear error when user types
                            if (_amountError != null) {
                              setState(() {
                                _amountError = null;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: '0 VND',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.monetization_on_outlined,
                              color: Color(0xFF5A8ED0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: _amountError != null
                                    ? Colors.red
                                    : Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: _amountError != null
                                    ? Colors.red
                                    : const Color(0xFF5A8ED0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            errorText: _amountError,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Note
                        const Text(
                          'Note',
                          style: TextStyle(
                            color: Color(0xFF1A3A6B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Add a note (optional)',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0xFF5A8ED0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Recent transactions
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                            color: Color(0xFF1A3A6B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Transaction list
                        _isLoadingTransactions
                            ? _buildLoadingTransactions()
                            : _hasTransactionsError
                                ? _buildTransactionsError()
                                : _buildTransactionsList(),
                        const SizedBox(height: 40),
                        // Continue button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ||
                                    _isLoadingAccounts ||
                                    _isLoadingRecipients ||
                                    _hasAccountsError ||
                                    _hasRecipientsError ||
                                    _selectedAccount == null ||
                                    _selectedRecipient == null
                                ? null
                                : _submitTransfer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A3A6B),
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'CONTINUE',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingDropdown() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorDropdown(String errorMessage, VoidCallback onRetry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Error: $errorMessage',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDropdown() {
    if (_accounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text('No accounts available'),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Account>(
          isExpanded: true,
          value: _selectedAccount,
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          onChanged: (Account? newValue) {
            setState(() {
              _selectedAccount = newValue;
            });
          },
          items: _accounts.map<DropdownMenuItem<Account>>((Account account) {
            return DropdownMenuItem<Account>(
              value: account,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF93B5E1).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Color(0xFF1A3A6B),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        account.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        account.formattedBalance,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecipientDropdown() {
    if (_recipients.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text('No recipients available'),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Recipient>(
          isExpanded: true,
          value: _selectedRecipient,
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          onChanged: (Recipient? newValue) {
            setState(() {
              _selectedRecipient = newValue;
            });
          },
          items: _recipients.map<DropdownMenuItem<Recipient>>((Recipient recipient) {
            return DropdownMenuItem<Recipient>(
              value: recipient,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF93B5E1).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF1A3A6B),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        recipient.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        recipient.formattedAccount,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLoadingTransactions() {
    return Column(
      children: [
        _buildShimmerTransaction(),
        const SizedBox(height: 10),
        _buildShimmerTransaction(),
        const SizedBox(height: 10),
        _buildShimmerTransaction(),
      ],
    );
  }

  Widget _buildShimmerTransaction() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 16,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 180,
                  height: 12,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 80,
                height: 16,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 12,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsError() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(
            'Failed to load transactions: $_transactionsErrorMessage',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadTransactions,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3A6B),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(Icons.history, color: Colors.grey.shade400, size: 40),
            const SizedBox(height: 10),
            Text(
              'No recent transactions',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _transactions.map((transaction) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildTransactionItem(
            name: transaction.recipientName,
            accountNumber: transaction.formattedAccount,
            date: transaction.formattedDate,
            amount: transaction.formattedAmount,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTransactionItem({
    required String name,
    required String accountNumber,
    required String date,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF93B5E1).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Color(0xFF1A3A6B), size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  accountNumber,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1A3A6B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}