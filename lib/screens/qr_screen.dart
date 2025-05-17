import 'package:flutter/material.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300, 
      body: SafeArea(
        child: Column(
          children: [
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Go back to previous screen
                    },
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  // Tiêu đề của thanh điều hướng.
                  const Text(
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
            
            // Thêm text hướng dẫn bên ngoài card
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Text(
                    'Scan the code to transfer money to',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Mr.A',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
         
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    // Container trắng chứa QR code
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Hiển thị hình ảnh mã QR
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Center(
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1),
                                ),
                                child: const Center(
                                  child: Text(
                                    'QR Code Placeholder',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // VieTQR logo
                              Row(
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
                                ],
                              ),
                              SizedBox(width: 8),
                              // napas247 logo
                              Row(
                                children: [
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
                         
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                    
               
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 100,
                        child: Stack(
                          children: [
                            // Wave shape
                            ClipPath(
                              clipper: BottomWaveClipper(),
                              child: Container(
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00509E), // Màu xanh đậm cho phần dưới
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            
                
                            Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                           
                                  IconButton(
                                    icon: const Icon(Icons.file_download_outlined, color: Colors.white),
                                    onPressed: () {
                                     
                                    },
                                  ),
                                  const SizedBox(width: 32),
                              
                                  IconButton(
                                    icon: const Icon(Icons.copy_outlined, color: Colors.white),
                                    onPressed: () {
                                      
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper để tạo hình dạng sóng cho phần dưới
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    path.lineTo(0, size.height);
    
    path.lineTo(size.width, size.height);
    
    path.lineTo(size.width, size.height * 0.5);
    
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.15, 
      size.width * 0.5, size.height * 0.3
    );
    
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.45, 
      0, size.height * 0.25
    );
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
