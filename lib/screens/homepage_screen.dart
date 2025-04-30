import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
    
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String _balance = '0';
  String _paylaterAmount = '0';
  List<QuickAccessItem> _quickAccessItems = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      // Giả định rằng AuthProvider có phương thức để lấy dữ liệu tài khoản
      final userData = await authProvider.getUserData();
      
      // Cập nhật state với dữ liệu từ API
      setState(() {
        _balance = userData['balance'] ?? '1.000.000 VND';
        _paylaterAmount = userData['paylater'] ?? '500.000 VND';
        _isLoading = false;
        
        // Khởi tạo danh sách các mục Quick Access
        _quickAccessItems = [
          QuickAccessItem(type: "chat", label: "Top-up", isMultiLine: false),
          QuickAccessItem(type: "transfer", label: "Transfer", isMultiLine: false),
          QuickAccessItem(type: "ticket", label: "Ticket", isMultiLine: false),
          QuickAccessItem(type: "piggy", label: "Saving\nWallet", isMultiLine: true),
          QuickAccessItem(type: "data", label: "Datapack", isMultiLine: false),
          QuickAccessItem(type: "wallet", label: "Paylater", isMultiLine: false),
          QuickAccessItem(type: "bill", label: "Bill\nPayment", isMultiLine: true),
          QuickAccessItem(type: "loan", label: "Loan\nPayment", isMultiLine: true),
        ];
      });
    } catch (e) {
      // Nếu có lỗi khi call API, hiển thị dữ liệu mẫu
      setState(() {
        _balance = '1.000.000 VND';
        _paylaterAmount = '500.000 VND';
        _isLoading = false;
        
        // Khởi tạo danh sách các mục Quick Access
        _quickAccessItems = [
          QuickAccessItem(type: "chat", label: "Top-up", isMultiLine: false),
          QuickAccessItem(type: "transfer", label: "Transfer", isMultiLine: false),
          QuickAccessItem(type: "ticket", label: "Ticket", isMultiLine: false),
          QuickAccessItem(type: "piggy", label: "Saving\nWallet", isMultiLine: true),
          QuickAccessItem(type: "data", label: "Datapack", isMultiLine: false),
          QuickAccessItem(type: "wallet", label: "Paylater", isMultiLine: false),
          QuickAccessItem(type: "bill", label: "Bill\nPayment", isMultiLine: true),
          QuickAccessItem(type: "loan", label: "Loan\nPayment", isMultiLine: true),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(authProvider),
          _buildQuickAccess(),
          _buildServiceGrid(),
          _buildInfoPromo(),
          const Spacer(),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(AuthProvider authProvider) {
    // Lấy tên người dùng từ AuthProvider
    final username = authProvider.userData?['username'] ?? 'Mr.A';
    
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4, 0.7],
          colors: [
            Color(0xFFB0D1F5), // Light blue at top
            Color(0xFF8BB8EE), // Medium blue in middle
            Color(0xFF1A5FA3), // Dark blue at bottom
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Hiển thị hộp thoại xác nhận đăng xuất
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Đăng xuất'),
                          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                authProvider.logout();
                                Navigator.pushReplacement(
                                  context, 
                                  MaterialPageRoute(builder: (_) => const LoginScreen())
                                );
                              },
                              child: const Text('Đăng xuất'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Xử lý khi nhấn vào biểu tượng thông báo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không có thông báo mới')),
                  );
                },
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // MY BALANCE Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MY BALANCE',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _balance,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Vertical Divider
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
                // PAYLATER Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'PAYLATER',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _paylaterAmount,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Xử lý khi nhấn vào nút "xem thêm"
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang tải thêm dịch vụ...')),
                  );
                },
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // First row of quick access items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _quickAccessItems.sublist(0, 4).map((item) => 
              _buildQuickAccessItem(
                _buildCustomIcon(item.type, Icons.help_outline),
                item.label,
                item.isMultiLine,
              )
            ).toList(),
          ),
          const SizedBox(height: 20),
          // Second row of quick access items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _quickAccessItems.sublist(4, 8).map((item) => 
              _buildQuickAccessItem(
                _buildCustomIcon(item.type, Icons.help_outline),
                item.label,
                item.isMultiLine,
              )
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomIcon(String type, IconData fallbackIcon) {
    switch (type) {
      case "chat":
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              color: Colors.blue.shade700,
              size: 24,
            ),
            Positioned(
              bottom: 7,
              child: Icon(
                Icons.attach_money,
                color: Colors.blue.shade700,
                size: 12,
              ),
            ),
          ],
        );
      case "transfer":
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.blue.shade700,
              size: 18,
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.blue.shade700,
              size: 18,
            ),
          ],
        );
      case "ticket":
        return CustomPaint(
          size: const Size(24, 24),
          painter: TicketPainter(Colors.blue.shade700),
        );
      case "piggy":
        return Icon(
          Icons.savings_outlined,
          color: Colors.blue.shade700,
          size: 24,
        );
      case "data":
        return CustomPaint(
          size: const Size(24, 24),
          painter: DatapackPainter(Colors.blue.shade700),
        );
      case "wallet":
        return Icon(
          Icons.account_balance_wallet_outlined,
          color: Colors.blue.shade700,
          size: 24,
        );
      case "bill":
        return Icon(
          Icons.receipt_outlined,
          color: Colors.blue.shade700,
          size: 24,
        );
      case "loan":
        return CustomPaint(
          size: const Size(24, 24),
          painter: CoinStackPainter(Colors.blue.shade700),
        );
      default:
        return Icon(
          fallbackIcon,
          color: Colors.blue.shade700,
          size: 24,
        );
    }
  }

  Widget _buildQuickAccessItem(Widget icon, String label, bool isMultiLine) {
    return GestureDetector(
      onTap: () {
        // Xử lý khi nhấn vào các mục Quick Access
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bạn đã chọn: $label')),
        );
      },
      child: SizedBox(
        width: 70, // Fixed width for all items
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(height: 5),
            Container(
              height: isMultiLine ? 32 : 16, // Fixed height based on number of lines
              alignment: Alignment.center,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white,
      child: const SizedBox.shrink(), // Removed as we merged with Quick Access
    );
  }

  Widget _buildInfoPromo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Infor and promo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Thêm FutureBuilder để hiển thị thông tin khuyến mãi từ API
          FutureBuilder(
            future: _fetchPromos(), // Giả sử có hàm fetch promos từ API
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Không thể tải thông tin khuyến mãi'));
              } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Không có khuyến mãi hiện tại'),
                );
              } else {
                // Hiển thị thông tin khuyến mãi nếu có
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Giảm 50% phí chuyển tiền đến hết 30/04/2025'),
                );
              }
            },
          ),
        ],
      ),
    );
  }


  Future<List<Map<String, dynamic>>> _fetchPromos() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {'title': 'Giảm 50% phí chuyển tiền', 'expiry': '30/04/2025'},
    ];
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', true),
          _buildNavItem(Icons.history, 'History', false),
          _buildCircleNavItem(Icons.qr_code_scanner, 'Account & Card'),
          _buildNavItem(Icons.credit_card, 'Cards', false),
          _buildNavItem(Icons.settings, 'Setting', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chuyển đến màn hình: $label')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleNavItem(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Xử lý khi nhấn vào QR code button
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mở máy quét QR')),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
            ),
          ),
          const Text(
            'Account & Card',
            style: TextStyle(
              fontSize: 10,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}


class QuickAccessItem {
  final String type;
  final String label;
  final bool isMultiLine;

  QuickAccessItem({
    required this.type,
    required this.label,
    required this.isMultiLine,
  });
}


class TicketPainter extends CustomPainter {
  final Color color;
  TicketPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(2, 8);
    path.lineTo(22, 8);
    path.lineTo(22, 19);
    path.lineTo(2, 19);
    path.close();


    path.moveTo(2, 13);
    path.lineTo(22, 13);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class DatapackPainter extends CustomPainter {
  final Color color;
  DatapackPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

   
    final path = Path();
    path.moveTo(4, 6);
    path.lineTo(20, 6);
    path.lineTo(20, 16);
    path.lineTo(4, 16);
    path.close();

    path.moveTo(8, 16);
    path.lineTo(8, 19);
    path.lineTo(16, 19);
    path.lineTo(16, 16);

    canvas.drawPath(path, paint);


    final screenPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(8, 10),
      Offset(16, 10),
      screenPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class CoinStackPainter extends CustomPainter {
  final Color color;
  CoinStackPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(12, 8), width: 16, height: 6),
      paint,
    );
    
    canvas.drawOval(
      Rect.fromCenter(center: Offset(12, 12), width: 16, height: 6),
      paint,
    );
    
    canvas.drawOval(
      Rect.fromCenter(center: Offset(12, 16), width: 16, height: 6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
