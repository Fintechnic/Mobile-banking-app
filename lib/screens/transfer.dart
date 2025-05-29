import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

// API Service
class TransferService {
  static const String baseUrl =
      'https://api.example.com'; // Replace with your API URL

  // Fetch user accounts
  static Future<List<Account>> getUserAccounts() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));
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
      // Get the transaction provider instance
      final transactionService = TransactionService();
      
      // Call the real API service
      final success = await transactionService.transferMoney(
        toRecipientId,  // Using recipient ID as phone number
        amount,
        description: note,
      );
      
      return success;
    } catch (e) {
      throw Exception('Failed to submit transfer: $e');
    }
  }
}

class TransferScreen extends StatefulWidget {
  final String? receiverId;
  final String? receiverPhone;
  final bool fromQRScan;
  
  const TransferScreen({
    super.key, 
    this.receiverId,
    this.receiverPhone,
    this.fromQRScan = false,
  });

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isSubmitting = false;
  String? _amountError;
  String? _phoneNumberError;

  @override
  void initState() {
    super.initState();
    // Fill in receiver phone number from QR scan if available
    if (widget.fromQRScan && widget.receiverPhone != null) {
      _phoneNumberController.text = widget.receiverPhone!;
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
    
    // Validate phone number
    if (_phoneNumberController.text.isEmpty) {
      setState(() {
        _phoneNumberError = 'Please enter a phone number';
      });
      return;
    }
    
    // Basic phone number validation
    if (_phoneNumberController.text.length < 10) {
      setState(() {
        _phoneNumberError = 'Please enter a valid phone number';
      });
      return;
    }

    setState(() {
      _amountError = null;
      _phoneNumberError = null;
      _isSubmitting = true;
    });

    try {
      // Get recipient phone number
      final String phoneNumber = _phoneNumberController.text;
      
      // Create transaction service instance directly
      final transactionService = TransactionService();
      
      final success = await transactionService.transferMoney(
        phoneNumber,
        amount,
        description: _noteController.text.isNotEmpty ? _noteController.text : null,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;

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

      if (!mounted) return;
      
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
                  )} VND to ${_phoneNumberController.text}',
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
              _phoneNumberController.clear();
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
    _phoneNumberController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the auth provider
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Set username from auth provider
    _usernameController.text = authProvider.username ?? 'Current User';
    
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
                        Navigator.pop(context);
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
                  child: ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      const SizedBox(height: 20),
                      // From account - now a locked text field with username
                      const Text(
                        'From',
                        style: TextStyle(
                          color: Color(0xFF1A3A6B),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _usernameController,
                        readOnly: true,
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.account_circle,
                            color: Color(0xFF5A8ED0),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // To recipient - now just a phone number input
                      const Text(
                        'To',
                        style: TextStyle(
                          color: Color(0xFF1A3A6B),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter recipient phone number',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          errorText: _phoneNumberError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                          prefixIcon: const Icon(Icons.phone, color: Color(0xFF1A3A6B)),
                        ),
                        onChanged: (value) {
                          if (_phoneNumberError != null) {
                            setState(() {
                              _phoneNumberError = null;
                            });
                          }
                        },
                      ),
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
                          if (_amountError != null) {
                            setState(() {
                              _amountError = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Nhập số tiền',
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
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
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
                      const SizedBox(height: 40),
                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitTransfer,
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
            ],
          ),
        ),
      ),
    );
  }
}
