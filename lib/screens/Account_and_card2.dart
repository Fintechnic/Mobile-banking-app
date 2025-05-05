import 'package:flutter/material.dart';

// Lớp chính của ứng dụng
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ẩn banner debug ở góc phải
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display', // Cài đặt font chữ mặc định
      ),
      home: const AccountCardScreen(), // Màn hình chính của ứng dụng
    );
  }
}

// Màn hình hiển thị thông tin tài khoản và thẻ
class AccountCardScreen extends StatelessWidget {
  const AccountCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCE0FF), // Màu nền xanh nhạt
      appBar: AppBar(
        backgroundColor: const Color(0xFFCCE0FF), // Màu nền của thanh appbar
        elevation: 0, // Không có đổ bóng
        title: const Text(
          'Account & Cards',
          style: TextStyle(
            color: Colors.black, // Màu chữ đen
            fontWeight: FontWeight.w600, // Độ đậm của chữ
          ),
        ),
        centerTitle: true, // Căn giữa tiêu đề
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Lề trái phải 16px
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Mở rộng nội dung theo chiều ngang
            children: [
              // Tab chuyển đổi giữa Account và Card
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 16.0), // Lề trên dưới 16px
                decoration: BoxDecoration(
                  color: Colors.white, // Màu nền trắng
                  borderRadius: BorderRadius.circular(25), // Bo tròn viền 25px
                ),
                child: Row(
                  children: [
                    // Tab Account
                    Expanded(
                      child: Center(
                        child: Text(
                          'Account', // Văn bản "Account"
                          style: TextStyle(
                            color: Colors.blue[800], // Màu chữ xanh đậm
                            fontWeight: FontWeight.w500, // Độ đậm của chữ
                          ),
                        ),
                      ),
                    ),
                    // Tab Card (đang được chọn)
                    Expanded(
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 5), // Lề trái phải 5px
                        decoration: BoxDecoration(
                          color: Colors.blue[900], // Màu nền xanh đậm
                          borderRadius: BorderRadius.circular(20), // Bo tròn viền 20px
                        ),
                        child: const Center(
                          child: Text(
                            'Card', // Văn bản "Card"
                            style: TextStyle(
                              color: Colors.white, // Màu chữ trắng
                              fontWeight: FontWeight.w500, // Độ đậm của chữ
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Row để chứa hai thẻ cạnh nhau
              Row(
                children: [
                  // Thẻ Visa - Chiếm một nửa không gian
                  Expanded(
                    child: Container(
                      height: 180, // Chiều cao của thẻ
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue[900]!, Colors.blue[700]!], // Màu gradient từ xanh đậm sang xanh nhạt hơn
                        ),
                        borderRadius: BorderRadius.circular(16), // Bo tròn viền 16px
                      ),
                      padding: const EdgeInsets.all(12), // Giảm padding cho không gian hẹp hơn
                      margin: const EdgeInsets.only(right: 8), // Lề phải 8px để tạo khoảng cách giữa 2 thẻ
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Nội dung căn trái
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Phân bố không gian đều
                        children: [
                          // Tên chủ thẻ
                          const Text(
                            'Mr. A', // Tên chủ thẻ
                            style: TextStyle(
                              color: Colors.white, // Màu chữ trắng
                              fontSize: 16, // Giảm cỡ chữ
                              fontWeight: FontWeight.bold, // Chữ đậm
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Nội dung căn trái
                            children: [
                              // Loại thẻ
                              const Text(
                                'Amazon Platinum', // Loại thẻ
                                style: TextStyle(
                                  color: Colors.white70, // Màu chữ trắng mờ
                                  fontSize: 12, // Giảm cỡ chữ
                                ),
                              ),
                              const SizedBox(height: 6), // Giảm khoảng cách
                              // Số thẻ
                              const Text(
                                '4756 •••• •••• 9018', // Số thẻ 
                                style: TextStyle(
                                  color: Colors.white, // Màu chữ trắng
                                  fontSize: 14, // Giảm cỡ chữ
                                ),
                              ),
                              const SizedBox(height: 6), // Giảm khoảng cách
                              // Dòng hiển thị số dư và logo Visa
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn hai đầu
                                children: [
                                  // Số dư thẻ
                                  const Text(
                                    '30.000.000 VND', // Số dư thẻ
                                    style: TextStyle(
                                      color: Colors.white, // Màu chữ trắng
                                      fontSize: 14, // Giảm cỡ chữ
                                      fontWeight: FontWeight.bold, // Chữ đậm
                                    ),
                                  ),
                                  // Logo Visa
                                  Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/2560px-Visa_Inc._logo.svg.png',
                                    height: 20, // Giảm chiều cao
                                    width: 40, // Giảm chiều rộng
                                    color: Colors.white, // Màu trắng cho logo
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Thẻ MasterCard (màu vàng) - Chiếm một nửa không gian
                  Expanded(
                    child: Container(
                      height: 180, // Chiều cao của thẻ
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.amber[600]!, Colors.amber[300]!], // Màu gradient từ vàng đậm sang vàng nhạt hơn
                        ),
                        borderRadius: BorderRadius.circular(16), // Bo tròn viền 16px
                      ),
                      padding: const EdgeInsets.all(12), // Giảm padding cho không gian hẹp hơn
                      margin: const EdgeInsets.only(left: 8), // Lề trái 8px để tạo khoảng cách giữa 2 thẻ
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Nội dung căn trái
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Phân bố không gian đều
                        children: [
                          // Tên chủ thẻ
                          const Text(
                            'Mr. A', // Tên chủ thẻ
                            style: TextStyle(
                              color: Colors.white, // Màu chữ trắng
                              fontSize: 16, // Giảm cỡ chữ
                              fontWeight: FontWeight.bold, // Chữ đậm
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Nội dung căn trái
                            children: [
                              // Loại thẻ
                              const Text(
                                'Amazon Platinum', // Loại thẻ
                                style: TextStyle(
                                  color: Colors.white70, // Màu chữ trắng mờ
                                  fontSize: 12, // Giảm cỡ chữ
                                ),
                              ),
                              const SizedBox(height: 6), // Giảm khoảng cách
                              // Số thẻ
                              const Text(
                                '4756 •••• •••• 9018', // Số thẻ 
                                style: TextStyle(
                                  color: Colors.white, // Màu chữ trắng
                                  fontSize: 14, // Giảm cỡ chữ
                                ),
                              ),
                              const SizedBox(height: 6), // Giảm khoảng cách
                              // Dòng hiển thị số dư và logo MasterCard
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn hai đầu
                                children: [
                                  // Số dư thẻ
                                  const Text(
                                    '30.000.000 VND', // Số dư thẻ
                                    style: TextStyle(
                                      color: Colors.white, // Màu chữ trắng
                                      fontSize: 14, // Giảm cỡ chữ
                                      fontWeight: FontWeight.bold, // Chữ đậm
                                    ),
                                  ),
                                  // Logo MasterCard - Sử dụng Stack để tạo hiệu ứng hai vòng tròn chồng lên nhau
                                  Stack(
                                    alignment: Alignment.centerRight, // Căn phải
                                    children: [
                                      // Vòng tròn thứ hai
                                      Container(
                                        width: 20, // Giảm kích thước
                                        height: 20, // Giảm kích thước
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle, // Hình tròn
                                          color: Colors.white.withOpacity(0.5), // Màu trắng mờ
                                        ),
                                      ),
                                      // Vòng tròn thứ nhất (trái)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12), // Giảm khoảng cách
                                        child: Container(
                                          width: 20, // Giảm kích thước
                                          height: 20, // Giảm kích thước
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle, // Hình tròn
                                            color: Colors.white, // Màu trắng
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Nút thêm thẻ
              Container(
                height: 50, // Chiều cao 50px
                margin: const EdgeInsets.only(top: 20), // Lề trên 20px
                decoration: BoxDecoration(
                  color: Colors.blue[900], // Màu nền xanh đậm
                  borderRadius: BorderRadius.circular(25), // Bo tròn viền 25px
                ),
                child: const Center(
                  child: Text(
                    'Add card', // Văn bản thêm thẻ
                    style: TextStyle(
                      color: Colors.white, // Màu chữ trắng
                      fontWeight: FontWeight.w500, // Độ đậm của chữ
                      fontSize: 16, // Cỡ chữ 16px
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}