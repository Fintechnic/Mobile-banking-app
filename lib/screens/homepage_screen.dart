// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BankingDataProvider()),
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
      title: 'Banking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// Provider to manage banking data
class BankingDataProvider extends ChangeNotifier {
  String _balance = '0';
  String _paylaterAmount = '0';
  List<QuickAccessItem> _quickAccessItems = [];
  List<PromoItem> _promos = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  String get balance => _balance;
  String get paylaterAmount => _paylaterAmount;
  List<QuickAccessItem> get quickAccessItems => _quickAccessItems;
  List<PromoItem> get promos => _promos;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> fetchData() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would fetch data from your API
      // final response = await http.get(Uri.parse('https://your-api.com/banking-data'));
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   _balance = data['balance'];
      //   _paylaterAmount = data['paylater'];
      // } else {
      //   throw Exception('Failed to load data');
      // }

      // Mock data for demonstration
      _balance = '1.000.000 VND';
      _paylaterAmount = '500.000 VND';
      _initializeQuickAccessItems();
      _initializePromos();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _initializeQuickAccessItems() {
    _quickAccessItems = [
      QuickAccessItem(type: "chat", label: "Top-up", isMultiLine: false),
      QuickAccessItem(type: "transfer", label: "Transfer", isMultiLine: false),
      QuickAccessItem(type: "ticket", label: "Ticket", isMultiLine: false),
      QuickAccessItem(
          type: "piggy", label: "Saving\nWallet", isMultiLine: true),
      QuickAccessItem(type: "data", label: "Datapack", isMultiLine: false),
      QuickAccessItem(type: "wallet", label: "Paylater", isMultiLine: false),
      QuickAccessItem(type: "bill", label: "Bill\nPayment", isMultiLine: true),
      QuickAccessItem(type: "loan", label: "Loan\nPayment", isMultiLine: true),
    ];
  }

  void _initializePromos() {
    _promos = [
      PromoItem(
        title: 'Giảm 50% phí chuyển tiền',
        description:
            'Áp dụng cho tất cả các giao dịch chuyển tiền đến hết 30/04/2025',
        expiry: '30/04/2025',
        backgroundColor: Colors.blue.shade50,
      ),
      PromoItem(
        title: 'Hoàn tiền 10%',
        description: 'Cho các giao dịch thanh toán hóa đơn lần đầu',
        expiry: '15/05/2025',
        backgroundColor: Colors.green.shade50,
      ),
    ];
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    // Load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bankingDataProvider =
          Provider.of<BankingDataProvider>(context, listen: false);

      if (authProvider.userData == null) {
        authProvider.getUserData();
      }

      bankingDataProvider.fetchData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bankingDataProvider =
        Provider.of<BankingDataProvider>(context, listen: false);

    await Future.wait([
      authProvider.getUserData(),
      bankingDataProvider.fetchData(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bankingDataProvider = Provider.of<BankingDataProvider>(context);

    if (authProvider.userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(authProvider, bankingDataProvider),
              Expanded(
                child: bankingDataProvider.hasError
                    ? _buildErrorView(bankingDataProvider.errorMessage)
                    : SingleChildScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            _buildQuickAccess(bankingDataProvider),
                            _buildInfoPromo(bankingDataProvider),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Đã xảy ra lỗi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              final bankingDataProvider =
                  Provider.of<BankingDataProvider>(context, listen: false);
              bankingDataProvider.fetchData();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      AuthProvider authProvider, BankingDataProvider bankingDataProvider) {
    // Get username from AuthProvider
    final username = authProvider.userData?['username'] ?? 'Mr.A';

    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4, 0.7],
          colors: [
            Color(0xFFB0D1F5), // Light blue at top
            Color(0xFF8BB8EE), // Medium blue in middle
            Color(0xFF1A5FA3), // Dark blue at bottom
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Handle notification icon tap with animation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không có thông báo mới')),
                  );
                },
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 28,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: bankingDataProvider.isLoading
                ? _buildBalanceShimmer()
                : _buildBalanceCard(bankingDataProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BankingDataProvider bankingDataProvider) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // MY BALANCE Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MY BALANCE',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  bankingDataProvider.balance,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Vertical Divider
          Container(
            height: 40,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          // PAYLATER Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'PAYLATER',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  bankingDataProvider.paylaterAmount,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess(BankingDataProvider bankingDataProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              InkWell(
                onTap: () {
                  // Handle "see more" button tap with animation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang tải thêm dịch vụ...')),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Text(
                        'Xem thêm',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.blue.shade700,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Quick access items with loading state
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: bankingDataProvider.isLoading
                ? _buildQuickAccessShimmer()
                : _buildQuickAccessItems(bankingDataProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessShimmer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) => _buildQuickAccessItemShimmer()),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) => _buildQuickAccessItemShimmer()),
        ),
      ],
    );
  }

  Widget _buildQuickAccessItemShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 40,
            height: 10,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessItems(BankingDataProvider bankingDataProvider) {
    return Column(
      children: [
        // First row of quick access items
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: bankingDataProvider.quickAccessItems
              .sublist(0, 4)
              .map((item) => _buildQuickAccessItem(
                    _buildCustomIcon(item.type, Icons.help_outline),
                    item.label,
                    item.isMultiLine,
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
        // Second row of quick access items
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: bankingDataProvider.quickAccessItems
              .sublist(4, 8)
              .map((item) => _buildQuickAccessItem(
                    _buildCustomIcon(item.type, Icons.help_outline),
                    item.label,
                    item.isMultiLine,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCustomIcon(String type, IconData fallbackIcon) {
    switch (type) {
      case "chat":
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              color: Colors.blue.shade700,
              size: 24,
            ),
            Positioned(
              bottom: 7,
              child: Icon(
                Icons.attach_money,
                color: Colors.blue.shade700,
                size: 12,
              ),
            ),
          ],
        );
      case "transfer":
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.blue.shade700,
              size: 18,
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.blue.shade700,
              size: 18,
            ),
          ],
        );
      case "ticket":
        return CustomPaint(
          size: const Size(24, 24),
          painter: TicketPainter(Colors.blue.shade700),
        );
      case "piggy":
        return Icon(
          Icons.savings_outlined,
          color: Colors.blue.shade700,
          size: 24,
        );
      case "data":
        return CustomPaint(
          size: const Size(24, 24),
          painter: DatapackPainter(Colors.blue.shade700),
        );
      case "wallet":
        return Icon(
          Icons.account_balance_wallet_outlined,
          color: Colors.blue.shade700,
          size: 24,
        );
      case "bill":
        return Icon(
          Icons.receipt_outlined,
          color: Colors.blue.shade700,
          size: 24,
        );
      case "loan":
        return CustomPaint(
          size: const Size(24, 24),
          painter: CoinStackPainter(Colors.blue.shade700),
        );
      default:
        return Icon(
          fallbackIcon,
          color: Colors.blue.shade700,
          size: 24,
        );
    }
  }

  Widget _buildQuickAccessItem(Widget icon, String label, bool isMultiLine) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          // Handle Quick Access item tap with animation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bạn đã chọn: $label')),
          );
        },
        child: SizedBox(
          width: 70, // Fixed width for all items
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(child: icon),
              ),
              const SizedBox(height: 5),
              Container(
                height: isMultiLine
                    ? 32
                    : 16, // Fixed height based on number of lines
                alignment: Alignment.center,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPromo(BankingDataProvider bankingDataProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Infor and promo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              InkWell(
                onTap: () {
                  // Handle "see more" button tap
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Xem tất cả khuyến mãi')),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.blue.shade700,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Promo items with loading state
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: bankingDataProvider.isLoading
                ? _buildPromoShimmer()
                : _buildPromoItems(bankingDataProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoItems(BankingDataProvider bankingDataProvider) {
    if (bankingDataProvider.promos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text('Không có khuyến mãi hiện tại'),
      );
    }

    return Column(
      children: bankingDataProvider.promos
          .map((promo) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildPromoCard(promo),
              ))
          .toList(),
    );
  }

  Widget _buildPromoCard(PromoItem promo) {
    return InkWell(
      onTap: () {
        // Show promo details
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => _buildPromoDetails(promo),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: promo.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promo.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hết hạn: ${promo.expiry}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.blue.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoDetails(PromoItem promo) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            promo.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            promo.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                'Hết hạn: ${promo.expiry}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Đã áp dụng khuyến mãi: ${promo.title}')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Áp dụng ngay'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', true),
          _buildNavItem(Icons.history, 'History', false),
          _buildCircleNavItem(Icons.qr_code_scanner, 'Account & Card'),
          _buildNavItem(Icons.credit_card, 'Cards', false),
          _buildNavItem(Icons.settings, 'Setting', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          // Simulate page navigation with animation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chuyển đến màn hình: $label')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleNavItem(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Handle QR code button tap with animation
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Quét mã QR',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_scanner,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Đóng'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: 1.1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              ),
            ),
          ),
          const Text(
            'Account & Card',
            style: TextStyle(
              fontSize: 10,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickAccessItem {
  final String type;
  final String label;
  final bool isMultiLine;

  QuickAccessItem({
    required this.type,
    required this.label,
    required this.isMultiLine,
  });
}

class PromoItem {
  final String title;
  final String description;
  final String expiry;
  final Color backgroundColor;

  PromoItem({
    required this.title,
    required this.description,
    required this.expiry,
    required this.backgroundColor,
  });
}

class TicketPainter extends CustomPainter {
  final Color color;
  TicketPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(2, 8);
    path.lineTo(22, 8);
    path.lineTo(22, 19);
    path.lineTo(2, 19);
    path.close();

    path.moveTo(2, 13);
    path.lineTo(22, 13);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DatapackPainter extends CustomPainter {
  final Color color;
  DatapackPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(4, 6);
    path.lineTo(20, 6);
    path.lineTo(20, 16);
    path.lineTo(4, 16);
    path.close();

    path.moveTo(8, 16);
    path.lineTo(8, 19);
    path.lineTo(16, 19);
    path.lineTo(16, 16);

    canvas.drawPath(path, paint);

    final screenPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      const Offset(8, 10),
      const Offset(16, 10),
      screenPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CoinStackPainter extends CustomPainter {
  final Color color;
  CoinStackPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(12, 8), width: 16, height: 6),
      paint,
    );

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(12, 12), width: 16, height: 6),
      paint,
    );

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(12, 16), width: 16, height: 6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
