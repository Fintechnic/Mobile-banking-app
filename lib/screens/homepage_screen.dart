// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../providers/auth_provider.dart';
import '../providers/banking_data_provider.dart';
import '../utils/responsive_utils.dart';
import '../utils/responsive_wrapper.dart';
import '../screens/transfer.dart';
import '../screens/withdraw.dart';

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
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      AuthProvider authProvider, BankingDataProvider bankingDataProvider) {
    // Get username from BankingDataProvider instead of AuthProvider
    final username = bankingDataProvider.username.isNotEmpty
        ? bankingDataProvider.username
        : authProvider.userData?['username'] ?? 'User';

    return Container(
      padding: EdgeInsets.only(
        top: ResponsiveUtils.getHeightPercentage(context, 4),
        bottom: 20,
        left: ResponsiveUtils.getWidthPercentage(context, 5),
        right: ResponsiveUtils.getWidthPercentage(context, 5),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A3A6B), Color(0xFF5A8ED0)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(33, 150, 243, 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ResponsiveBuilder(
        builder: (context, deviceType, isLandscape) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: isLandscape ? 20 : 24,
                        child: Icon(
                          Icons.person,
                          color: const Color(0xFF1A3A6B),
                          size: isLandscape ? 24 : 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            username,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Stack(
                          children: [
                            const Icon(Icons.notifications_outlined, color: Colors.white),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
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
                        onPressed: () {
                          Navigator.pushNamed(context, '/notifications');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_outline, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildBalanceCard(bankingDataProvider, isLandscape),
            ],
          );
        }
      ),
    );
  }

  Widget _buildBalanceCard(BankingDataProvider bankingDataProvider, bool isLandscape) {
    final balance = bankingDataProvider.balance;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 16 : 20,
        vertical: isLandscape ? 16 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(33, 150, 243, 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available balance',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3A6B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          bankingDataProvider.isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 32,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              : Text(
                  '$balance VND',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, isLandscape ? 22 : 28),
                    color: const Color(0xFF1A3A6B),
                  ),
                ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                icon: Icons.arrow_upward,
                label: 'Transfer',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransferScreen(),
                    ),
                  );
                },
                isLandscape: isLandscape,
              ),
              _buildActionButton(
                icon: Icons.arrow_downward,
                label: 'Withdraw',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WithdrawScreen(),
                    ),
                  );
                },
                isLandscape: isLandscape,
              ),
              _buildActionButton(
                icon: Icons.qr_code,
                label: 'QR Scan',
                onTap: () {
                  Navigator.pushNamed(context, '/qr-scan');
                },
                isLandscape: isLandscape,
              ),
              _buildActionButton(
                icon: Icons.more_horiz,
                label: 'More',
                onTap: () {
                  Navigator.pushNamed(context, '/more-options');
                },
                isLandscape: isLandscape,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isLandscape,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: isLandscape ? 40 : 50,
            height: isLandscape ? 40 : 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FB),
              borderRadius: BorderRadius.circular(isLandscape ? 12 : 15),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1A3A6B),
              size: isLandscape ? 22 : 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, isLandscape ? 10 : 12),
              color: const Color(0xFF1A3A6B),
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
                    const SnackBar(content: Text('Loading more services...')),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Text(
                        'See more',
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
        // Display all quick access items in a single row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: bankingDataProvider.quickAccessItems
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
      case "withdraw":
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
      case "qr":
        return Icon(
          Icons.qr_code,
          color: Colors.blue.shade700,
          size: 24,
        );
      case "qr_scan":
        return Icon(
          Icons.qr_code_scanner,
          color: Colors.blue.shade700,
          size: 24,
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
          // Handle navigation based on item label
          if (label == "Transfer") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransferScreen()),
            );
          } else if (label == "Withdraw") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WithdrawScreen()),
            );
          } else if (label == "Bill") {
            Navigator.pushNamed(context, '/bill-payment');
          } else if (label == "QR") {
            Navigator.pushNamed(context, '/qr-show');
          } else if (label == "Scan QR") {
            Navigator.pushNamed(context, '/qr-scan');
          } else {
            // Default behavior for other items
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bạn đã chọn: $label')),
            );
          }
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
                      color: Color.fromRGBO(33, 150, 243, 0.3),
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
                'Information and promo',
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
                    const SnackBar(content: Text('See all promotions')),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Text(
                        'See all',
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
        child: const Text('No promotions available'),
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
              color: Color.fromRGBO(33, 150, 243, 0.3),
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
                    'Expiry: ${promo.expiry}',
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
                'Expiry: ${promo.expiry}',
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
                      content: Text('Applied promotion: ${promo.title}')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Apply now'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(33, 150, 243, 0.3),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.history_rounded, 'History', false),
          _buildCircleNavItem(Icons.qr_code_scanner_rounded),
          _buildNavItem(Icons.settings_rounded, 'Setting', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final Color activeColor = Colors.blue.shade600;
    final Color inactiveColor = Colors.grey.shade600;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          if (label == 'History') {
            // Navigate to transaction history screen
            Navigator.of(context).pushNamed('/transaction-history');
          } else if (label == 'Setting' && !isActive) {
            // Navigate to profile settings screen
            Navigator.of(context).pushNamed('/profile-settings');
          } else if (!isActive) {
            // Fallback for other menu items
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Moving to screen: $label')),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? Color.fromRGBO(33, 150, 243, 0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleNavItem(IconData icon) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(bottom: 30),
      child: GestureDetector(
        onTap: () {
          // Navigate directly to QR scanner screen
          Navigator.pushNamed(context, '/qr-scan');
        },
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 1.0, end: 1.05),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(33, 150, 243, 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
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