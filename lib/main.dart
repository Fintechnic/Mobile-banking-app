import 'dart:ui'; // 🛠 Import dart:ui để sử dụng PlatformDispatcher
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/homepage_screen.dart';
import 'screens/login_screen.dart';
import 'screens/transferpage.dart';
import 'screens/qr_scan_screen.dart';     //Import QR screen
import 'screens/Account_and_card.dart'; //Import Account_and_card screen
import 'screens/pay_bill.dart'; //Import pay bill screen
import 'screens/profile_screen.dart'; // Import Profile screen
import 'screens/sign_up_screen.dart'; // Import sign_up screen
import 'screens/bank_slip_screen.dart'; //Import bank slip screen
import 'screens/my_qr_screen.dart'; // Import my qr screen
import 'screens/loans_screen.dart';// Import my Loans screen

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
      title: 'Flutter Auth App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isAuthenticated ? const HomePageScreen() : const LoginScreen();
        },
      ),
    );
  }
}
