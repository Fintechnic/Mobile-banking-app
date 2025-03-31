import 'package:flutter/material.dart';


// Tạo trang "Bill payment"
class TrangThanhToanHoaDon extends StatelessWidget {
  const TrangThanhToanHoaDon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền trắng
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back, // Mũi tên quay lại
          color: Colors.white, // Màu trắng
        ),
        title: const Text(
          'Bill payment', // Tiêu đề
          style: TextStyle(
            color: Colors.white, // Màu chữ trắng
            fontWeight: FontWeight.bold, // Chữ in đậm
            fontSize: 20, // Kích thước chữ
          ),
        ),
        backgroundColor: Colors.transparent, // Thanh AppBar trong suốt
        elevation: 0, // Không có bóng
      ),
      extendBodyBehindAppBar: true, // Nội dung hiển thị phía sau AppBar
      body: Container(
        width: double.infinity, // Chiều rộng đầy màn hình
        height: double.infinity, // Chiều cao đầy màn hình
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, // Bắt đầu từ góc trên bên trái
            end: Alignment.bottomRight, // Kết thúc ở góc dưới bên phải
            colors: [
              Color(0xFF1A3C6D), // Màu xanh đậm ở trên
              Color(0xFFB0C7E6), // Màu xanh nhạt ở dưới
            ],
          ),
        ),
        child: SingleChildScrollView(
          // Thêm cuộn để tránh lỗi tràn màn hình
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
            children: [
              const SizedBox(
                height: 100,
              ), // Khoảng cách phía trên để tránh AppBar
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ), // Lề trái phải 16
                child: Text(
                  'Add new', // Chữ "Add new"
                  style: TextStyle(
                    fontSize: 18, // Kích thước chữ 18
                    fontWeight: FontWeight.bold, // Chữ in đậm
                    color: Colors.black, // Màu chữ đen
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ), // Khoảng cách 16 giữa tiêu đề và nội dung
              // Grid của các hóa đơn
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    BillOption(
                      icon: Icons.electrical_services,
                      label: 'Electricity',
                    ),
                    BillOption(icon: Icons.water_drop, label: 'Water'),
                    BillOption(icon: Icons.tv, label: 'Cable TV'),
                    BillOption(
                      icon: Icons.phone_android,
                      label: 'Mobile phone',
                    ),
                    BillOption(icon: Icons.school, label: 'Tuition'),
                    BillOption(icon: Icons.wifi, label: 'Internet'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Phần "My bills"
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'My bills',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B9DE8), // Màu xanh nhạt
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Placeholder cho danh sách hóa đơn
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5), // Màu xám nhạt
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ), // Thêm khoảng cách để tránh bị cắt nội dung cuối
            ],
          ),
        ),
      ),
    );
  }
}

// Widget tùy chỉnh cho các tùy chọn hóa đơn
class BillOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const BillOption({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 30,
            color: const Color(0xFF1A3C6D), // Màu xanh đậm
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}
