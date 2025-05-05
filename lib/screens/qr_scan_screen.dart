import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lấy danh sách camera có sẵn trên thiết bị
  final cameras = await availableCameras();
  // Sử dụng camera sau mặc định
  final firstCamera = cameras.first;
  
  runApp(QRScannerApp(camera: firstCamera));
}

class QRScannerApp extends StatelessWidget {
  final CameraDescription camera;
  
  const QRScannerApp({Key? key, required this.camera}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Cài đặt chế độ toàn màn hình và chiều dọc
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    
    return MaterialApp(
      theme: ThemeData.dark(),
      home: QRScannerScreen(camera: camera),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  final CameraDescription camera;
  
  const QRScannerScreen({Key? key, required this.camera}) : super(key: key);
  
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  
  @override
  void initState(dynamic ResolutionPreset) {
    super.initState();
    // Khởi tạo bộ điều khiển camera
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    
    // Khởi tạo controller camera
    _initializeControllerFuture = _controller.initialize();
  }
  
  @override
  void dispose() {
    // Giải phóng tài nguyên camera khi không sử dụng
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Camera view - Hiển thị màn hình camera
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CameraPreview(_controller),
                ),
                
                // Top bar with back button - Thanh trên cùng với nút quay lại
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Scan QR code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Main QR frame - Khung quét QR chính
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // QR scanning frame - Khung quét QR
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green.shade300, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Instruction text - Hướng dẫn quét
                      const Text(
                        'Move the camera to the QR code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Scan instruction - Hướng dẫn cách quét
                      const Text(
                        'to scan it',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bottom option - Tùy chọn phía dưới
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextButton.icon(
                      onPressed: () {
                        // Xử lý mở thư viện ảnh
                      },
                      icon: const Icon(
                        Icons.photo_library_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        'Select from photo library',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Hiển thị màn hình loading khi camera đang khởi tạo
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

CameraPreview(controller) {
}