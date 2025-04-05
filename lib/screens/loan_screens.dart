import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Lớp MyApp - Khởi tạo ứng dụng Flutter
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan App',
      debugShowCheckedModeBanner: false, // Tắt banner "Debug"
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoanScreen(), // Màn hình khởi đầu là LoanScreen
    );
  }
}

// Lớp LoanScreen - Màn hình chính hiển thị thông tin vay
class LoanScreen extends StatelessWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea( // SafeArea giúp tránh bị cắt bởi notch, camera trước hoặc thanh điều hướng
          child: Stack( // Stack cho phép xếp chồng các widget lên nhau
            children: [
              // PHẦN 1: NỀN CÓ ĐƯỜNG CONG
              Column(
                children: [
                  // Phần nền xanh dương phía trên có đường cong
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient( // Gradient màu từ xanh nhạt đến xanh đậm hơn
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
                      ),
                      borderRadius: BorderRadius.only( // Bo tròn phần dưới
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  const Spacer(), // Khoảng trống giữa phần trên và dưới
                  // Phần nền xanh đậm phía dưới có đường cong
                  Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D47A1), // Màu xanh dương đậm
                      borderRadius: BorderRadius.only( // Bo tròn phần trên
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
              
              // PHẦN 2: NỘI DUNG CHÍNH
              Column(
                children: [
                  // PHẦN 2.1: THANH TIÊU ĐỀ
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        IconButton( // Nút quay lại
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () {},
                        ),
                        const Text( // Tiêu đề "Loans"
                          'Loans',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(), // Đẩy các nút bên phải ra xa
                        IconButton( // Nút sao chép
                          icon: const Icon(Icons.copy_all_rounded, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton( // Nút điện thoại
                          icon: const Icon(Icons.phone, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  
                  // PHẦN 2.2: THANH TÌM KIẾM
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8), // Bo tròn góc
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'PTF, SHB, JACCS, ACS...', // Gợi ý tìm kiếm
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20), // Biểu tượng kính lúp
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none, // Không có viền
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          isDense: true, // Làm cho thanh tìm kiếm gọn hơn
                        ),
                      ),
                    ),
                  ),
                  
                  // PHẦN 2.3: NỘI DUNG CÓ THỂ CUỘN
                  Expanded(
                    child: SingleChildScrollView( // Cho phép cuộn nếu nội dung quá dài
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            
                            // PHẦN 2.3.1: TIÊU ĐỀ ĐỐI TÁC THANH TOÁN
                            const Text(
                              'Select payment partner',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // PHẦN 2.3.2: LƯỚI CÁC ĐỐI TÁC THANH TOÁN
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [ // Đổ bóng nhẹ
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: GridView.builder(
                                shrinkWrap: true, // Giúp grid view thu gọn theo nội dung
                                physics: const NeverScrollableScrollPhysics(), // Không cho phép cuộn trong grid
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, // 4 cột
                                  childAspectRatio: 0.8, // Tỷ lệ chiều cao/rộng
                                  crossAxisSpacing: 8, // Khoảng cách ngang
                                  mainAxisSpacing: 16, // Khoảng cách dọc
                                ),
                                itemCount: 8, // 8 đối tác (2 hàng x 4 cột)
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container( // Hình tròn đại diện cho đối tác
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text( // Tên đối tác
                                        'NAME',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // PHẦN 2.3.3: TIÊU ĐỀ HƯỚNG DẪN
                            const Text(
                              'Instruction manual',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // PHẦN 2.3.4: CÁC MỤC HƯỚNG DẪN
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [ // Đổ bóng nhẹ
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Căn đều các mục
                                children: [
                                  _buildInstructionItem( // Mục 1: tài chính
                                    icon: Icons.menu_book_outlined,
                                    label: 'Financial\nliteracy',
                                  ),
                                  _buildInstructionItem( // Mục 2: Hướng dẫn thanh toán
                                    icon: Icons.monetization_on_outlined,
                                    label: 'Payment\nguide',
                                  ),
                                  _buildInstructionItem( // Mục 3: Câu hỏi thường gặp
                                    icon: Icons.person_outline,
                                    label: 'FAQs',
                                  ),
                                  _buildInstructionItem( // Mục 4: Phản hồi
                                    icon: Icons.email_outlined,
                                    label: 'Feedback',
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 40), // Khoảng trống dưới cùng
                          ],
                        ),
                      ),
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
  
  // Hàm tạo mục hướng dẫn với biểu tượng và nhãn
  Widget _buildInstructionItem({
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1976D2), size: 24), // Biểu tượng
        const SizedBox(height: 8),
        Text( // Nhãn
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1976D2),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
