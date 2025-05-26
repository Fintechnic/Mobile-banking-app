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
import 'package:provider/provider.dart';
import 'package:fintechnic/utils/package_wrapper.dart';

// Import providers
import 'package:fintechnic/providers/auth_provider.dart';
import 'package:fintechnic/providers/bill_provider.dart';
import 'package:fintechnic/providers/transaction_provider.dart';
import 'package:fintechnic/providers/wallet_provider.dart';
import 'package:fintechnic/providers/qrcode_provider.dart';
import 'package:fintechnic/providers/user_provider.dart';
import 'package:fintechnic/providers/stats_provider.dart';

// Import services and utils
import 'package:fintechnic/services/api_service.dart';
import 'package:fintechnic/utils/app_logger.dart';
import 'package:fintechnic/utils/env_config.dart';
import 'package:fintechnic/utils/network_utils.dart';

// Other screen imports
import 'screens/bank_slip.dart';
import 'screens/loan.dart';
import 'screens/register_screen.dart';
import 'screens/editprofile.dart';
import 'screens/history.dart';
import 'screens/notification.dart';
import 'screens/paybill.dart';
import 'screens/transfer.dart';
import 'screens/splash_screen.dart';

final appLogger = AppLogger();

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await EnvConfig.load();
    
    final hasConnection = await NetworkUtils.checkConnection();
    if (!hasConnection) {
      appLogger.w('No internet connection');
    }

    final cameras = await availableCameras();
    final firstCamera = cameras.isNotEmpty ? cameras.first : null;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final apiService = ApiService();
    appLogger.i('API Service initialized');

    runApp(
      MultiProvider(
        providers: [
          Provider<ApiService>.value(value: apiService),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => BillProvider()),
          ChangeNotifierProvider(create: (_) => TransactionProvider()),
          ChangeNotifierProvider(create: (_) => WalletProvider()),
          ChangeNotifierProvider(create: (_) => QRCodeProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => StatsProvider()),
        ],
        child: MyApp(firstCamera: firstCamera),
      ),
    );
  } catch (e, stackTrace) {
    appLogger.e('Error during app initialization', error: e, stackTrace: stackTrace);
    runApp(ErrorApp(error: e.toString()));
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error Initializing App',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    main();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final CameraDescription? firstCamera;

  const MyApp({super.key, required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fintechnic',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A3A6B),
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A3A6B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A3A6B),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: AuthWrapper(firstCamera: firstCamera),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final CameraDescription? firstCamera;

  const AuthWrapper({super.key, required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return const SplashScreen();
        }
        
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Theme.of(context),
          home: const HomeScreen(),
          onGenerateRoute: (settings) {
            Widget page;
            switch (settings.name) {
              case '/qr-scan':
                page = firstCamera != null 
                    ? QRScannerScreen(camera: firstCamera!) 
                    : const Scaffold(
                        body: Center(
                          child: Text('Camera not available'),
                        ),
                      );
                break;
              case '/qr-show':
                page = const QRCodeScreen();
                break;
              case '/account-card':
                page = const AccountCardsScreen();
                break;
              case '/transaction-management':
                page = const TransactionManagementScreen();
                break;
              case '/user-management':
                page = const UserProfilePage();
                break;
              case '/details':
                page = const TransactionDashboard();
                break;
              case '/information':
                page = const InformationScreen();
                break;
              case '/change-password':
                page = const ChangePasswordScreen();
                break;
              case '/payment-confirmation':
                page = const PaymentConfirmationScreen();
                break;
              case '/loan':
                page = const LoansScreen();
                break;
              case '/profile-settings':
                page = const ProfileSettingsScreen();
                break;
              case '/transaction-history':
                page = const TransactionHistoryScreen();
                break;
              case '/notification-settings':
                page = const NotificationSettingsScreen();
                break;
              case '/bill-payment':
                page = const BillPaymentScreen();
                break;
              case '/transfer':
                page = const TransferScreen();
                break;
              default:
                page = const HomeScreen();
            }

            return MaterialPageRoute(builder: (_) => page);
          },
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A6B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Fintechnic',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
