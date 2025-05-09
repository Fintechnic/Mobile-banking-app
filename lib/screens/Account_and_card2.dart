import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:math' as math;
import 'package:shimmer/shimmer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display', 
      ),
      home: const AccountCardScreen(),
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
  final Color primaryColor;
  final Color secondaryColor;

  BankCard({
    required this.id,
    required this.cardType,
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryDate,
    required this.balance,
    required this.cardNetwork,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

class AccountCardScreen extends StatefulWidget {
  const AccountCardScreen({super.key});

  @override
  State<AccountCardScreen> createState() => _AccountCardScreenState();
}

class _AccountCardScreenState extends State<AccountCardScreen> with SingleTickerProviderStateMixin {
  bool _isAccountTab = false;
  bool _isLoading = true;
  List<BankCard> _cards = [];
  late PageController _pageController;
  int _currentCardIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    // Initialize page controller for card swiping
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );
    
    // Load initial data
    _loadData();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }
  
  // Load card data
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock card data
      _cards = [
        BankCard(
          id: '1',
          cardType: 'Amazon Platinum',
          cardNumber: '4756 •••• •••• 9018',
          cardholderName: 'Mr. A',
          expiryDate: '12/25',
          balance: '30.000.000 VND',
          cardNetwork: 'visa',
          primaryColor: Colors.blue[900]!,
          secondaryColor: Colors.blue[700]!,
        ),
        BankCard(
          id: '2',
          cardType: 'Amazon Platinum',
          cardNumber: '4756 •••• •••• 9018',
          cardholderName: 'Mr. A',
          expiryDate: '09/24',
          balance: '30.000.000 VND',
          cardNetwork: 'mastercard',
          primaryColor: Colors.amber[600]!,
          secondaryColor: Colors.amber[300]!,
        ),
        BankCard(
          id: '3',
          cardType: 'Premium Card',
          cardNumber: '5123 •••• •••• 7890',
          cardholderName: 'Mr. A',
          expiryDate: '06/26',
          balance: '45.000.000 VND',
          cardNetwork: 'visa',
          primaryColor: Colors.green[800]!,
          secondaryColor: Colors.green[500]!,
        ),
      ];
      
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
  
  // Show add card dialog
  void _showAddCardDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Card'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Cardholder Name'),
              ),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Card Type'),
                      items: const [
                        DropdownMenuItem(value: 'visa', child: Text('Visa')),
                        DropdownMenuItem(value: 'mastercard', child: Text('MasterCard')),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ],
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
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card request submitted')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCE0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFCCE0FF),
        elevation: 0,
        title: const Text(
          'Account & Cards',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press with animation
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tab switcher
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Account tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchTab(true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: _isAccountTab ? Colors.blue[900] : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              'Account',
                              style: TextStyle(
                                color: _isAccountTab ? Colors.white : Colors.blue[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Card tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchTab(false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: _isAccountTab ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: !_isAccountTab ? Colors.blue[900] : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Card',
                              style: TextStyle(
                                color: !_isAccountTab ? Colors.white : Colors.blue[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Card content
              Expanded(
                child: _isLoading
                    ? _buildLoadingShimmer()
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: _isAccountTab
                            ? const Center(child: Text('Account feature coming soon'))
                            : _buildCardContent(),
                      ),
              ),
              
              // Add card button
              GestureDetector(
                onTap: _showAddCardDialog,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Add card',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
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
  
  // Build loading shimmer effect
  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ],
      ),
    );
  }
  
  // Build card content with PageView for swiping
  Widget _buildCardContent() {
    if (_cards.isEmpty) {
      return const Center(
        child: Text('No cards found. Add your first card.'),
      );
    }
    
    return Column(
      children: [
        // Card page view
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _cards.length,
            onPageChanged: (index) {
              setState(() {
                _currentCardIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final card = _cards[index];
              // Apply scale effect to cards
              final double scale = _currentCardIndex == index ? 1.0 : 0.9;
              
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.9, end: scale),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: _buildCardItem(card),
              );
            },
          ),
        ),
        
        // Card indicators
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _cards.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentCardIndex == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentCardIndex == index
                    ? Colors.blue[900]
                    : Colors.blue[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        
        // Card details
        const SizedBox(height: 30),
        _buildCardDetails(_cards[_currentCardIndex]),
      ],
    );
  }
  
  // Build individual card item
  Widget _buildCardItem(BankCard card) {
    return Hero(
      tag: 'card_${card.id}',
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [card.primaryColor, card.secondaryColor],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: card.primaryColor.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
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
    );
  }
  
  // Build card network logo
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
  
  // Build card details section
  Widget _buildCardDetails(BankCard card) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow('Card Holder', card.cardholderName),
          const Divider(height: 16),
          _buildDetailRow('Card Number', card.cardNumber),
          const Divider(height: 16),
          _buildDetailRow('Expiry Date', card.expiryDate),
          const Divider(height: 16),
          _buildDetailRow('Available Balance', card.balance),
        ],
      ),
    );
  }
  
  // Build detail row for card details
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
