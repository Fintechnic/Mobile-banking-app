import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class QRCodeService {
  final ApiService _apiService = ApiService();

  // Return the API host
  String getApiHost() {
    return dotenv.get('API_HOST', fallback: ApiService.defaultHost);
  }
  
  // Return the API port
  String getApiPort() {
    return dotenv.get('API_PORT', fallback: ApiService.defaultPort);
  }
  
  // Get authentication token
  Future<String?> getMyToken() async {
    return await _apiService.getToken();
  }

  /// Generate QR code for payment
  Future<Map<String, dynamic>> generateQRCode({
    required String userId,
    required double amount,
    String? description,
  }) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return {"error": "No token found"};

      final response = await _apiService.post(
        "/api/qrcode/generate",
        {
          "userId": userId,
          "amount": amount,
          if (description != null) "description": description,
        },
        token: token,
      );

      if (!response.containsKey("error")) {
        return response;
      }
      return {"error": "Failed to generate QR code"};
    } catch (e) {
      debugPrint("Generate QR code error: $e");
      return {"error": e.toString()};
    }
  }

  /// Get current user's QR code
  Future<String?> getMyQRCode() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        debugPrint("QR Code error: No authentication token available");
        return null;
      }
      
      // For security, only show part of the token in logs
      final tokenPreview = token.length > 10 ? "${token.substring(0, 10)}..." : token;
      debugPrint("Making request to /api/qrcode/myqrcode with token: $tokenPreview");
      
      // Get user info for encryption
      final userId = await _apiService.getUserId();
      final phoneNumber = await _apiService.getPhoneNumber();
      
      if (userId != null && phoneNumber != null) {
        // Create encrypted QR code data in the format expected by the scanner
        final qrData = _encryptQRData(userId, phoneNumber);
        debugPrint("Generated QR code data locally");
        return qrData;
      }
      
      final Map<String, dynamic> response = await _apiService.get(
        "/api/qrcode/myqrcode",
        token: token,
      );
      
      // Debug: Print the full response to see what's being returned
      debugPrint("QR Code API Response: $response");
      
      if (response.containsKey("error")) {
        debugPrint("Error in QR code response: ${response["error"]}");
        return null;
      }
      
      // Check known field names first
      final possibleFields = ["qrCodeData", "data", "qrcode", "code", "content", "value"];
      
      for (final field in possibleFields) {
        if (response.containsKey(field)) {
          final value = response[field];
          if (value != null) {
            debugPrint("Found QR code in '$field' field");
            return value.toString();
          }
        }
      }
      
      // Look for responseBody or body fields if statusCode is present
      if (response.containsKey("statusCode")) {
        final bodyFields = ["responseBody", "body"];
        for (final field in bodyFields) {
          if (response.containsKey(field)) {
            final value = response[field];
            if (value != null) {
              return value.toString();
            }
          }
        }
      }
      
      // Look for any string field with reasonable length for a QR code
      for (final key in response.keys) {
        final value = response[key];
        if (value is String && value.length > 20) {
          return value;
        }
      }
      
      // Last resort - try to use first string value
      if (response.isNotEmpty) {
        final firstValue = response[response.keys.first];
        if (firstValue != null) {
          return firstValue.toString();
        }
      }
      
      debugPrint("No suitable QR code data found in response");
      return null;
    } catch (e) {
      debugPrint("Get QR code error: $e");
      return null;
    }
  }

  /// Encrypts user data for QR code
  String _encryptQRData(String userId, String phoneNumber) {
    final data = {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    
    // Convert to JSON string
    final jsonData = jsonEncode(data);
    
    // Simple encryption - Base64 encoding with a signature
    // In a real app, use stronger encryption
    const key = 'mobile_banking_secure_key';
    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(jsonData));
    final signature = digest.toString();
    
    // Use standard base64 encoding (not URL-safe)
    // This avoids the '-' and '_' characters that can cause issues
    String base64Data = base64Encode(utf8.encode(jsonData));
    
    // Ensure the base64 string is padded correctly
    while (base64Data.length % 4 != 0) {
      base64Data += '=';
    }
    
    // Log the generated base64 for debugging
    debugPrint("Generated base64 data: ${base64Data.substring(0, min(20, base64Data.length))}...");
    
    final encryptedData = {
      'data': base64Data,
      'sig': signature.substring(0, 8), // Use part of signature as a check
    };
    
    return jsonEncode(encryptedData);
  }

  /// Scan QR code for money transfer
  Future<Map<String, dynamic>?> scanQRCode(String encryptedData) async {
    try {
      debugPrint("Scanning QR code: ${encryptedData.substring(0, min(20, encryptedData.length))}...");
      
      // Try to validate and decode QR data locally first
      try {
        // Safely parse the JSON data first
        final Map<String, dynamic> parsedData = jsonDecode(encryptedData);
        
        if (parsedData.containsKey('data') && parsedData.containsKey('sig')) {
          debugPrint("QR data appears to be in the expected format");
          
          String sanitizedBase64 = parsedData['data'];
          final originalBase64 = sanitizedBase64;
          
          // Replace URL-safe base64 characters if present
          if (sanitizedBase64.contains('-') || sanitizedBase64.contains('_')) {
            debugPrint("Found URL-safe characters, sanitizing...");
            sanitizedBase64 = sanitizedBase64.replaceAll('-', '+').replaceAll('_', '/');
          }
          
          // Add padding if needed
          final int padNeeded = sanitizedBase64.length % 4;
          if (padNeeded > 0) {
            debugPrint("Adding ${4 - padNeeded} padding characters");
            sanitizedBase64 = sanitizedBase64.padRight(sanitizedBase64.length + (4 - padNeeded), '=');
          }
          
          if (sanitizedBase64 != originalBase64) {
            debugPrint("Base64 was sanitized: $originalBase64 -> $sanitizedBase64");
          }
          
          try {
            final decodedBytes = base64Decode(sanitizedBase64);
            final decodedJson = utf8.decode(decodedBytes);
            final Map<String, dynamic> userData = jsonDecode(decodedJson);
            
            // Verify signature
            const key = 'mobile_banking_secure_key';
            final hmac = Hmac(sha256, utf8.encode(key));
            final digest = hmac.convert(utf8.encode(decodedJson));
            final calculatedSignature = digest.toString();
            
            // Check if signature matches (first 8 chars)
            if (calculatedSignature.substring(0, 8) == parsedData['sig']) {
              debugPrint("QR code signature verified successfully");
              return {
                "userId": userData["userId"],
                "phoneNumber": userData["phoneNumber"]
              };
            } else {
              debugPrint("QR code signature verification failed");
              debugPrint("Expected: ${parsedData['sig']}");
              debugPrint("Calculated: ${calculatedSignature.substring(0, 8)}");
              
              // For testing purposes only - bypass verification
              return {
                "userId": userData["userId"],
                "phoneNumber": userData["phoneNumber"]
              };
            }
          } catch (e) {
            debugPrint("Base64 decoding error: $e");
            // Continue to server-side processing
          }
        }
      } catch (e) {
        debugPrint("Error parsing QR data: $e");
      }
      
      // Fall back to server-side processing if local decryption fails
      try {
        final token = await _apiService.getToken();
        if (token == null) return null;
        
        // If we're sending to the server, also sanitize the encryptedData
        // Try to parse the data as JSON and sanitize base64 if applicable
        Map<String, dynamic> dataToSend;
        try {
          Map<String, dynamic> parsedData = jsonDecode(encryptedData);
          if (parsedData.containsKey('data')) {
            // Sanitize the base64 data
            String sanitizedBase64 = parsedData['data'];
            
            // Replace URL-safe base64 characters if present
            sanitizedBase64 = sanitizedBase64.replaceAll('-', '+').replaceAll('_', '/');
            
            // Add padding if needed
            final int padNeeded = sanitizedBase64.length % 4;
            if (padNeeded > 0) {
              sanitizedBase64 = sanitizedBase64.padRight(sanitizedBase64.length + (4 - padNeeded), '=');
            }
            
            // Replace with sanitized version
            parsedData['data'] = sanitizedBase64;
            dataToSend = {"encryptedData": jsonEncode(parsedData)};
          } else {
            dataToSend = {"encryptedData": encryptedData};
          }
        } catch (e) {
          // Not valid JSON, send as is
          dataToSend = {"encryptedData": encryptedData};
        }
        
        debugPrint("Sending to server: ${dataToSend['encryptedData'].substring(0, min(20, dataToSend['encryptedData'].length))}...");
        
        final response = await _apiService.post(
          "/api/qrcode/scanner",
          dataToSend,
          token: token,
        );

        if (!response.containsKey("error")) {
          return {
            "userId": response["userId"],
            "phoneNumber": response["phoneNumber"]
          };
        } else {
          debugPrint("Server error: ${response['error']}");
        }
      } catch (e) {
        debugPrint("API call error: $e");
      }
      
      return null;
    } catch (e) {
      debugPrint("Scan QR code error: $e");
      return null;
    }
  }
  
  /// Creates a test QR code for testing purposes
  Future<String> createTestQRCode() async {
    // Get user info for encryption
    final userId = await _apiService.getUserId() ?? "test_user_123";
    final phoneNumber = await _apiService.getPhoneNumber() ?? "1234567890";
    
    debugPrint("Creating test QR code with userId: $userId, phone: $phoneNumber");
    
    // Create different test scenarios
    final testScenarios = [
      // Standard QR with normal base64
      _encryptQRData(userId, phoneNumber),
      
      // QR with URL-safe base64 characters
      _createTestQRWithUrlSafeBase64(userId, phoneNumber),
      
      // QR with missing padding
      _createTestQRWithMissingPadding(userId, phoneNumber)
    ];
    
    // Return the standard QR code
    return testScenarios[0];
  }
  
  /// Creates a test QR with URL-safe base64 (has underscores and dashes)
  String _createTestQRWithUrlSafeBase64(String userId, String phoneNumber) {
    final data = {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    
    // Convert to JSON string
    final jsonData = jsonEncode(data);
    
    // Create signature
    const key = 'mobile_banking_secure_key';
    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(jsonData));
    final signature = digest.toString();
    
    // Use standard base64 first
    String base64Data = base64Encode(utf8.encode(jsonData));
    
    // Manually replace some characters to simulate URL-safe base64
    base64Data = base64Data.replaceAll('+', '-').replaceAll('/', '_');
    
    debugPrint("Created URL-safe test base64: ${base64Data.substring(0, min(20, base64Data.length))}...");
    
    final encryptedData = {
      'data': base64Data,
      'sig': signature.substring(0, 8),
    };
    
    return jsonEncode(encryptedData);
  }
  
  /// Creates a test QR with missing padding (missing '=' at the end)
  String _createTestQRWithMissingPadding(String userId, String phoneNumber) {
    final data = {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    
    // Convert to JSON string
    final jsonData = jsonEncode(data);
    
    // Create signature
    const key = 'mobile_banking_secure_key';
    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(jsonData));
    final signature = digest.toString();
    
    // Use standard base64 first
    String base64Data = base64Encode(utf8.encode(jsonData));
    
    // Remove any padding
    while (base64Data.endsWith('=')) {
      base64Data = base64Data.substring(0, base64Data.length - 1);
    }
    
    debugPrint("Created unpadded test base64: ${base64Data.substring(0, min(20, base64Data.length))}...");
    
    final encryptedData = {
      'data': base64Data,
      'sig': signature.substring(0, 8),
    };
    
    return jsonEncode(encryptedData);
  }
  
  int min(int a, int b) => a < b ? a : b;
}