import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/qrcode_service.dart';
import 'transfer.dart';
import 'qr_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isProcessing = false;
  String? _error;
  final QRCodeService _qrService = QRCodeService();
  final ImagePicker _imagePicker = ImagePicker();
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _processQRCode(String qrData) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
      _error = null;
    });
    
    try {
      // Stop scanner while processing
      await _scannerController.stop();
      
      // Process the QR code data
      final result = await _qrService.scanQRCode(qrData);
      
      if (result != null) {
        // Navigate to transfer screen with data
        if (!mounted) return;
        
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => TransferScreen(
              receiverId: result['userId'],
              receiverPhone: result['phoneNumber'],
              fromQRScan: true,
            ),
          ),
        );
      } else {
        setState(() {
          _error = "Invalid QR code";
          _isProcessing = false;
        });
        await _scannerController.start();
      }
    } catch (e) {
      setState(() {
        _error = "Error processing QR code: $e";
        _isProcessing = false;
      });
      await _scannerController.start();
    }
  }

  Future<void> _scanFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      
      if (pickedFile != null) {
        // In a real app, we would scan the QR code from the image
        // For now, just simulate a scan
        _processQRCode("encrypted_data_placeholder"); 
      }
    } catch (e) {
      setState(() {
        _error = "Error selecting image: $e";
      });
    }
  }

  void _showMyQRCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRCodeScreen()),
    );
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
          // Real camera scanner
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _processQRCode(barcode.rawValue!);
                  return;
                }
              }
            },
          ),

          // Scanner overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Top bar with back button and QR generation button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                  // QR Generation button
                  ElevatedButton.icon(
                    onPressed: _showMyQRCode,
                    icon: const Icon(Icons.qr_code, size: 18),
                    label: const Text('My QR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Error message if any
          if (_error != null)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Loading indicator when processing
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // Instruction text
          const Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Move the camera to the QR code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                Text(
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

          // Bottom option
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton.icon(
                onPressed: _scanFromGallery,
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
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
