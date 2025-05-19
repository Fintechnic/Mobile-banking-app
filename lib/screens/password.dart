import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: const PasswordManagerScreen(),
    );
  }
}

class PasswordManagerScreen extends StatefulWidget {
  const PasswordManagerScreen({super.key});

  @override
  State<PasswordManagerScreen> createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  int _securityScore = 0;
  final int _maxScore = 5;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  // Security features status
  final Map<String, bool> _securityFeatures = {
    'Account Identification': true,
    'Biometric Authentication': true,
    'Face Authentication': true,
    'Change Password': true,
    'OTP': true,
  };

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Load security status
    _loadSecurityStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Load security status with simulated delay
  Future<void> _loadSecurityStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Calculate security score based on enabled features
      _securityScore =
          _securityFeatures.values.where((enabled) => enabled).length;

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Show feature details dialog
  void _showFeatureDetails(String feature) {
    String description = '';

    switch (feature) {
      case 'Account Identification':
        description =
            'Your account is protected with a unique identifier that helps prevent unauthorized access.';
        break;
      case 'Biometric Authentication':
        description =
            'Use your fingerprint to securely access your account without entering passwords.';
        break;
      case 'Face Authentication':
        description =
            'Advanced facial recognition technology to verify your identity.';
        break;
      case 'Change Password':
        description =
            'Regularly update your password to maintain account security.';
        break;
      case 'OTP':
        description =
            'One-Time Password provides an additional layer of security for sensitive transactions.';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Show action details
  void _showActionDetails(String action) {
    String message = '';

    switch (action) {
      case 'Emergency Support':
        message = 'Connecting to emergency support...';
        break;
      case 'Account Customization':
        message = 'Opening account settings...';
        break;
      case 'Activity History':
        message = 'Loading activity history...';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF98C5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF98C5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Password',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.flag_outlined, color: Colors.black, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report an issue')),
              );
            },
          ),
          IconButton(
            icon:
                const Icon(Icons.phone_outlined, color: Colors.black, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact support')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                color: Color(0xFF98C5F5), // Light blue background
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text(
                              'Security Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 25),

                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return SizedBox(
                                  height: 120,
                                  width: 240,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Custom semi-circular progress indicator
                                      CustomPaint(
                                        size: const Size(240, 120),
                                        painter: SemiCirclePainter(
                                          progress: _progressAnimation.value *
                                              (_securityScore / _maxScore),
                                        ),
                                      ),
                                      Positioned(
                                        top: 30,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TweenAnimationBuilder<int>(
                                              tween: IntTween(
                                                  begin: 0,
                                                  end: _securityScore),
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                              builder: (context, value, child) {
                                                return Text(
                                                  '$value/$_maxScore',
                                                  style: const TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              },
                                            ),
                                            const Text(
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
                                );
                              },
                            ),
                            const SizedBox(height: 25),
                            // Feature icons row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildFeatureItem(
                                  Icons.person_outline,
                                  'Account\nIdentification',
                                  _securityFeatures['Account Identification']!,
                                  () => _showFeatureDetails(
                                      'Account Identification'),
                                ),
                                _buildFeatureItem(
                                  Icons.fingerprint,
                                  'Biometric\nAuthentication',
                                  _securityFeatures[
                                      'Biometric Authentication']!,
                                  () => _showFeatureDetails(
                                      'Biometric Authentication'),
                                ),
                                _buildFeatureItem(
                                  Icons.face,
                                  'Face\nAuthentication',
                                  _securityFeatures['Face Authentication']!,
                                  () => _showFeatureDetails(
                                      'Face Authentication'),
                                ),
                                _buildFeatureItem(
                                  Icons.lock_outline,
                                  'Change\nPassword',
                                  _securityFeatures['Change Password']!,
                                  () => _showFeatureDetails('Change Password'),
                                ),
                                _buildFeatureItem(
                                  Icons.key,
                                  'OTP',
                                  _securityFeatures['OTP']!,
                                  () => _showFeatureDetails('OTP'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            // Security info sections with staggered animation
                            _buildAnimatedSecurityInfoItem(
                              Icons.star,
                              'Your transactions are protected 24/7 by AI-powered security.',
                              0,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedSecurityInfoItem(
                              Icons.shield_outlined,
                              'All sensitive data is encrypted following global security standards.',
                              200,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedSecurityInfoItem(
                              Icons.favorite_border,
                              'Take security measures to enhance the protection of your information.',
                              400,
                            ),

                            const SizedBox(height: 30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildActionButton(
                                  Icons.headset_mic_outlined,
                                  'Emergency\nSupport',
                                  () => _showActionDetails('Emergency Support'),
                                ),
                                _buildActionButton(
                                  Icons.settings,
                                  'Account\nCustomization',
                                  () => _showActionDetails(
                                      'Account Customization'),
                                ),
                                _buildActionButton(
                                  Icons.history,
                                  'Activity\nHistory',
                                  () => _showActionDetails('Activity History'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFeatureItem(
      IconData icon, String label, bool isEnabled, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEnabled ? Colors.white : Colors.grey.shade200,
              border: Border.all(
                color: isEnabled ? Colors.grey.shade300 : Colors.grey.shade400,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isEnabled ? Colors.black87 : Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: isEnabled ? Colors.black87 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSecurityInfoItem(IconData icon, String text, int delay) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: AnimatedSlide(
            offset: snapshot.connectionState == ConnectionState.done
                ? Offset.zero
                : const Offset(0.0, 0.2),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                  child: Icon(icon, size: 18, color: Colors.black87),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
            child: Icon(icon, size: 24, color: Colors.black87),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class SemiCirclePainter extends CustomPainter {
  final double progress; // 0.0 to 1.0

  SemiCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.height;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    final progressPaint = Paint()
      ..color = const Color(0xFF32CD32) // Bright green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi,
      math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SemiCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
