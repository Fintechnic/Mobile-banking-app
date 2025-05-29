import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:fintechnic/services/qrcode_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
  const QRScannerApp({super.key, required this.camera});
  @override
  Widget build(BuildContext context) {
    // Cài đặt chế độ toàn màn hình và chiều dọc
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
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
  const QRScannerScreen({super.key, required this.camera});
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  final QRCodeService _qrCodeService = QRCodeService();
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processQRCode(String? qrData) async {
    if (qrData == null || _isProcessing) return;
    
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      debugPrint("QR Code detected: $qrData");
      final result = await _qrCodeService.scanQRCodeData(qrData);
      
      if (result.containsKey("error")) {
        setState(() {
          _errorMessage = result["error"];
          _isProcessing = false;
        });
        _showErrorDialog(result["error"]);
      } else {
        // Navigate back with the result or to another page
        Navigator.pop(context, result);
      }
    } catch (e) {
      debugPrint("Error processing QR code: $e");
      setState(() {
        _errorMessage = e.toString();
        _isProcessing = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Resume scanning
              _controller.start();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // QR Scanner
          MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && !_isProcessing) {
                final qrData = barcodes.first.rawValue;
                _processQRCode(qrData);
                // Pause scanning while processing
                _controller.stop();
              }
            },
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
                    border: Border.all(
                      color: _isProcessing ? Colors.blue.shade300 : Colors.green.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 20),
                // Instruction text - Hướng dẫn quét
                Text(
                  _isProcessing 
                      ? 'Processing QR code...' 
                      : 'Move the camera to the QR code',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Error: $_errorMessage',
                    style: TextStyle(
                      color: Colors.red.shade300,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
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
                onPressed: _isProcessing ? null : () {
                  // Handle gallery picking
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
          
          // Loading indicator
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
