import 'package:flutter/material.dart';

// Lớp chính của ứng dụng
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ẩn nhãn debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display', // Font chữ được sử dụng
      ),
      home: const AccountCardsScreen(), // Màn hình chính của ứng dụng
    );
  }
}

// Màn hình hiển thị tài khoản và thẻ
class AccountCardsScreen extends StatelessWidget {
  const AccountCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Phần đầu với nút quay lại và tiêu đề
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFD6E4FF), // Màu nền xanh nhạt
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.arrow_back_ios, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Account & Cards', // Tiêu đề "Tài khoản & Thẻ"
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Các nút tab để chuyển đổi giữa tài khoản và thẻ
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A3A7D), // Màu xanh đậm cho tab đang được chọn
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Account', // Nút "Tài khoản"
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white, // Màu trắng cho tab không được chọn
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Card', // Nút "Thẻ"
                            style: TextStyle(
                              color: Color(0xFF0A3A7D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(flex: 2, child: SizedBox()), // Khoảng trống bên phải
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            
            // Danh sách tài khoản
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 16),
                children: const [
                  // Thẻ hiển thị thông tin tài khoản 1
                  AccountCard(
                    accountName: 'Account 1',
                    accountNumber: '1950 8888 1234',
                    balance: '1,600,000 VND',
                    branch: 'Vietnam'
                  ),
                  // Thẻ hiển thị thông tin tài khoản 2
                  AccountCard(
                    accountName: 'Account 2',
                    accountNumber: '6888 1234',
                    balance: '23,000 VND',
                    branch: 'Vietnam'
                  ),
                  // Thẻ hiển thị thông tin tài khoản 3
                  AccountCard(
                    accountName: 'Account 3',
                    accountNumber: '1000 1234 2222',
                    balance: '36,000,000 VND',
                    branch: 'Vietnam'
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Nút thêm (+) ở góc dưới bên phải
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Xử lý khi nút được nhấn
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Widget tùy chỉnh hiển thị thông tin một tài khoản
class AccountCard extends StatelessWidget {
  final String accountName; // Tên tài khoản
  final String accountNumber; // Số tài khoản
  final String balance; // Số dư khả dụng
  final String branch; // Chi nhánh

  const AccountCard({
    super.key,
    required this.accountName,
    required this.accountNumber,
    required this.balance,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Khoảng cách giữa các thẻ
      padding: const EdgeInsets.all(16), // Đệm bên trong thẻ
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200), // Viền xung quanh thẻ
        borderRadius: BorderRadius.circular(8), // Bo góc thẻ
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hàng trên tên tài khoản và số tài khoản
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                accountName, // Hiển thị tên tài khoản
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                accountNumber, // Hiển thị số tài khoản
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Hàng dưới thông tin số dư và chi nhánh
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
                  const SizedBox(height: 4),
                  Text(
                    branch, // Hiển thị chi nhánh
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Text(
                balance, // Hiển thị số dư
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}