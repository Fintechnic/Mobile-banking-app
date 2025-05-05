import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: const TransactionDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TransactionDashboard extends StatelessWidget {
  const TransactionDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Transaction Management',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildYearSelector(),
              const SizedBox(height: 20),
              _buildDonutChart(),
              const SizedBox(height: 15),
              _buildCategoryLegend(),
              const SizedBox(height: 20),
              _buildReportHeader(),
              const SizedBox(height: 15),
              _buildBarLegend(),
              const SizedBox(height: 15),
              _buildBarChart(),
              const SizedBox(height: 20),
              _buildUserSummary(),
              const SizedBox(height: 20),
              _buildUserTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Colors.white),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Search',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.white),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.grey),
            onPressed: () {},
          ),
          const Expanded(
            child: Text(
              '2025',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart() {
    return SizedBox(
      height: 160,
      width: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(160, 160),
            painter: DonutChartPainter(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '162387',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Users',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(Colors.blue, 'Banking', '20k'),
          _buildLegendItem(Colors.orange, 'Trans', '36K'),
          _buildLegendItem(Colors.green, 'Bills', '32k'),
          _buildLegendItem(Colors.amber, 'Top up', '74K'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String title, String value) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$title $value',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildReportHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Users Report',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Row(
            children: [
              Icon(Icons.chevron_left, size: 18, color: Colors.grey),
              const SizedBox(width: 4),
              const Text(
                'Week',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 18, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'User',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 20),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Transaction',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
Widget _buildBarChart() {
  // Cập nhật dữ liệu biểu đồ dựa trên hình ảnh được cung cấp
  final chartData = [
    {'day': 'Mo', 'user': 16000, 'transaction': 10000},
    {'day': 'Tu', 'user': 18000, 'transaction': 16000},
    {'day': 'We', 'user': 15000, 'transaction': 11000},
    {'day': 'Th', 'user': 17000, 'transaction': 10000},
    {'day': 'Fr', 'user': 20000, 'transaction': 14000},
    {'day': 'Sa', 'user': 20000, 'transaction': 10000},
  ];

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    height: 220,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //  labels
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('20k', style: TextStyle(fontSize: 10, color: Colors.grey)),
            SizedBox(height: 10),
            Text('15k', style: TextStyle(fontSize: 10, color: Colors.grey)),
            SizedBox(height: 10),
            Text('10k', style: TextStyle(fontSize: 10, color: Colors.grey)),
            SizedBox(height: 10),
            Text('5k', style: TextStyle(fontSize: 10, color: Colors.grey)),
            SizedBox(height: 30), // Thêm khoảng trống phía dưới cho nhãn ngày
          ],
        ),
        const SizedBox(width: 10),
        // Biểu đồ thực tế
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: chartData.map((data) {
              // Tính toán chiều cao tỷ lệ (chiều cao tối đa cho 20k)
              double userBarHeight = (data['user'] as num).toDouble() / 20000 * 150;
              double transactionBarHeight = (data['transaction'] as num).toDouble() / 20000 * 150;
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      // Thanh User (màu amber/vàng)
                      Container(
                        width: 12,
                        height: userBarHeight,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        margin: const EdgeInsets.only(right: 2),
                      ),
                      // Thanh Transaction (màu tím)
                      Container(
                        width: 12,
                        height: transactionBarHeight,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        margin: const EdgeInsets.only(left: 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Nhãn ngày
                  Text(
                    data['day'] as String,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildUserSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '14,254',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Users this week',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: const [
                    Text(
                      '+1.5%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_upward,
                      size: 12,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Small line chart
          SizedBox(
            height: 20,
            child: CustomPaint(
              size: const Size(double.infinity, 20),
              painter: LineChartPainter(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserTransactions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // User Transactions Header
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // User Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/40'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // User name and transaction text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Amanda',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'User\'s transaction',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Transaction metrics - First Row
          Row(
            children: [
              // New Top-up
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '560',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'New Top-up',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Text(
                            '+4.8%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                            ),
                          ),
                          Icon(
                            Icons.arrow_upward,
                            size: 10,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Total size
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '102,990',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Total size',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Text(
                            '+0.5%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                            ),
                          ),
                          Icon(
                            Icons.arrow_upward,
                            size: 10,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Second row of metrics
          Row(
            children: [
              // Total Paid Out
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '30,980 VND',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Total Paid Out',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Text(
                            '-2.5%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                            ),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            size: 10,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // New Payment
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '230',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'New Payment',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Text(
                            '-5%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                            ),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            size: 10,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Transactions List - First item with green background
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - Title and date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment from #10321',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mar 21, 2025, 3:30pm',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                // Right side - Amount with Completed tag
                const Text(
                  '+ 250,000 VND',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          
          _buildTransactionItem(
            title: 'Process Refund #00910',
            date: 'Mar 21, 2025, 3:30pm',
            amount: '-16,500 VND',
            status: 'Completed',
            isPositive: false,
          ),
          
          _buildTransactionItem(
            title: 'Pay, Pending #087651',
            date: 'Mar 21, 2025, 3:30pm',
            amount: '3 items',
            status: 'Declined',
            isPositive: false,
            showAmountAsText: true,
          ),
          
          _buildTransactionItem(
            title: 'Payment From #023328',
            date: 'Mar 21, 2025, 3:30pm',
            amount: '+ 250,000 VND',
            status: 'Completed',
            isPositive: true,
          ),
          
          _buildTransactionItem(
            title: 'Pay, Pending #087651',
            date: 'Mar 21, 2025, 3:30pm',
            amount: '+ 250,000 VND',
            status: 'Declined',
            isPositive: true,
          ),
          
          // Pagination indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '1-10 of 195 items',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.grey),
                  onPressed: () {},
                  iconSize: 20,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.grey),
                  onPressed: () {},
                  iconSize: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransactionItem({
    required String title,
    required String date,
    required String amount,
    required String status,
    required bool isPositive,
    bool showAmountAsText = false,
  }) {
    Color statusColor;
    if (status == 'Completed') {
      statusColor = Colors.green;
    } else if (status == 'Declined') {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.amber;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Title and date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          // Right side - Amount and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              showAmountAsText
                ? Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text(
                    amount,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    paint.color = Colors.grey.withOpacity(0.1);
    canvas.drawCircle(center, radius, paint);

    // Draw blue segment
    paint.color = Colors.blue;
    canvas.drawArc(rect, -1.57, 0.5 * 3.14159, false, paint);
    
    // Draw orange segment
    paint.color = Colors.orange;
    canvas.drawArc(rect, -1.57 + 0.5 * 3.14159, 0.6 * 3.14159, false, paint);
    
    // Draw green segment
    paint.color = Colors.green;
    canvas.drawArc(rect, -1.57 + 1.1 * 3.14159, 0.3 * 3.14159, false, paint);
    
    // Draw amber segment
    paint.color = Colors.amber;
    canvas.drawArc(rect, -1.57 + 1.4 * 3.14159, 0.6 * 3.14159, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Points for the line chart (simplified representation of growth trend)
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.45, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.5),
      Offset(size.width * 0.9, size.height * 0.3),
      Offset(size.width, size.height * 0.2),
    ];

    // Create path from points
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    // Draw the line
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}