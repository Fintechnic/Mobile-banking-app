import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PasswordManagerScreen(),
    );
  }
}

class PasswordManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF98C5F5), // Light blue background
      appBar: AppBar(
        backgroundColor: Color(0xFF98C5F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () {},
        ),
        title: Text('Password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.flag_outlined, color: Colors.black, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.phone_outlined, color: Colors.black, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF98C5F5), // Light blue background for top section
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              // Main white card containing all content
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Security Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25),
                      // Semi-circular progress indicator
                      Container(
                        height: 120,
                        width: 240,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Custom semi-circular progress indicator
                            CustomPaint(
                              size: Size(240, 120),
                              painter: SemiCirclePainter(),
                            ),
                            Positioned(
                              top: 30,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '5/5',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'SUCCESSFUL STEPS',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      // Bottom icons row - directly below the semi-circle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFeatureItem(Icons.person_outline, 'Account\nIdentification'),
                          _buildFeatureItem(Icons.fingerprint, 'Biometric\nAuthentication'),
                          _buildFeatureItem(Icons.face, 'Face\nAuthentication'),
                          _buildFeatureItem(Icons.people_outline, 'Change\nPassword'),
                          _buildFeatureItem(Icons.lock_outline, 'OTP'),
                        ],
                      ),
                      SizedBox(height: 30),
                      
                      // Security info sections
                      _buildSecurityInfoItem(
                        Icons.star,
                        'Your transactions are protected 24/7 by AI-powered security.',
                      ),
                      SizedBox(height: 16),
                      _buildSecurityInfoItem(
                        Icons.shield_outlined,
                        'All sensitive data is encrypted following global security standards.',
                      ),
                      SizedBox(height: 16),
                      _buildSecurityInfoItem(
                        Icons.favorite_border,
                        'Take security measures to enhance the protection of your information.',
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Bottom actions row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(Icons.headset_mic_outlined, 'Emergency\nSupport'),
                          _buildActionButton(Icons.settings, 'Account\nCustomization'),
                          _buildActionButton(Icons.shopping_bag_outlined, 'Activity\nHistory'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Icon(icon, size: 24, color: Colors.black87), // Increased icon size
        ),
        SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10, // Slightly larger font
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSecurityInfoItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade100,
          ),
          child: Icon(icon, size: 20, color: Colors.black87), // Larger icon
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16), // Larger padding for bigger container
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: Icon(icon, size: 28, color: Colors.black87), // Much larger icon
        ),
        SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// Custom painter for semi-circular progress indicator
class SemiCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.height;
    
    // Background arc (transparent or slight gray if needed)
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
      
    // Draw background arc (semi-circle)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi,
      math.pi,
      false,
      backgroundPaint,
    );
    
    // Progress arc (green)
    final progressPaint = Paint()
      ..color = Color(0xFF32CD32) // Bright green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
      
    // Draw progress arc (full semi-circle for 5/5)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi,
      math.pi,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}