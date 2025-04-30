import 'package:flutter/material.dart';
import 'dart:math' as math;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

class TransactionManagementScreen extends StatelessWidget {
  const TransactionManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Year selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.black54),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    '2025',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.black54),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Circular progress chart
              Center(
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CustomPaint(
                          painter: CircularChartPainter(),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            '162387',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Users',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CategoryItem(
                    color: Colors.blue,
                    title: 'Banking',
                    value: '20k',
                  ),
                  CategoryItem(
                    color: Colors.orange,
                    title: 'Trans',
                    value: '36K',
                  ),
                  CategoryItem(
                    color: Colors.green,
                    title: 'Bills',
                    value: '32k',
                  ),
                  CategoryItem(
                    color: Colors.amber,
                    title: 'Top up',
                    value: '74K',
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Users Report section
              Row(
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
                      const Icon(Icons.chevron_left, size: 18, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text(
                        'Week',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
             
              Row(
                children: const [
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
              
              const SizedBox(height: 10),
              
              // Bar chart
              Expanded(
                child: CustomBarChart(),
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
  
  const CategoryItem({
    Key? key,
    required this.color,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CircularChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    
    final segments = [
      _ChartSegment(0.0, 0.15, Colors.blue), // Banking
      _ChartSegment(0.15, 0.35, Colors.orange), // Trans
      _ChartSegment(0.35, 0.55, Colors.green), // Bills
      _ChartSegment(0.55, 1.0, Colors.amber), // Top up
    ];
    
    
    for (var segment in segments) {
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;
      
      canvas.drawArc(
        rect,
        segment.startAngle * 2 * math.pi - math.pi / 2, 
        (segment.endAngle - segment.startAngle) * 2 * math.pi,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _ChartSegment {
  final double startAngle;
  final double endAngle;
  final Color color;
  
  _ChartSegment(this.startAngle, this.endAngle, this.color);
}

class CustomBarChart extends StatelessWidget {
  CustomBarChart({Key? key}) : super(key: key);

  final List<String> days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  final List<double> userValues = [10, 18, 14, 15, 16, 19];
  final List<double> transactionValues = [8, 12, 10, 11, 13, 10];
  final double maxValue = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              SizedBox(
                width: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('20k', style: TextStyle(fontSize: 10, color: Colors.black54)),
                    Text('15k', style: TextStyle(fontSize: 10, color: Colors.black54)),
                    Text('10k', style: TextStyle(fontSize: 10, color: Colors.black54)),
                    Text('5k', style: TextStyle(fontSize: 10, color: Colors.black54)),
                    SizedBox(height: 20), 
                  ],
                ),
              ),
              const SizedBox(width: 10),
              
              // Bars
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barWidth = constraints.maxWidth / days.length * 0.3;
                    final groupWidth = constraints.maxWidth / days.length;
                    final chartHeight = constraints.maxHeight - 20; 
                    
                    return Stack(
                      children: [
             
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
                        
                    
                        ...List.generate(days.length, (index) {
                          final userHeight = (userValues[index] / maxValue) * chartHeight;
                          final transactionHeight = (transactionValues[index] / maxValue) * chartHeight;
                          
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
                                  days[index],
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
