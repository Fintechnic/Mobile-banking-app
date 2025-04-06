import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Widget MyApp định nghĩa cấu trúc cơ bản của ứng dụng.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp cung cấp các cấu hình cần thiết cho ứng dụng Material Design.
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt banner debug ở góc trên.
      theme: ThemeData(
        primarySwatch: Colors.blue, // Đặt màu chủ đạo của ứng dụng.
        fontFamily: 'SF Pro Display', // Đặt font chữ mặc định cho toàn ứng dụng.
      ),
      // Xác định màn hình đầu tiên khi ứng dụng bắt đầu (ở đây là màn hình QR code).
      home: const QRCodeScreen(),
    );
  }
}

// Widget QRCodeScreen là màn hình hiển thị mã QR và các thông tin liên quan.
class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222), // Màu nền tổng thể của màn hình.
      body: SafeArea(
        child: Column(
          children: [
            // Thanh điều hướng phía trên.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Icon mũi tên quay lại.
                  Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  const SizedBox(width: 16),
                  // Tiêu đề của thanh điều hướng.
                  Text(
                    'My QR code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Phần nội dung chính chứa mã QR, thông tin người nhận và các logo.
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white, // Màu nền cho khối nội dung chính.
                  borderRadius: BorderRadius.circular(12), // Bo góc cho khối nội dung.
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Phần hiển thị mã QR và thông tin người nhận.
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          // Dòng hướng dẫn người dùng quét mã.
                          Text(
                            'Scan the code to transfer money to',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Tên người nhận (ví dụ: Mr.A).
                          Text(
                            'Mr.A',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Hiển thị hình ảnh mã QR từ thư mục assets.
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/qr_code.png', // Đường dẫn đến file ảnh mã QR.
                                width: 180,
                                height: 180,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Hiển thị các logo hoặc thông tin cá nhân.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'V',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'IETOR',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'napas',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '247',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Phần dưới có hiệu ứng sóng và các biểu tượng chức năng (download, copy).
                    Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00509E),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Hiệu ứng sóng ở đầu phần dưới bằng CustomClipper.
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: ClipPath(
                              clipper: WaveClipper(),
                              child: Container(
                                height: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          
                          // Các icon chức năng đặt ở giữa phần dưới.
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon tải xuống.
                                IconButton(
                                  icon: Icon(Icons.file_download_outlined, color: Colors.white),
                                  onPressed: () {
                                    // Xử lý khi người dùng nhấn nút tải xuống.
                                  },
                                ),
                                const SizedBox(width: 32),
                                // Icon sao chép.
                                IconButton(
                                  icon: Icon(Icons.copy_outlined, color: Colors.white),
                                  onPressed: () {
                                    // Xử lý khi người dùng nhấn nút sao chép.
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16), // Khoảng cách ở dưới cùng của màn hình.
          ],
        ),
      ),
    );
  }
}

// CustomClipper để tạo hiệu ứng đường cong (sóng) cho phần trên của container phía dưới.
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Bắt đầu từ góc trên bên trái.
    path.lineTo(0, 0);
    
    // Tạo đường cong sóng thứ nhất với điểm điều khiển và điểm kết thúc.
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height / 2);
    path.quadraticBezierTo(
      firstControlPoint.dx, 
      firstControlPoint.dy, 
      firstEndPoint.dx, 
      firstEndPoint.dy,
    );
    
    // Tạo đường cong sóng thứ hai với điểm điều khiển và điểm kết thúc thứ hai.
    final secondControlPoint = Offset(size.width * 3 / 4, 0);
    final secondEndPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(
      secondControlPoint.dx, 
      secondControlPoint.dy, 
      secondEndPoint.dx, 
      secondEndPoint.dy,
    );
    
    // Nối đường về góc trên bên phải.
    path.lineTo(size.width, 0);
    // Đóng đường viền của path.
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
