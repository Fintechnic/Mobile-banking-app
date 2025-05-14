import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const AccountScreen(),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E4FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button, title and action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  // Message button
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.message_outlined, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Phone button
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone, size: 20),
                  ),
                ],
              ),
            ),
            
            // Main content with white background and rounded top corners
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    AccountCard(
                      accountName: 'Account 1',
                      accountNumber: '1900 8988 1234',
                      balance: '1,000,000 VND',
                      type: 'Bank',
                      provider: 'AAA',
                    ),
                    AccountCard(
                      accountName: 'Account 2',
                      accountNumber: '8988 1234',
                      balance: '23,000 VND',
                      type: 'E-Wallet',
                      provider: 'Apple Pay',
                    ),
                    AccountCard(
                      accountName: 'Postpaid Wallet',
                      accountNumber: '',
                      balance: '30,000,000 VND',
                      type: 'Available balance',
                      provider: '',
                    ),
                    AccountCard(
                      accountName: 'Saving',
                      accountNumber: '',
                      balance: '30,000,000 VND',
                      type: 'Available balance',
                      provider: '',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF7EAEFF),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final String accountName;
  final String accountNumber;
  final String balance;
  final String type;
  final String provider;

  const AccountCard({
    Key? key,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    required this.type,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account name and number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                accountName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              if (accountNumber.isNotEmpty)
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
          
          // Balance and type information
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
                  if (type != 'Available balance')
                    const SizedBox(height: 4),
                  if (type != 'Available balance')
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    balance,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                  if (provider.isNotEmpty)
                    const SizedBox(height: 4),
                  if (provider.isNotEmpty)
                    Text(
                      provider,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
