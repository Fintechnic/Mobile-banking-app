import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/responsive_utils.dart';
import '../utils/responsive_wrapper.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, isLandscape) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A3A6B), Color(0xFF5A8ED0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/user-management');
                },
              ),
            ],
          ),
          body: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              final username = authProvider.userData?['username'] ?? 'User';
              return Column(
                children: [
                  // Avatar & User Name
                  SizedBox(height: isLandscape ? 16 : 24),
                  CircleAvatar(
                    radius: isLandscape ? 40 : 55,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.person,
                      size: isLandscape ? 40 : 60, 
                      color: const Color(0xFF1A3A6B),
                    ),
                  ),
                  SizedBox(height: isLandscape ? 8 : 12),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, isLandscape ? 18 : 22),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: isLandscape ? 12 : 20),

                  // Option list
                  Expanded(
                    child: ListView(
                      padding: ResponsiveUtils.getResponsivePadding(context),
                      children: [
                        _buildProfileOption(
                          context,
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'My Cards and Accounts',
                          onTap: () {
                            Navigator.pushNamed(context, '/account-card');
                          },
                          isLandscape: isLandscape,
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.lock_outline,
                          title: 'Security',
                          onTap: () {
                            Navigator.pushNamed(context, '/change-password');
                          },
                          isLandscape: isLandscape,
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.notifications_outlined,
                          title: 'Notification Settings',
                          onTap: () {
                            Navigator.pushNamed(context, '/notification-settings');
                          },
                          isLandscape: isLandscape,
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.language,
                          title: 'Languages',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Language settings coming soon')),
                            );
                          },
                          isLandscape: isLandscape,
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.info_outline,
                          title: 'App Information',
                          onTap: () {
                            Navigator.pushNamed(context, '/information');
                          },
                          isLandscape: isLandscape,
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.support_agent,
                          title: 'Customer Care',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Customer care: 1900-9999')),
                            );
                          },
                          isLandscape: isLandscape,
                        ),
                        _buildProfileOption(
                          context,
                          icon: Icons.logout,
                          title: 'Logout',
                          onTap: () {
                            _showLogoutConfirmation(context, authProvider);
                          },
                          isLandscape: isLandscape,
                          isLogout: true,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
        );
      }
    );
  }

  // Profile option item builder
  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isLandscape,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.blue.shade100,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isLandscape ? 4 : 6
        ),
        padding: EdgeInsets.symmetric(
          vertical: isLandscape ? 10 : 14,
          horizontal: 16
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              color: isLogout ? Colors.red : const Color(0xFF1A3A6B), 
              size: isLandscape ? 22 : 26
            ),
            SizedBox(width: isLandscape ? 12 : 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    isLandscape ? 14 : 16
                  ),
                  fontWeight: FontWeight.w500,
                  color: isLogout ? Colors.red : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: isLandscape ? 14 : 18, 
              color: Colors.grey
            ),
          ],
        ),
      ),
    );
  }
  
  void _showLogoutConfirmation(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

