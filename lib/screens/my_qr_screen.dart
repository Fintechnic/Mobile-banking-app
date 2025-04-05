import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final String qrData = "https://example.com/payment"; // Dữ liệu QR để hiển thị

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Đặt màu nền của màn hình là đen
      appBar: AppBar(
        title: Text("My QR code", style: TextStyle(color: Colors.white)), // Tiêu đề của AppBar
        backgroundColor: Colors.black, // Đặt màu nền của AppBar là đen
        elevation: 0, // Loại bỏ bóng của AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Nút quay lại
          onPressed: () => Navigator.pop(context), // Quay lại màn hình trước đó
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Canh giữa các phần tử trong cột
          children: [
            Text(
              "Scan the code to transfer money to\nMr.A", 
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16), // Định dạng chữ trắng, cỡ 16
            ),
            SizedBox(height: 20), // Khoảng cách giữa văn bản và mã QR
            Container(
              padding: EdgeInsets.all(16), // Khoảng cách bên trong container
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền trắng cho container chứa mã QR
                borderRadius: BorderRadius.circular(16), // Bo tròn góc
              ),
              child: QrImageView(
                data: qrData, // Dữ liệu QR để tạo mã
                version: QrVersions.auto, // Tự động chọn phiên bản QR phù hợp
                size: 200, // Kích thước mã QR
              ),
            ),
            SizedBox(height: 20), // Khoảng cách giữa mã QR và hàng nút bấm
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Canh giữa các nút
              children: [
                IconButton(
                  icon: Icon(Icons.share, color: Colors.white, size: 30), // Nút chia sẻ
                  onPressed: () {}, // Hành động khi bấm vào nút chia sẻ (chưa xử lý)
                ),
                SizedBox(width: 40), // Khoảng cách giữa hai nút
                IconButton(
                  icon: Icon(Icons.download, color: Colors.white, size: 30), // Nút tải xuống
                  onPressed: () {}, // Hành động khi bấm vào nút tải xuống (chưa xử lý)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
