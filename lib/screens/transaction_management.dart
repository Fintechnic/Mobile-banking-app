import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:fintechnic/services/transaction_service.dart';
import 'package:fintechnic/models/transaction.dart' as app_transaction;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'SF Pro Display',
      ),
      home: const TransactionManagementScreen(),
    );
  }
}

// Transaction category model
class TransactionCategory {
  final String title;
  final String value;
  final Color color;
  final double percentage;

  TransactionCategory({
    required this.title,
    required this.value,
    required this.color,
    required this.percentage,
  });
}

// Daily data model
class DailyData {
  final String day;
  final double userValue;
  final double transactionValue;

  DailyData({
    required this.day,
    required this.userValue,
    required this.transactionValue,
  });
}

class TransactionManagementScreen extends StatefulWidget {
  const TransactionManagementScreen({super.key});

  @override
  State<TransactionManagementScreen> createState() =>
      _TransactionManagementScreenState();
}

class _TransactionManagementScreenState
    extends State<TransactionManagementScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _selectedYear = DateTime.now().year;
  String _selectedPeriod = 'Week';
  final List<String> _periods = ['Day', 'Week', 'Month', 'Year'];
  
  // Filter parameters
  String _sortBy = "createdAt";
  String _sortDirection = "DESC";
  int _page = 0;
  int _size = 20;
  String? _selectedType;
  String? _selectedStatus;
  double? _minAmount;
  double? _maxAmount;
  DateTime? _startDate;
  DateTime? _endDate;
  
  // Service
  final TransactionService _transactionService = TransactionService();
  
  // Transactions
  List<dynamic> _transactions = [];

  // Data
  int _totalUsers = 0;
  List<TransactionCategory> _categories = [];
  List<DailyData> _dailyData = [];

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );
    
    // Initialize date range (last 7 days by default)
    final now = DateTime.now();
    _endDate = now;
    _startDate = now.subtract(const Duration(days: 7));

    // Load data
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Load data using the filter API
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Fetch filtered transactions
      final transactions = await _transactionService.filterTransactions(
        sortBy: _sortBy,
        sortDirection: _sortDirection,
        page: _page,
        size: _size,
        type: _selectedType,
        status: _selectedStatus,
        startDate: _startDate,
        endDate: _endDate,
        minAmount: _minAmount,
        maxAmount: _maxAmount,
      );
      
      debugPrint("Filtered transactions: ${transactions.length}");
      
      setState(() {
        _transactions = transactions;
      });
      
      // Process transaction data for charts and statistics
      _processTransactionData();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Start animations
        _animationController.forward();
      }
    } catch (e) {
      debugPrint("Error loading transactions: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load data: ${e.toString()}';
        });
      }
      // Load mock data instead
      _loadMockData();
    }
  }
  
  // Process transaction data to generate statistics and charts
  void _processTransactionData() {
    if (_transactions.isEmpty) {
      _loadMockData();
      return;
    }
    
    try {
      // Calculate total users (approximation based on unique sender/receiver)
      final Set<String> uniqueUsers = {};
      
      // Category counters
      Map<String, int> categoryCounts = {
        'Banking': 0,
        'Trans': 0,
        'Bills': 0,
        'Top up': 0,
      };
      
      // Daily transaction counts
      Map<String, int> dailyUserCounts = {};
      Map<String, int> dailyTransactionCounts = {};
      
      // Process each transaction
      for (var item in _transactions) {
        final transaction = app_transaction.Transaction.fromJson(item);
        
        // Add unique users
        if (transaction.senderPhoneNumber != null) {
          uniqueUsers.add(transaction.senderPhoneNumber!);
        }
        if (transaction.receiverPhoneNumber != null) {
          uniqueUsers.add(transaction.receiverPhoneNumber!);
        }
        
        // Categorize transaction
        String category = 'Trans';
        switch (transaction.type.toLowerCase()) {
          case 'deposit':
          case 'withdraw':
            category = 'Banking';
            break;
          case 'transfer':
            category = 'Trans';
            break;
          case 'bill_payment':
            category = 'Bills';
            break;
          case 'top_up':
            category = 'Top up';
            break;
        }
        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
        
        // Calculate daily counts
        final day = DateFormat('E').format(DateTime.parse(transaction.createdAt)).substring(0, 2);
        dailyUserCounts[day] = (dailyUserCounts[day] ?? 0) + 1;
        dailyTransactionCounts[day] = (dailyTransactionCounts[day] ?? 0) + 1;
      }
      
      // Set total users
      _totalUsers = uniqueUsers.length > 0 ? uniqueUsers.length : 162387;
      
      // Create categories data
      final total = categoryCounts.values.fold(0, (sum, count) => sum + count);
      _categories = categoryCounts.entries.map((entry) {
        Color color = Colors.blue;
        switch (entry.key) {
          case 'Banking':
            color = Colors.blue;
            break;
          case 'Trans':
            color = Colors.orange;
            break;
          case 'Bills':
            color = Colors.green;
            break;
          case 'Top up':
            color = Colors.amber;
            break;
        }
        
        return TransactionCategory(
          title: entry.key,
          value: '${entry.value}',
          color: color,
          percentage: total > 0 ? entry.value / total : 0.25,
        );
      }).toList();
      
      // Create daily data
      final days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
      _dailyData = days.map((day) {
        return DailyData(
          day: day,
          userValue: (dailyUserCounts[day] ?? 0).toDouble(),
          transactionValue: (dailyTransactionCounts[day] ?? 0).toDouble(),
        );
      }).toList();
      
      // If we have no data, load mock data
      if (_categories.isEmpty || _dailyData.every((d) => d.userValue == 0 && d.transactionValue == 0)) {
        _loadMockData();
      }
    } catch (e) {
      debugPrint("Error processing transaction data: $e");
      _loadMockData();
    }
  }

  // Load mock data
  void _loadMockData() {
    // Total users
    _totalUsers = 162387;

    // Categories
    _categories = [
      TransactionCategory(
        title: 'Banking',
        value: '20K',
        color: Colors.blue,
        percentage: 0.15,
      ),
      TransactionCategory(
        title: 'Trans',
        value: '36K',
        color: Colors.orange,
        percentage: 0.20,
      ),
      TransactionCategory(
        title: 'Bills',
        value: '32K',
        color: Colors.green,
        percentage: 0.20,
      ),
      TransactionCategory(
        title: 'Top up',
        value: '74K',
        color: Colors.amber,
        percentage: 0.45,
      ),
    ];

    // Daily data
    _dailyData = [
      DailyData(day: 'Mo', userValue: 10, transactionValue: 8),
      DailyData(day: 'Tu', userValue: 18, transactionValue: 12),
      DailyData(day: 'We', userValue: 14, transactionValue: 10),
      DailyData(day: 'Th', userValue: 15, transactionValue: 11),
      DailyData(day: 'Fr', userValue: 16, transactionValue: 13),
      DailyData(day: 'Sa', userValue: 19, transactionValue: 10),
    ];
  }

  // Change filter period
  void _changePeriod(int direction) {
    final currentIndex = _periods.indexOf(_selectedPeriod);
    final newIndex = (currentIndex + direction) % _periods.length;
    setState(() {
      _selectedPeriod = _periods[newIndex];
      
      // Update date range based on selected period
      final now = DateTime.now();
      _endDate = now;
      
      switch (_selectedPeriod) {
        case 'Day':
          _startDate = now.subtract(const Duration(days: 1));
          break;
        case 'Week':
          _startDate = now.subtract(const Duration(days: 7));
          break;
        case 'Month':
          _startDate = DateTime(now.year, now.month - 1, now.day);
          break;
        case 'Year':
          _startDate = DateTime(now.year - 1, now.month, now.day);
          break;
      }
    });
    
    // Reload data with new date range
    _loadData();
  }
  
  // Change year
  void _changeYear(int delta) {
    setState(() {
      _selectedYear += delta;
      
      // Update date range based on selected year
      final now = DateTime.now();
      if (now.year == _selectedYear) {
        _endDate = now;
      } else {
        _endDate = DateTime(_selectedYear, 12, 31);
      }
      _startDate = DateTime(_selectedYear, 1, 1);
      
      _animationController.reset();
    });
    
    // Reload data with new year
    _loadData();
  }

  // Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Transactions'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Transaction Type'),
                value: _selectedType,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Types')),
                  const DropdownMenuItem(value: 'deposit', child: Text('Deposit')),
                  const DropdownMenuItem(value: 'withdraw', child: Text('Withdraw')),
                  const DropdownMenuItem(value: 'transfer', child: Text('Transfer')),
                  const DropdownMenuItem(value: 'bill_payment', child: Text('Bill Payment')),
                  const DropdownMenuItem(value: 'top_up', child: Text('Top Up')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Sort By'),
                value: _sortBy,
                items: const [
                  DropdownMenuItem(value: 'createdAt', child: Text('Date')),
                  DropdownMenuItem(value: 'amount', child: Text('Amount')),
                  DropdownMenuItem(value: 'type', child: Text('Type')),
                ],
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Sort Direction'),
                value: _sortDirection,
                items: const [
                  DropdownMenuItem(value: 'DESC', child: Text('Descending')),
                  DropdownMenuItem(value: 'ASC', child: Text('Ascending')),
                ],
                onChanged: (value) {
                  setState(() {
                    _sortDirection = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Amount Range', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Min'),
                      keyboardType: TextInputType.number,
                      initialValue: _minAmount?.toString(),
                      onChanged: (value) {
                        setState(() {
                          _minAmount = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Max'),
                      keyboardType: TextInputType.number,
                      initialValue: _maxAmount?.toString(),
                      onChanged: (value) {
                        setState(() {
                          _maxAmount = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadData(); // Apply filters
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  // Show category details
  void _showCategoryDetails(TransactionCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 6,
                  backgroundColor: category.color,
                ),
                const SizedBox(width: 8),
                Text(
                  'Total: ${category.value}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${(category.percentage * 100).toStringAsFixed(1)}% of all transactions'),
            const SizedBox(height: 16),
            Text('This includes all transactions categorized as ${category.title.toLowerCase()}.')
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _categories.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading data...'),
              ],
            ),
          ),
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(_errorMessage),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Transaction Management',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Transactions',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Year selector
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left,
                                color: Colors.black54),
                            onPressed: () => _changeYear(-1),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _selectedYear.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.chevron_right,
                                color: Colors.black54),
                            onPressed: () => _changeYear(1),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Circular progress chart
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Center(
                        child: SizedBox(
                          height: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 180,
                                height: 180,
                                child: CustomPaint(
                                  painter: CircularChartPainter(
                                    segments: _categories
                                        .map((category) => _ChartSegment(
                                              startAngle:
                                                  0, // Will be calculated in the painter
                                              endAngle: category.percentage,
                                              color: category.color,
                                            ))
                                        .toList(),
                                    animationValue: _chartAnimation.value,
                                  ),
                                ),
                              ),
                              TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: _totalUsers),
                                duration: const Duration(seconds: 2),
                                builder: (context, value, child) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        value.toString(),
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Text(
                                        'Users',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Categories
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          _categories.length,
                          (index) => GestureDetector(
                            onTap: () =>
                                _showCategoryDetails(_categories[index]),
                            child: CategoryItem(
                              color: _categories[index].color,
                              title: _categories[index].title,
                              value: _categories[index].value,
                              delay: index * 100,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Users Report section
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Users Report',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _changePeriod(-1),
                                child: const Icon(Icons.chevron_left,
                                    size: 18, color: Colors.black54),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _selectedPeriod,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => _changePeriod(1),
                                child: const Icon(Icons.chevron_right,
                                    size: 18, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // Legend
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.amber,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'User',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 16),
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.deepPurple,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Transaction',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // Bar chart
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: CustomBarChart(
                        dailyData: _dailyData,
                        animationValue: _chartAnimation.value,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Color color;
  final String title;
  final String value;
  final int delay;

  const CategoryItem({
    super.key,
    required this.color,
    required this.title,
    required this.value,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: color,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          value as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CircularChartPainter extends CustomPainter {
  final List<_ChartSegment> segments;
  final double animationValue;

  CircularChartPainter({
    required this.segments,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Calculate start and end angles
    double startAngle = 0.0;
    for (var i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final endAngle = startAngle + segment.endAngle;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;

      // Apply animation
      final sweepAngle = (endAngle - startAngle) * animationValue;

      canvas.drawArc(
        rect,
        startAngle * 2 * math.pi - math.pi / 2,
        sweepAngle * 2 * math.pi,
        false,
        paint,
      );

      startAngle = endAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CircularChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class _ChartSegment {
  final double startAngle;
  final double endAngle;
  final Color color;

  _ChartSegment({
    required this.startAngle,
    required this.endAngle,
    required this.color,
  });
}

class CustomBarChart extends StatelessWidget {
  final List<DailyData> dailyData;
  final double animationValue;
  final double maxValue = 20;

  const CustomBarChart({
    super.key,
    required this.dailyData,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Y-axis labels
              const SizedBox(
                width: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('20k',
                        style: TextStyle(fontSize: 10, color: Colors.black54)),
                    Text('15k',
                        style: TextStyle(fontSize: 10, color: Colors.black54)),
                    Text('10k',
                        style: TextStyle(fontSize: 10, color: Colors.black54)),
                    Text('5k',
                        style: TextStyle(fontSize: 10, color: Colors.black54)),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Bars
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barWidth =
                        constraints.maxWidth / dailyData.length * 0.3;
                    final groupWidth = constraints.maxWidth / dailyData.length;
                    final chartHeight = constraints.maxHeight - 20;

                    return Stack(
                      children: [
                        // Grid lines
                        ...List.generate(4, (index) {
                          final y = index * chartHeight / 4;
                          return Positioned(
                            top: y,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          );
                        }),

                        // Bars
                        ...List.generate(dailyData.length, (index) {
                          final userHeight =
                              (dailyData[index].userValue / maxValue) *
                                  chartHeight *
                                  animationValue;
                          final transactionHeight =
                              (dailyData[index].transactionValue / maxValue) *
                                  chartHeight *
                                  animationValue;

                          return Positioned(
                            bottom: 0,
                            left: index * groupWidth,
                            width: groupWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: chartHeight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: barWidth,
                                        height: userHeight,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(width: barWidth * 0.2),
                                      Container(
                                        width: barWidth,
                                        height: transactionHeight,
                                        color: Colors.deepPurple,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  dailyData[index].day,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
