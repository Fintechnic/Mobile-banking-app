import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Màu nền của màn hình chính
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Loại thanh điều hướng
        selectedItemColor: Colors.blue, // Màu của mục được chọn
        unselectedItemColor: Colors.grey, // Màu của mục không được chọn
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), // Nút Home
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"), // Nút lịch sử
          BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.amber, // Màu nền của nút QR
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.qr_code_scanner, color: Colors.white), // Nút quét QR
              ),
              label: "Scan QR"),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Account & Card"), // Nút tài khoản & thẻ
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"), // Nút cài đặt
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Thêm lề cho nội dung
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/profile.jpg'), // Ảnh đại diện
                        radius: 25,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hello", style: TextStyle(fontSize: 14, color: Colors.grey)), // Chữ chào hỏi
                          Text("Mr. A", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Tên người dùng
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.notifications, color: Colors.grey), // Nút thông báo
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue, // Màu nền của thẻ số dư
                        borderRadius: BorderRadius.circular(15), // Bo góc
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("MY BALANCE", style: TextStyle(color: Colors.white70)), // Tiêu đề số dư
                          SizedBox(height: 5),
                          Text("1.000.000 VND", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), // Giá trị số dư
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.redAccent, // Màu nền của thẻ Paylater
                        borderRadius: BorderRadius.circular(15), // Bo góc
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("PAYLATER", style: TextStyle(color: Colors.white70)), // Tiêu đề Paylater
                          SizedBox(height: 5),
                          Text("500.000 VND", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), // Giá trị Paylater
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Quick Access", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Tiêu đề truy cập nhanh
              SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Ngăn chặn cuộn trong GridView
                crossAxisCount: 4, // Số cột trong lưới
                children: [
                  QuickAccessButton(icon: Icons.send, label: "Transfer"), // chuyển khoản
                  QuickAccessButton(icon: Icons.account_balance, label: "Bank Transfer"), // chuyển khoản ngân hàng
                  QuickAccessButton(icon: Icons.insert_drive_file, label: "File"), // tài liệu
                  QuickAccessButton(icon: Icons.savings, label: "Saving"), // tiết kiệm
                  QuickAccessButton(icon: Icons.payments, label: "Paylater"), //  trả sau
                  QuickAccessButton(icon: Icons.receipt, label: "Bill Payment"), // thanh toán hóa đơn
                  QuickAccessButton(icon: Icons.monetization_on, label: "Loan Payment"), // thanh toán khoản vay
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const QuickAccessButton({Key? key, required this.icon, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white, // Màu nền nút
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 5), // Đổ bóng
            ],
          ),
          child: Icon(icon, color: Colors.blue, size: 30), // Biểu tượng nút
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)), // Nhãn nút
      ],
    );
  }
}
