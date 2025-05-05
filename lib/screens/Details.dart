import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CustomerDetailsScreen(),
    );
  }
}

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Row(
            children: [
              const SizedBox(width: 10),
              Icon(Icons.search, color: Colors.grey[600]),
              const SizedBox(width: 10),
              Text('Search', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            ],
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần hồ sơ người dùng
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Amanda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Phần chi tiết khách hàng
              Row(
                children: [
                  const Text(
                    'CUSTOMER DETAILS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.blue,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Top-up',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.green,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Saving',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              // Dropdown thời gian
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'In This Year',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.keyboard_arrow_down, size: 20),
                ],
              ),
              
              const SizedBox(height: 5),
              
              // Tab giao dịch
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Transaction',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Biểu đồ
              Container(
                height: 200,
                child: CustomBarChart(),
              ),
              
              const SizedBox(height: 20),
              
              // Các thẻ thông tin tài chính
              Row(
                children: [
                  Expanded(
                    child: FinancialMetricCard(
                      amount: '60.726 VND',
                      description: 'Payment in this Period',
                      percentage: '+2.5%',
                      isPositive: true,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: FinancialMetricCard(
                      amount: '30.966 VND',
                      description: 'Expense in this Period',
                      percentage: '+2.5%',
                      isPositive: true,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 15),
              
              Row(
                children: [
                  Expanded(
                    child: FinancialMetricCard(
                      amount: '28.019 VND',
                      description: 'Total Cashout in this Period',
                      percentage: '-1.5%',
                      isPositive: false,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: FinancialMetricCard(
                      amount: '30.966 VND',
                      description: 'New Income in this Period',
                      percentage: '+2.5%',
                      isPositive: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 200),
      painter: BarChartPainter(),
    );
  }
}

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    final lightBluePaint = Paint()
      ..color = Colors.blue[200]!
      ..style = PaintingStyle.fill;
    
    final gridLinePaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    // Vẽ đường lưới
    for (int i = 0; i <= 4; i++) {
      final y = size.height - (i * size.height / 4);
      canvas.drawLine(
        Offset(30, y),
        Offset(size.width, y),
        gridLinePaint,
      );
      
      // Vẽ nhãn trục y
      textPainter.text = TextSpan(
        text: '${i * 200}',
        style: TextStyle(color: Colors.grey[600], fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - 5));
    }
    
    // Dữ liệu cột
    final barData = [
      [450.0, 200.0], // Tháng 1
      [300.0, 100.0], // Tháng 2
      [500.0, 150.0], // Tháng 3
      [400.0, 180.0], // Tháng 4
      [500.0, 120.0], // Tháng 5
      [350.0, 100.0], // Tháng 6
    ];
    
    final barWidth = 15.0;
    final chartWidth = size.width - 40;
    final spaceWidth = chartWidth / barData.length;
    final maxValue = 800.0;
    
    // Vẽ các cột
    for (int i = 0; i < barData.length; i++) {
      final x = 40 + (i * spaceWidth) + (spaceWidth / 2) - barWidth;
      final mainHeight = barData[i][0] / maxValue * size.height;
      final secHeight = barData[i][1] / maxValue * size.height;
      
      // Cột chính
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x, size.height - mainHeight, barWidth, mainHeight),
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        paint,
      );
      
      // Cột phụ
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x + barWidth + 2, size.height - secHeight, barWidth, secHeight),
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        lightBluePaint,
      );
      
      // Vẽ nhãn trục x
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
      textPainter.text = TextSpan(
        text: months[i],
        style: TextStyle(color: Colors.grey[600], fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + barWidth - 5, size.height + 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FinancialMetricCard extends StatelessWidget {
  final String amount;
  final String description;
  final String percentage;
  final bool isPositive;

  const FinancialMetricCard({
    Key? key,
    required this.amount,
    required this.description,
    required this.percentage,
    required this.isPositive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}