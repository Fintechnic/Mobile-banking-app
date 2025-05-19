import 'package:camera/camera.dart';
import 'package:fintechnic/screens/Details.dart';
import 'package:fintechnic/screens/account_and_card1.dart';
import 'package:fintechnic/screens/app_information.dart';
import 'package:fintechnic/screens/change_password.dart';
import 'package:fintechnic/screens/homepage_screen.dart';
import 'package:fintechnic/screens/login_screen.dart';
import 'package:fintechnic/screens/qr_scan_screen.dart';
import 'package:fintechnic/screens/qr_screen.dart';
import 'package:fintechnic/screens/transaction_management.dart';
import 'package:fintechnic/screens/user_management.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize cameras
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MyApp(firstCamera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription firstCamera;

  const MyApp({super.key, required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fintechnic',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A3A6B),
        fontFamily: 'SF Pro Display',
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/qr-show': (context) => const QRCodeScreen(),
        '/account-card': (context) => const AccountCardsScreen(),
        '/transaction-management': (context) => const TransactionManagementScreen(),
        '/user-management': (context) => const UserProfilePage(),
        '/details': (context) => const TransactionDashboard(),
        '/information': (context) => const InformationScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/payment-confirmation': (context) => const PaymentConfirmationScreen(),
        '/loan': (context) => const LoansScreen(),
        '/profile-settings': (context) => const ProfileSettingsScreen(),
        '/transaction-history': (context) => const TransactionHistoryScreen(),
        '/notification-settings': (context) => const NotificationSettingsScreen(),
        '/bill-payment': (context) => const BillPaymentScreen(),
        '/transfer': (context) => const TransferScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/qr-scan') {
          return MaterialPageRoute(
            builder: (context) => QRScannerScreen(camera: firstCamera),
          );
        }
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
      },
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

  // Danh sách các route names tương ứng với các màn hình
  final List<String> _routes = [
    '/login',
    '/register',
    '/payment-confirmation',
    '/loan',
    '/profile-settings',
    '/transaction-history',
    '/notification-settings',
    '/bill-payment',
    '/transfer',
  ];

  // Danh sách tên các màn hình
  final List<String> _screenTitles = [
    'Login',
    'Sign Up',
    'Payment Confirmation',
    'Loan',
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1A3A6B)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    'Fintechnic',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
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
                  Navigator.pushNamed(context, _routes[i]);
                },
              ),
          ],
        ),
      ),
    );
  }
}

