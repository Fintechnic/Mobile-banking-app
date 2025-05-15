import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import các màn hình với tên file chính xác
import 'screens/bank_slip.dart';
import 'screens/loan.dart';
import 'screens/register_screen.dart';
import 'screens/editprofile.dart';
import 'screens/history.dart';
import 'screens/notification.dart';
import 'screens/paybill.dart';
import 'screens/transfer.dart';
import 'screens/register_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fintechnic',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A3A6B),
        fontFamily: 'SF Pro Display',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Danh sách các màn hình từ các file đã có
  final List<Widget> _screens = [
    const _LoginScreenState(),
    const _RegisterScreenState(),
    const PaymentConfirmationScreen(),
    const LoansScreen(),
    const ProfileSettingsScreen(),
    const TransactionHistoryScreen(),
    const NotificationSettingsScreen(),
    const BillPaymentScreen(),
    const TransferScreen(),
  ];

  // Danh sách tên các màn hình
  final List<String> _screenTitles = [
    'Login',
    'Sign Up',
    'Payment Confirmation',
    'LOanLOan',
    'Account settings',
    'Transaction History',
    'Notification settings',
    'Pay bills',
    'Transfer',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitles[_currentIndex]),
        backgroundColor: const Color(0xFF1A3A6B),
        foregroundColor: Colors.white,
      ),
      body: _screens[_currentIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1A3A6B)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'FintechnicFintechnic',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            for (int i = 0; i < _screenTitles.length; i++)
              ListTile(
                title: Text(_screenTitles[i]),
                selected: _currentIndex == i,
                selectedTileColor: const Color(0xFFE3F2FD),
                selectedColor: const Color(0xFF1A3A6B),
                onTap: () {
                  setState(() {
                    _currentIndex = i;
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
