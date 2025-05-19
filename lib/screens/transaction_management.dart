import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

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
  int _selectedYear = 2025;
  String _selectedPeriod = 'Week';
  final List<String> _periods = ['Day', 'Week', 'Month', 'Year'];

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

    // Load data
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Load data with simulated network delay
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Generate random data
      // final random = math.Random();

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

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Start animations
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load data. Please try again.';
        });
      }
    }
  }

  // Change year
  void _changeYear(int delta) {
    setState(() {
      _selectedYear += delta;
      _animationController.reset();
    });

    _loadData();
  }

  // Change period
  void _changePeriod(int delta) {
    final currentIndex = _periods.indexOf(_selectedPeriod);
    final newIndex = (currentIndex + delta) % _periods.length;

    setState(() {
      _selectedPeriod = _periods[newIndex];
      _animationController.reset();
    });

    _loadData();
  }

  // Show category details
  void _showCategoryDetails(TransactionCategory category) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${category.title} Details',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Value: ${category.value}'),
                Text(
                    'Percentage: ${(category.percentage * 100).toStringAsFixed(1)}%'),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: category.percentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(category.color),
              minHeight: 8,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: category.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Close'),
            ),
          ],
        ),
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
