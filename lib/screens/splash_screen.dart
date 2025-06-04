import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/responsive_utils.dart';
import '../utils/responsive_wrapper.dart';
import 'homepage_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  final CameraDescription? camera;

  const SplashScreen({super.key, this.camera});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));
    
    // Check authentication status
    await authProvider.checkAuthStatus();
    
    if (!mounted) return;

    // Navigate based on auth status
    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ResponsiveBuilder(
        builder: (context, deviceType, isLandscape) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo or image can be responsive based on device size
                SizedBox(
                  width: isLandscape 
                    ? ResponsiveUtils.getWidthPercentage(context, 20)
                    : ResponsiveUtils.getWidthPercentage(context, 40),
                  height: isLandscape
                    ? ResponsiveUtils.getHeightPercentage(context, 20)
                    : ResponsiveUtils.getHeightPercentage(context, 15),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: ResponsiveUtils.getResponsiveFontSize(context, isLandscape ? 60 : 80),
                  ),
                ),
                const SizedBox(height: 24),
                // App name
                Text(
                  'Fintechnic',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, isLandscape ? 28 : 32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isLandscape ? 32 : 48),
                // Loading indicator
                SizedBox(
                  width: isLandscape ? 40 : 48, 
                  height: isLandscape ? 40 : 48,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}