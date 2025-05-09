import 'dart:ui'; // 🛠 Import dart:ui để sử dụng PlatformDispatcher
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'package:camera/camera.dart';


// Import các screen cần thiết
import 'screens/homepage_screen.dart';
import 'screens/qr_scan_screen.dart';     
import 'screens/account_and_card2.dart';
import 'screens/account_and_card1.dart'; 
import 'screens/transaction_management.dart';
import 'screens/user_management.dart';
import 'screens/Details.dart';
import 'screens/login_screen.dart'; 
import 'screens/app_information.dart';
import 'screens/change_password.dart';
import 'screens/qr_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint("Error: $error");
    return true;
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isAuthenticated
              ? const HomeScreen()
              : const LoginScreen(); 
        },
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/qr-show': (context) => const QRCodeScreen(),
        '/account-card1': (context) => const AccountCardsScreen1(),
        '/account-card2': (context) => const AccountCardScreen(),
        '/transaction-management': (context) => const TransactionManagementScreen(),
        '/user-management': (context) => const UserProfilePage(),
        '/details': (context) => const TransactionDashboard(),
        '/information': (context) => const InformationScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/qr-scan') {
          final camera = settings.arguments as CameraDescription;
          return MaterialPageRoute(
            builder: (context) => QRScannerScreen(camera: camera),
          );
        }
        return null;
      },
    );
  }
}

