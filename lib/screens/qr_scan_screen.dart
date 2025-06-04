import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/qrcode_service.dart';
import 'transfer.dart';
import 'qr_screen.dart';
import 'dart:convert';

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
      
      // Log the raw scanned data for debugging
      debugPrint("------ QR SCAN DEBUG ------");
      debugPrint("Raw QR data: ${qrData.length > 50 ? '${qrData.substring(0, 50)}...' : qrData}");
      
      // Try to sanitize the data if it looks like JSON
      String processedQrData = qrData;
      try {
        if (qrData.trim().startsWith('{') && qrData.trim().endsWith('}')) {
          final Map<String, dynamic> jsonData = jsonDecode(qrData);
          debugPrint("QR JSON parsed successfully: ${jsonData.keys.join(', ')}");
          
          if (jsonData.containsKey('data') && jsonData['data'] is String) {
            // This is likely our QR format, sanitize it
            debugPrint("Detected QR data in expected format: contains 'data' field");
            
            // Sanitize base64 string before proceeding
            String sanitizedBase64 = jsonData['data'];
            
            // Check if data contains problematic characters
            final bool containsUnderscore = sanitizedBase64.contains('_');
            final bool containsDash = sanitizedBase64.contains('-');
            final bool properlyPadded = sanitizedBase64.length % 4 == 0;
            
            debugPrint("Base64 stats - Length: ${sanitizedBase64.length}, " 
                "Contains '_': $containsUnderscore, "
                "Contains '-': $containsDash, "
                "Properly padded: $properlyPadded");
            
            // Fix URL-safe base64 characters
            sanitizedBase64 = sanitizedBase64.replaceAll('-', '+').replaceAll('_', '/');
            
            // Add padding if needed
            while (sanitizedBase64.length % 4 != 0) {
              sanitizedBase64 += '=';
            }
            
            // Replace with sanitized version
            jsonData['data'] = sanitizedBase64;
            processedQrData = jsonEncode(jsonData);
            
            debugPrint("Sanitized QR data: ${processedQrData.length > 50 ? '${processedQrData.substring(0, 50)}...' : processedQrData}");
          }
        }
      } catch (e) {
        debugPrint("Error pre-processing QR data: $e");
        // Continue with original data
      }
      
      // Process the QR code data
      debugPrint("Sending to QRCodeService.scanQRCode...");
      final result = await _qrService.scanQRCode(processedQrData);
      
      if (result != null) {
        // Navigate to transfer screen with data
        if (!mounted) return;
        
        debugPrint("Successfully decoded QR code, navigating to transfer screen");
        debugPrint("Receiver ID: ${result['userId']}");
        debugPrint("Receiver Phone: ${result['phoneNumber']}");
        debugPrint("------ QR SCAN SUCCESS ------");
        
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
        debugPrint("QR scan failed: Invalid QR code");
        debugPrint("------ QR SCAN FAILED ------");
        setState(() {
          _error = "Invalid QR code";
          _isProcessing = false;
        });
        _showErrorDialog("Invalid QR code");
        await _scannerController.start();
      }
    } catch (e) {
      debugPrint("QR scan error: $e");
      debugPrint("------ QR SCAN ERROR ------");
      setState(() {
        _error = "Error processing QR code: $e";
        _isProcessing = false;
      });
      _showErrorDialog("Error processing QR code: $e");
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
      _showErrorDialog("Error selecting image: $e");
    }
  }
  
  Future<void> _testQRScanning() async {
    try {
      setState(() {
        _error = null;
      });
      
      debugPrint("Starting QR test...");
      final testQRData = await _qrService.createTestQRCode();
      debugPrint("Test QR data generated: ${testQRData.substring(0, min(20, testQRData.length))}...");
      
      // Show a dialog with test options
      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Test QR Code Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose a test scenario:'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _processQRCode(testQRData);
                },
                child: const Text('Standard Base64'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                
                  // Create a data field with underscores to simulate URL-safe base64
                  final urlSafeQR = jsonEncode({
                    'data': 'SGVsbG9fV29ybGQ_IVRoaXNfaXNfdGVzdF9kYXRhX3dpdGhfdW5kZXJzY29yZXM=',
                    'sig': '12345678'
                  });
                  _processQRCode(urlSafeQR);
                },
                child: const Text('URL-safe Base64 (with _)'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Create and process unpadded base64 test
                  // We can't directly access private methods, so create the unpadded QR manually
                  final unpaddedQR = jsonEncode({
                    'data': 'SGVsbG9Xb3JsZCFUaGlzaXN0ZXN0ZGF0YXdpdGhvdXRwYWRkaW5n',
                    'sig': '12345678'
                  });
                  _processQRCode(unpaddedQR);
                },
                child: const Text('Unpadded Base64'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _error = "Error generating test QR: $e";
      });
      _showErrorDialog("Error generating test QR: $e");
    }
  }

  void _showMyQRCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRCodeScreen()),
    );
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
              _scannerController.start();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  int min(int a, int b) => a < b ? a : b;

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
                  color: Colors.red.withAlpha(204),
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

          // Bottom options
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _scanFromGallery,
                  icon: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'From gallery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton.icon(
                  onPressed: _testQRScanning,
                  icon: const Icon(
                    Icons.bug_report_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Test QR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
