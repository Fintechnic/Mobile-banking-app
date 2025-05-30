import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transaction Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: const TransactionDashboard(),
    );
  }
}

class TransactionDashboard extends StatefulWidget {
  const TransactionDashboard({super.key});

  @override
  State<TransactionDashboard> createState() => _TransactionDashboardState();
}

class _TransactionDashboardState extends State<TransactionDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User profile section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-NCcl2nrSl9OVSkEdxjk3q8Ol0ZNQvT.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "User's transaction",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Amanda",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                childAspectRatio: 1.6,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  StatCard(
                    title: 'New Top-up',
                    value: '560',
                    change: '+2.5%',
                    isPositive: true,
                  ),
                  StatCard(
                    title: 'Total use',
                    value: '102,990',
                    change: '+8.5%',
                    isPositive: true,
                  ),
                  StatCard(
                    title: 'Total Paid Out',
                    value: '30,980 VND',
                    change: '-2.5%',
                    isPositive: false,
                  ),
                  StatCard(
                    title: 'New Payment',
                    value: '230',
                    change: '-5%',
                    isPositive: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Transactions list
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  TransactionsList(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Customer Details Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CUSTOMER DETAILS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'In This Year',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 18,
                              color: Colors.grey[700],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.transparent,
                      ),
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey[600],
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: _selectedTabIndex == 0
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                              const SizedBox(width: 4),
                              const Text('Top-up'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: _selectedTabIndex == 1
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                              const SizedBox(width: 4),
                              const Text('Saving'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: _selectedTabIndex == 2
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                              const SizedBox(width: 4),
                              const Text('Transaction'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bar Chart
                  const SizedBox(
                    height: 200,
                    child: BarChartWidget(),
                  ),

                  const SizedBox(height: 20),

                  // Financial Summary Cards
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    childAspectRatio: 1.6,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      FinancialCard(
                        title: 'Payment in this Period',
                        value: '60,726 VND',
                        change: '+2.5%',
                        isPositive: true,
                      ),
                      FinancialCard(
                        title: 'Expense in this Period',
                        value: '30,966 VND',
                        change: '+2.5%',
                        isPositive: true,
                      ),
                      FinancialCard(
                        title: 'Total Cashed in this Period',
                        value: '28,019 VND',
                        change: '-5%',
                        isPositive: false,
                      ),
                      FinancialCard(
                        title: 'New Income in this Period',
                        value: '30,966 VND',
                        change: '+2.5%',
                        isPositive: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pagination
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1-10 of 105 items',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {},
                        color: Colors.grey[600],
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {},
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 12,
              ),
              const SizedBox(width: 2),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FinancialCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;

  const FinancialCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Colored circle indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    change,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
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

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    final values = [500, 450, 520, 480, 510, 470];

    return Column(
      children: [
        // Y-axis labels
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('600',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                const SizedBox(height: 30),
                Text('500',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                const SizedBox(height: 30),
                Text('400',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                const SizedBox(height: 30),
                Text('200',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                const SizedBox(height: 30),
                Text('0',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(width: 10),
            // Bar chart
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  months.length,
                  (index) => Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 8,
                        height: values[index] * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.lightBlue, Colors.blue],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        months[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      Transaction(
        title: 'Payment from #10321',
        date: DateTime(2023, 3, 21, 15, 30),
        amount: '+250,000 VND',
        status: TransactionStatus.completed,
      ),
      Transaction(
        title: 'Process Refund #00910',
        date: DateTime(2023, 3, 21, 15, 30),
        amount: '-16,500 VND',
        status: TransactionStatus.completed,
      ),
      Transaction(
        title: 'Pay. Pending #097651',
        date: DateTime(2023, 3, 21, 15, 30),
        amount: '3 items',
        status: TransactionStatus.declined,
      ),
      Transaction(
        title: 'Payment From #023328',
        date: DateTime(2023, 3, 21, 15, 30),
        amount: '+250,000 VND',
        status: TransactionStatus.completed,
      ),
      Transaction(
        title: 'Pay. Pending #097651',
        date: DateTime(2023, 3, 21, 15, 30),
        amount: '+250,000 VND',
        status: TransactionStatus.completed,
      ),
    ];

    return Column(
      children: transactions
          .map((transaction) => TransactionItem(transaction: transaction))
          .toList(),
    );
  }
}

enum TransactionStatus { completed, declined, pending }

class Transaction {
  final String title;
  final DateTime date;
  final String amount;
  final TransactionStatus status;

  Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
  });
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy, h:mma');

    Color statusColor;
    String statusText;

    switch (transaction.status) {
      case TransactionStatus.completed:
        statusColor = Colors.green;
        statusText = 'Completed';
        break;
      case TransactionStatus.declined:
        statusColor = Colors.red;
        statusText = 'Declined';
        break;
      case TransactionStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(transaction.date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.amount,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: transaction.amount.startsWith('+')
                      ? Colors.green
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _refreshTokenKey = 'refresh_token';

  // Save tokens
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _tokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  // Get token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return await getAccessToken() != null;
  }

  // Clear tokens on logout
  static Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
