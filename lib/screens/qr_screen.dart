import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/qrcode_service.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'qr_scan_screen.dart';
import 'package:dio/dio.dart';
import '../utils/app_logger.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final QRCodeService _qrCodeService = QRCodeService();
  String? _qrCodeData;
  bool _isLoading = true;
  String? _error;
  String _userName = '';
  final _logger = AppLogger();

  @override
  void initState() {
    super.initState();
    _loadQRCode();
  }

  // Check API connection
  Future<bool> _checkApiConnection() async {
    try {
      final dio = Dio();
      // Get token directly
      final token = await _qrCodeService.getMyToken();
      
      final response = await dio.get(
        'http://${_qrCodeService.getApiHost()}:${_qrCodeService.getApiPort()}/health',
        options: Options(
          followRedirects: false,
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          validateStatus: (status) {
            return status! < 500;
          },
        )
      );
      
      _logger.i('API health check: Status ${response.statusCode}');
      
      // Consider 200, 401, 403 as "connected" since server is responding
      return response.statusCode == 200 || 
             response.statusCode == 401 || 
             response.statusCode == 403;
    } catch (e) {
      _logger.e('API connection error: $e');
      return false;
    }
  }

  Future<void> _loadQRCode() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Get the auth provider before the async operation
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      // First check API connection
      final apiConnected = await _checkApiConnection();
      if (!apiConnected) {
        if (!mounted) return;
        setState(() {
          _error = 'Cannot connect to the server. Please check your internet connection.';
          _isLoading = false;
        });
        return;
      }

      final qrCodeData = await _qrCodeService.getMyQRCode();
      
      if (!mounted) return; // Check if widget is still mounted
      
      setState(() {
        _qrCodeData = qrCodeData;
        _userName = auth.username ?? 'User';
        _isLoading = false;
        
        // If qrCodeData is null but there's no error, set a more helpful error message
        if (qrCodeData == null && _error == null) {
          _error = 'Unable to load QR code data from the server. The response format may be incorrect.';
        }
      });
    } catch (e) {
      if (!mounted) return; // Check if widget is still mounted
      
      setState(() {
        _error = 'Failed to load QR code: $e';
        _isLoading = false;
      });
    }
  }

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
                    child: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 20),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  const Text(
                    'Scan the code to transfer money to',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userName,
                    style: const TextStyle(
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
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : _error != null
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Text(
                                                _error!,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: _loadQRCode,
                                              child: const Text('Retry'),
                                            ),
                                          ],
                                        )
                                      : _qrCodeData != null
                                          ? QrImageView(
                                              data: _qrCodeData!,
                                              version: QrVersions.auto,
                                              size: 180,
                                              backgroundColor: Colors.white,
                                              padding: const EdgeInsets.all(10),
                                            )
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'No QR Code Available',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(height: 10),
                                                ElevatedButton(
                                                  onPressed: _loadQRCode,
                                                  child: const Text('Retry'),
                                                ),
                                              ],
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
                                  color: Color(
                                      0xFF00509E), // Màu xanh đậm cho phần dưới
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
                                    icon: const Icon(
                                        Icons.refresh,
                                        color: Colors.white),
                                    onPressed: _loadQRCode,
                                  ),
                                  const SizedBox(width: 32),
                                  IconButton(
                                    icon: const Icon(Icons.qr_code_scanner,
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const QRScannerScreen(),
                                        ),
                                      );
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

    path.quadraticBezierTo(size.width * 0.75, size.height * 0.15,
        size.width * 0.5, size.height * 0.3);

    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.45, 0, size.height * 0.25);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
