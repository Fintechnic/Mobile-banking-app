import 'package:flutter/material.dart';
import 'package:fintechnic/services/auth_service.dart';
import 'package:fintechnic/providers/stats_provider.dart';
import 'package:provider/provider.dart';
import 'admin_topup.dart';
import 'admin_user_list.dart';
import 'admin_transaction_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AuthService _authService = AuthService();
  String _username = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    
    // Schedule stats loading after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshStats();
    });
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
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.indigo[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStats,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.logout(_username);
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWelcomeSection(),
                            const SizedBox(height: 12),
                            _buildSystemStatsSection(),
                            const SizedBox(height: 12),
                            _buildFeaturesGrid(),
                            // Add extra space at the bottom to avoid overflow
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      color: Colors.indigo[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.indigo[100],
              child: Icon(
                Icons.admin_panel_settings,
                size: 22,
                color: Colors.indigo[800],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome, Admin $_username',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Manage your system and users',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.indigo[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatsSection() {
    return Consumer<StatsProvider>(
      builder: (context, statsProvider, child) {
        final isStatsLoading = statsProvider.isLoading;
        final hasError = statsProvider.error != null;
        final stats = statsProvider.systemStats;
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                      ),
                    ),
                    if (isStatsLoading)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (hasError)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Failed to load statistics',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 24,
                          child: ElevatedButton(
                            onPressed: _refreshStats,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              minimumSize: Size.zero,
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            child: const Text('Retry'),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (stats == null && !isStatsLoading)
                  const Center(
                    child: Text(
                      'No statistics available',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                else if (!isStatsLoading)
                  _buildSystemStatsGrid(stats!),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSystemStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.8,
      children: [
        _buildStatCard(
          'Total Users',
          '${stats['totalUsers'] ?? 0}',
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          'Total Transactions',
          '${stats['totalTransactions'] ?? 0}',
          Icons.swap_horiz,
          Colors.green,
        ),
        _buildStatCard(
          'Total Balance',
          '\$${_formatNumber(stats['totalBalance'] ?? 0)}',
          Icons.account_balance_wallet,
          Colors.amber,
        ),
        _buildStatCard(
          'Average Balance',
          '\$${_formatNumber(stats['averageBalance'] ?? 0)}',
          Icons.bar_chart,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color[700],
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color[700],
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.3,
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color[50]!, color[100]!],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: color[100],
                radius: 20,
                child: Icon(
                  icon,
                  size: 20,
                  color: color[700],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color[800],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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