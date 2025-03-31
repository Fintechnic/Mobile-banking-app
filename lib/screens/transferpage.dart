import 'package:flutter/material.dart';
import 'qr_scan_screen.dart'; 

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Màu nền cho toàn bộ màn hình
      appBar: AppBar(
        title: Text("Transfer"), // Tiêu đề của AppBar
        backgroundColor: Colors.blue, // Màu nền của AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Nút quay lại
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chọn tài khoản hoặc thẻ để chuyển tiền
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: "Choose account / card",
                  items: [DropdownMenuItem(value: "Choose account / card", child: Text("Choose account / card"))],
                  onChanged: (value) {},
                ),
              ),
            ),
            SizedBox(height: 20),
            // Chọn người thụ hưởng và nút quét mã QR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Choose beneficiary", style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner, color: Colors.blue), // Nút quét mã QR
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10),
            // Danh sách người thụ hưởng 
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(0.2),
                          radius: 30,
                          child: Icon(Icons.add, color: Colors.blue), // Nút thêm người thụ hưởng
                        ),
                        SizedBox(height: 5),
                        Text("Add", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  ...List.generate(3, (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/avatar.png'),
                          radius: 30,
                        ),
                        SizedBox(height: 5),
                        Text("Users", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Form nhập thông tin chuyển khoản
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  buildTextField("Bank"), // nhập ngân hàng
                  buildTextField("Card number"), // nhập số thẻ
                  buildTextField("Name"), // nhập tên chủ thẻ
                  buildTextField("Amount"), //nhập số tiền chuyển
                  buildTextField("Content"), //nhập nội dung chuyển khoản
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      Text("Save to directory of beneficiary"), // Tuỳ chọn lưu người thụ hưởng vào danh bạ
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Nút xác nhận giao dịch
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("CONFIRM", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo một trường nhập liệu có nhãn
  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label, // Nhãn của trường nhập liệu
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
