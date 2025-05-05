import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

// Main app class
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: const AccountCardsScreen1(),
    );
  }
}

// Account model class
class Account {
  final String id;
  final String accountName;
  final String accountNumber;
  final String balance;
  final String branch;
  final bool isPrimary;

  Account({
    required this.id,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    required this.branch,
    this.isPrimary = false,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      accountName: json['accountName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      balance: json['balance'] ?? '0',
      branch: json['branch'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}

// Card model class
class BankCard {
  final String id;
  final String cardType;
  final String cardNumber;
  final String cardholderName;
  final String expiryDate;
  final String balance;
  final String cardNetwork;
  final Color cardColor;

  BankCard({
    required this.id,
    required this.cardType,
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryDate,
    required this.balance,
    required this.cardNetwork,
    required this.cardColor,
  });

  factory BankCard.fromJson(Map<String, dynamic> json) {
    return BankCard(
      id: json['id'] ?? '',
      cardType: json['cardType'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      cardholderName: json['cardholderName'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      balance: json['balance'] ?? '0',
      cardNetwork: json['cardNetwork'] ?? 'visa',
      cardColor: _getCardColor(json['cardColor']),
    );
  }

  static Color _getCardColor(String? colorCode) {
    if (colorCode == 'blue') {
      return const Color(0xFF0A3A7D);
    } else if (colorCode == 'gold') {
      return const Color(0xFFD4AF37);
    } else {
      return const Color(0xFF0A3A7D);
    }
  }
}

// Banking service for API calls
class BankingService {
  static const String _baseUrl = 'https://api.example.com'; // Replace with your API URL
  
  // Simulate API call to fetch accounts
  static Future<List<Account>> getAccounts() async {
    // In a real app, you would make an HTTP request
    // final response = await http.get(Uri.parse('$_baseUrl/accounts'));
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //   return data.map((json) => Account.fromJson(json)).toList();
    // } else {
    //   throw Exception('Failed to load accounts');
    // }
    
    // For demo, we'll simulate a delay and return mock data
    await Future.delayed(const Duration(seconds: 2));
    
    return [
      Account(
        id: '1',
        accountName: 'Account 1',
        accountNumber: '1950 8888 1234',
        balance: '1,600,000 VND',
        branch: 'Vietnam',
        isPrimary: true,
      ),
      Account(
        id: '2',
        accountName: 'Account 2',
        accountNumber: '6888 1234',
        balance: '23,000 VND',
        branch: 'Vietnam',
      ),
      Account(
        id: '3',
        accountName: 'Account 3',
        accountNumber: '1000 1234 2222',
        balance: '36,000,000 VND',
        branch: 'Vietnam',
      ),
    ];
  }
  
  // Simulate API call to fetch cards
  static Future<List<BankCard>> getCards() async {
    // In a real app, you would make an HTTP request
    // final response = await http.get(Uri.parse('$_baseUrl/cards'));
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //   return data.map((json) => BankCard.fromJson(json)).toList();
    // } else {
    //   throw Exception('Failed to load cards');
    // }
    
    // For demo, we'll simulate a delay and return mock data
    await Future.delayed(const Duration(seconds: 2));
    
    return [
      BankCard(
        id: '1',
        cardType: 'Amazon Platinum',
        cardNumber: '4756 •••• •••• 9018',
        cardholderName: 'Mr. A',
        expiryDate: '12/25',
        balance: '30,000,000 VND',
        cardNetwork: 'visa',
        cardColor: const Color(0xFF0A3A7D),
      ),
      BankCard(
        id: '2',
        cardType: 'Gold Card',
        cardNumber: '5123 •••• •••• 4567',
        cardholderName: 'Mr. A',
        expiryDate: '09/24',
        balance: '15,000,000 VND',
        cardNetwork: 'mastercard',
        cardColor: const Color(0xFFD4AF37),
      ),
    ];
  }
  
  // Simulate API call to add a new account
  static Future<Account> addAccount(Account account) async {
    // In a real app, you would make an HTTP request
    // final response = await http.post(
    //   Uri.parse('$_baseUrl/accounts'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode({
    //     'accountName': account.accountName,
    //     'accountNumber': account.accountNumber,
    //     'balance': account.balance,
    //     'branch': account.branch,
    //   }),
    // );
    // if (response.statusCode == 201) {
    //   return Account.fromJson(json.decode(response.body));
    // } else {
    //   throw Exception('Failed to add account');
    // }
    
    // For demo, we'll simulate a delay and return the account with an ID
    await Future.delayed(const Duration(seconds: 1));
    
    return Account(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      accountName: account.accountName,
      accountNumber: account.accountNumber,
      balance: account.balance,
      branch: account.branch,
    );
  }
}

// Main screen for accounts and cards
class AccountCardsScreen1 extends StatefulWidget {
  const AccountCardsScreen1({Key? key}) : super(key: key);

  @override
  State<AccountCardsScreen1> createState() => _AccountCardsScreen1State();
}

class _AccountCardsScreen1State extends State<AccountCardsScreen1> with SingleTickerProviderStateMixin {
  bool _isAccountTab = true;
  bool _isLoading = true;
  List<Account> _accounts = [];
  List<BankCard> _cards = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    // Load initial data
    _loadData();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // Load data based on selected tab
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (_isAccountTab) {
        _accounts = await BankingService.getAccounts();
      } else {
        _cards = await BankingService.getCards();
      }
      
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Switch between account and card tabs
  void _switchTab(bool isAccountTab) {
    if (_isAccountTab != isAccountTab) {
      setState(() {
        _isAccountTab = isAccountTab;
      });
      _loadData();
    }
  }
  
  // Show add account/card dialog
  void _showAddDialog() {
    if (_isAccountTab) {
      _showAddAccountDialog();
    } else {
      _showAddCardDialog();
    }
  }
  
  // Show dialog to add a new account
  void _showAddAccountDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final TextEditingController balanceController = TextEditingController();
    final TextEditingController branchController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Account'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Account Name'),
              ),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Account Number'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: balanceController,
                decoration: const InputDecoration(labelText: 'Initial Balance'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: branchController,
                decoration: const InputDecoration(labelText: 'Branch'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && numberController.text.isNotEmpty) {
                Navigator.pop(context);
                
                setState(() {
                  _isLoading = true;
                });
                
                try {
                  final newAccount = await BankingService.addAccount(
                    Account(
                      id: '',
                      accountName: nameController.text,
                      accountNumber: numberController.text,
                      balance: balanceController.text.isNotEmpty 
                          ? '${balanceController.text} VND' 
                          : '0 VND',
                      branch: branchController.text.isNotEmpty 
                          ? branchController.text 
                          : 'Vietnam',
                    ),
                  );
                  
                  setState(() {
                    _accounts.add(newAccount);
                    _isLoading = false;
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account added successfully')),
                  );
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add account: $e')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  
  // Show dialog to add a new card
  void _showAddCardDialog() {
    // Similar implementation as _showAddAccountDialog but for cards
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add card functionality coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            _buildHeader(),
            
            // Content area
            Expanded(
              child: _isLoading
                  ? _buildLoadingShimmer()
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: _isAccountTab
                          ? _buildAccountsList()
                          : _buildCardsList(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  // Build header with tabs
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFD6E4FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Handle back button press
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Back button pressed')),
                  );
                },
                child: const Icon(Icons.arrow_back_ios, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                'Account & Cards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Tab buttons
          Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _switchTab(true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _isAccountTab
                          ? const Color(0xFF0A3A7D)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Account',
                      style: TextStyle(
                        color: _isAccountTab
                            ? Colors.white
                            : const Color(0xFF0A3A7D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _switchTab(false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: !_isAccountTab
                          ? const Color(0xFF0A3A7D)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Card',
                      style: TextStyle(
                        color: !_isAccountTab
                            ? Colors.white
                            : const Color(0xFF0A3A7D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(flex: 2, child: SizedBox()),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
  
  // Build loading shimmer effect
  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
  }
  
  // Build accounts list
  Widget _buildAccountsList() {
    if (_accounts.isEmpty) {
      return const Center(
        child: Text('No accounts found. Add your first account.'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: _accounts.length,
      itemBuilder: (context, index) {
        final account = _accounts[index];
        return AccountCard(
          accountName: account.accountName,
          accountNumber: account.accountNumber,
          balance: account.balance,
          branch: account.branch,
          isPrimary: account.isPrimary,
          onTap: () {
            // Handle account tap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Account ${account.accountName} tapped')),
            );
          },
        );
      },
    );
  }
  
  // Build cards list
  Widget _buildCardsList() {
    if (_cards.isEmpty) {
      return const Center(
        child: Text('No cards found. Add your first card.'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        final card = _cards[index];
        return CardItem(
          card: card,
          onTap: () {
            // Handle card tap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Card ${card.cardType} tapped')),
            );
          },
        );
      },
    );
  }
}

// Widget for displaying account information
class AccountCard extends StatelessWidget {
  final String accountName;
  final String accountNumber;
  final String balance;
  final String branch;
  final bool isPrimary;
  final VoidCallback? onTap;

  const AccountCard({
    Key? key,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    required this.branch,
    this.isPrimary = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'account_$accountNumber',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
              color: isPrimary ? const Color(0xFFF5F9FF) : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          accountName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (isPrimary)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Primary',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      accountNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available balance',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          branch,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      balance,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget for displaying card information
class CardItem extends StatelessWidget {
  final BankCard card;
  final VoidCallback? onTap;

  const CardItem({
    Key? key,
    required this.card,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'card_${card.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  card.cardColor,
                  card.cardColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: card.cardColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.cardholderName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.cardType,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      card.cardNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card.balance,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildCardNetworkLogo(card.cardNetwork),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCardNetworkLogo(String network) {
    if (network.toLowerCase() == 'visa') {
      return const Text(
        'VISA',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      );
    } else if (network.toLowerCase() == 'mastercard') {
      return Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
