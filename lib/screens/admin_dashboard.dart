import 'package:flutter/material.dart';
import 'package:fintechnic/services/auth_service.dart';
import 'package:fintechnic/providers/stats_provider.dart';
import 'package:provider/provider.dart';
import '../utils/responsive_utils.dart';
import '../utils/responsive_wrapper.dart';
import 'admin_topup.dart';
import 'admin_user_list.dart';
import 'admin_transaction_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  String _username = '';
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animations first, before any async operations
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
    
    // Now load data
    _loadData();
    
    // Schedule stats loading after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshStats();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load username
      final username = await _authService.getStoredUsername();
      if (username != null) {
        setState(() {
          _username = username;
        });
      }
    } catch (e) {
      debugPrint('Error loading admin dashboard data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _refreshStats() {
    if (!mounted) return;
    final statsProvider = Provider.of<StatsProvider>(context, listen: false);
    statsProvider.fetchSystemStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  _refreshStats();
                  return Future.delayed(const Duration(milliseconds: 500));
                },
                child: _animationController.isAnimating || _animationController.status == AnimationStatus.completed
                    ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            _buildHeader(),
                            Expanded(
                              child: ResponsiveBuilder(
                                builder: (context, deviceType, isLandscape) {
                                  return SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: MediaQuery.of(context).size.height * 0.5,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 16),
                                            _buildSystemStatsSection(deviceType: deviceType, isLandscape: isLandscape),
                                            SizedBox(height: isLandscape ? 12 : 16),
                                            _buildFeaturesGrid(deviceType: deviceType, isLandscape: isLandscape),
                                            // Add extra space at the bottom to avoid overflow
                                            const SizedBox(height: 24),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
    );
  }

  Widget _buildHeader() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: const Color(0xFF1A3A6B),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello Admin,',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _username,
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
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  await _authService.logout(_username);
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A3A6B),
                  ),
                ),
                Text(
                  'System Overview',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatsSection({DeviceType deviceType = DeviceType.mobile, bool isLandscape = false}) {
    return Consumer<StatsProvider>(
      builder: (context, statsProvider, child) {
        final isStatsLoading = statsProvider.isLoading;
        final hasError = statsProvider.error != null;
        final stats = statsProvider.systemStats;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'System Statistics',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A3A6B),
                    ),
                  ),
                  if (isStatsLoading)
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5A8ED0)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (hasError)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Failed to load statistics',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _refreshStats,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A3A6B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (stats == null && !isStatsLoading)
                const Center(
                  child: Text(
                    'No statistics available',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                )
              else if (!isStatsLoading)
                _buildSystemStatsGrid(stats!, deviceType, isLandscape),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSystemStatsGrid(Map<String, dynamic> stats, DeviceType deviceType, bool isLandscape) {
    // Adapt to different screen sizes
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360; // For very small devices
    
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isSmallScreen 
          ? (isLandscape ? 1.5 : 1.3) 
          : (isLandscape ? 1.6 : 1.4),
      children: [
        _buildStatCard(
          'Total Users',
          '${stats['totalUsers'] ?? 0}',
          Icons.people,
          const Color(0xFF1A3A6B),
        ),
        _buildStatCard(
          'Total Transactions',
          '${stats['totalTransactions'] ?? 0}',
          Icons.swap_horiz,
          const Color(0xFF5A8ED0),
        ),
        _buildStatCard(
          'Total Balance',
          '\$${_formatNumber(stats['totalBalance'] ?? 0)}',
          Icons.account_balance_wallet,
          const Color(0xFF1A3A6B),
        ),
        _buildStatCard(
          'Average Balance',
          '\$${_formatNumber(stats['averageBalance'] ?? 0)}',
          Icons.bar_chart,
          const Color(0xFF5A8ED0),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: color.withOpacity(0.8),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid({DeviceType deviceType = DeviceType.mobile, bool isLandscape = false}) {
    // Determine column count and sizing based on screen size
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360; // For very small devices
    
    int crossAxisCount;
    double aspectRatio;
    
    if (isLandscape) {
      crossAxisCount = deviceType == DeviceType.mobile ? 3 : 4;
      aspectRatio = isSmallScreen ? 1.0 : 1.1;
    } else {
      crossAxisCount = deviceType == DeviceType.mobile ? 2 : 3;
      aspectRatio = isSmallScreen ? 0.85 : 0.9;
    }
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      childAspectRatio: aspectRatio,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.all(0),
      children: [
        _buildFeatureCard(
          'User Management',
          Icons.people,
          Colors.blue,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminUserListScreen(),
            ),
          ),
        ),
        _buildFeatureCard(
          'Transaction Management',
          Icons.swap_horiz,
          Colors.green,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminTransactionScreen(),
            ),
          ),
        ),
        _buildFeatureCard(
          'Top-up Management',
          Icons.account_balance_wallet,
          Colors.amber,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminTopupScreen(),
            ),
          ),
        ),
        _buildFeatureCard(
          'System Settings',
          Icons.settings,
          Colors.purple,
          () {
            // Implement system settings navigation
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
      String title, IconData icon, MaterialColor color, VoidCallback onTap) {
    return Hero(
      tag: 'admin_feature_$title',
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(26, 58, 107, 0.8),
                  Color.fromRGBO(90, 142, 208, 0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22,
                  child: Icon(
                    icon,
                    size: 20,
                    color: const Color(0xFF1A3A6B),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(dynamic number) {
    if (number is String) {
      try {
        number = double.parse(number);
      } catch (e) {
        return number.toString();
      }
    }
    
    if (number is int) {
      number = number.toDouble();
    }
    
    if (number is double) {
      return number.toStringAsFixed(2);
    }
    
    return number.toString();
  }
} 