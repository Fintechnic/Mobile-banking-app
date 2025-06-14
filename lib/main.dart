import 'package:fintechnic/screens/details.dart';
import 'package:fintechnic/screens/account_and_card1.dart';
import 'package:fintechnic/screens/app_information.dart';
import 'package:fintechnic/screens/change_password.dart';
import 'package:fintechnic/screens/homepage_screen.dart';
import 'package:fintechnic/screens/login_screen.dart';
import 'package:fintechnic/screens/notification_list.dart';
import 'package:fintechnic/screens/profile_screen.dart';
import 'package:fintechnic/screens/qr_scan_screen.dart';
import 'package:fintechnic/screens/qr_screen.dart';
import 'package:fintechnic/screens/transaction_management.dart';
import 'package:fintechnic/screens/user_management.dart';
import 'package:fintechnic/screens/admin_dashboard.dart';
import 'package:fintechnic/screens/admin_topup.dart';
import 'package:fintechnic/screens/admin_user_list.dart';
import 'package:fintechnic/screens/admin_user_details.dart';
import 'package:fintechnic/screens/admin_transaction_screen.dart';
import 'package:fintechnic/utils/role_constants.dart';
import 'package:fintechnic/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import providers
import 'package:fintechnic/providers/auth_provider.dart';
import 'package:fintechnic/providers/bill_provider.dart';
import 'package:fintechnic/providers/transaction_provider.dart';
import 'package:fintechnic/providers/wallet_provider.dart';
import 'package:fintechnic/providers/qr_code_provider.dart';
import 'package:fintechnic/providers/user_provider.dart';
import 'package:fintechnic/providers/stats_provider.dart';
import 'package:fintechnic/providers/banking_data_provider.dart';
import 'package:fintechnic/providers/admin_transaction_provider.dart';

// Import services and utils
import 'package:fintechnic/services/api_service.dart';
import 'package:fintechnic/utils/api_constants.dart';
import 'package:fintechnic/utils/app_logger.dart';
import 'package:fintechnic/utils/env_config.dart';
import 'package:fintechnic/utils/network_utils.dart';
import 'package:fintechnic/utils/app_theme.dart';

// Other screen imports
import 'screens/bank_slip.dart';
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

    // Load the API token from shared preferences
    await ApiConstants.loadToken();

    final hasConnection = await NetworkUtils.checkConnection();
    if (!hasConnection) {
      appLogger.w('No internet connection');
    }

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
          ChangeNotifierProvider(create: (_) => BankingDataProvider()),
          ChangeNotifierProvider(create: (_) => AdminTransactionProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    appLogger.e('Error during app initialization',
        error: e, stackTrace: stackTrace);
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fintechnic',
      theme: AppTheme.getTheme(),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        
        double textScaleFactor = 1.0;
        if (ResponsiveUtils.getDeviceType(context) == DeviceType.tablet) {
          textScaleFactor = 1.1;
        } else if (ResponsiveUtils.getDeviceType(context) == DeviceType.desktop) {
          textScaleFactor = 1.2;
        }
        
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaleFactor: textScaleFactor,
          ),
          child: child!,
        );
      },
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

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

        // Check if user has admin role
        final isAdmin = RoleConstants.isAdmin(authProvider.userRole);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Theme.of(context),
          home: isAdmin ? const AdminDashboard() : const HomeScreen(),
          onGenerateRoute: (settings) {
            Widget page;
            switch (settings.name) {
              case '/qr-scan':
                page = const QRScannerScreen();
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
              case '/admin-dashboard':
                page = const AdminDashboard();
                break;
              case '/admin-topup':
                page = const AdminTopupScreen();
                break;
              case '/admin-user-list':
                page = const AdminUserListScreen();
                break;
              case '/admin-user-details':
                // Extract userId parameter
                final args = settings.arguments as Map<String, dynamic>?;
                final userId = args != null ? args['userId'] as int? : null;
                if (userId != null) {
                  page = AdminUserDetailsScreen(userId: userId);
                } else {
                  page = const AdminUserListScreen();
                }
                break;
              case '/admin-transactions':
                page = const AdminTransactionScreen();
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
              case '/profile-settings':
                page = const ProfileSettingsScreen();
                break;
              case '/transaction-history':
                page = const TransactionHistoryScreen();
                break;
              case '/notifications':
                page = const NotificationListScreen();
                break;
              case '/notification-settings':
                page = const NotificationSettingsScreen();
                break;
              case '/profile':
                page = const ProfileScreen();
                break;
              case '/bill-payment':
                page = const BillPaymentScreen();
                break;
              case '/transfer':
                page = const TransferScreen();
                break;
              case '/login':
                page = const LoginScreen();
                break;
              default:
                page = isAdmin ? const AdminDashboard() : const HomeScreen();
            }
            return MaterialPageRoute(builder: (context) => page);
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
      backgroundColor: AppTheme.primaryColor,
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
