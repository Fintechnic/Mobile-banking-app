import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../utils/responsive_wrapper.dart';
import '../utils/icon_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        primaryColor: const Color(0xFF1A3A6B),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const NotificationSettingsScreen(),
    );
  }
}

class NotificationCategory {
  final String id;
  final String title;
  final List<NotificationSetting> settings;

  NotificationCategory({
    required this.id,
    required this.title,
    required this.settings,
  });

  factory NotificationCategory.fromJson(Map<String, dynamic> json) {
    return NotificationCategory(
      id: json['id'],
      title: json['title'],
      settings: (json['settings'] as List)
          .map((setting) => NotificationSetting.fromJson(setting))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'settings': settings.map((setting) => setting.toJson()).toList(),
    };
  }
}

class NotificationSetting {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  bool isEnabled;

  NotificationSetting({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isEnabled,
  });

  factory NotificationSetting.fromJson(Map<String, dynamic> json) {
    return NotificationSetting(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: IconUtils.getIconFromString(json['icon']),
      isEnabled: json['isEnabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': IconUtils.getStringFromIcon(icon),
      'isEnabled': isEnabled,
    };
  }
}

class NotificationService {
  static const String baseUrl =
      'https://api.example.com'; // Replace with your API URL

  static Future<List<NotificationCategory>> getNotificationSettings() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      return [
        NotificationCategory(
          id: 'important',
          title: 'Important Notice',
          settings: [
            NotificationSetting(
              id: 'transaction',
              title: 'Transaction',
              description:
                  'Changes in wallet balance, transaction status updates.',
              icon: Icons.account_balance_wallet,
              isEnabled: true,
            ),
            NotificationSetting(
              id: 'reminder',
              title: 'Reminder',
              description:
                  'Bill due dates, pending transactions that need to be completed.',
              icon: Icons.notifications_active,
              isEnabled: true,
            ),
            NotificationSetting(
              id: 'alert',
              title: 'Alert',
              description:
                  'Security-related updates, account safety notices, or maintenance notifications.',
              icon: Icons.warning_amber_rounded,
              isEnabled: true,
            ),
            NotificationSetting(
              id: 'service',
              title: 'Service',
              description:
                  'Updates on the status of services you are currently using.',
              icon: Icons.support_agent,
              isEnabled: true,
            ),
          ],
        ),
        NotificationCategory(
          id: 'promotional',
          title: 'Promotional Notifications',
          settings: [
            NotificationSetting(
              id: 'service_promotions',
              title: 'Service Promotions',
              description:
                  'Exclusive offers from the services you frequently use.',
              icon: Icons.local_offer,
              isEnabled: true,
            ),
            NotificationSetting(
              id: 'expiring_offers',
              title: 'Expiring Offers',
              description:
                  'Reminders for vouchers or gift cards that are about to expire.',
              icon: Icons.card_giftcard,
              isEnabled: true,
            ),
            NotificationSetting(
              id: 'games',
              title: 'Games',
              description: 'Updates from Fintechnic\'s in-app games.',
              icon: Icons.videogame_asset,
              isEnabled: false,
            ),
            NotificationSetting(
              id: 'advertisements',
              title: 'Advertisements',
              description: 'Other promotional and advertising notifications.',
              icon: Icons.campaign,
              isEnabled: true,
            ),
          ],
        ),
        NotificationCategory(
          id: 'engagement',
          title: 'Engagement Notifications',
          settings: [
            NotificationSetting(
              id: 'friends',
              title: 'Friends',
              description: 'Interactions with your friends and other users.',
              icon: Icons.people,
              isEnabled: true,
            ),
            NotificationSetting(
              id: 'business_pages',
              title: 'Business Pages',
              description: 'Interactions with Business Pages.',
              icon: Icons.storefront,
              isEnabled: true,
            ),
            NotificationSetting(
              id: 'community',
              title: 'Community',
              description:
                  'Updates from communities and groups on Fintechnic\'s social network.',
              icon: Icons.groups,
              isEnabled: true,
            ),
            NotificationSetting(
              id: 'surveys',
              title: 'Surveys',
              description:
                  'Surveys and feedback requests about services or stores.',
              icon: Icons.rate_review,
              isEnabled: true,
            ),
          ],
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load notification settings: $e');
    }
  }

  static Future<bool> saveNotificationSettings(
      List<NotificationCategory> categories) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      return true;
    } catch (e) {
      throw Exception('Failed to save notification settings: $e');
    }
  }
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<NotificationCategory> _categories = [];
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final categories = await NotificationService.getNotificationSettings();
      setState(() {
        _categories = categories;
        _isLoading = false;
        _hasChanges = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _saveNotificationSettings() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final success = await NotificationService.saveNotificationSettings(_categories);
      setState(() {
        _isSaving = false;
        _hasChanges = false;
      });

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: Color(0xFF1A3A6B),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save settings'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleNotification(String categoryId, String settingId, bool value) {
    setState(() {
      for (var category in _categories) {
        if (category.id == categoryId) {
          for (var setting in category.settings) {
            if (setting.id == settingId) {
              setting.isEnabled = value;
              _hasChanges = true;
              break;
            }
          }
          break;
        }
      }
    });
  }

  void _turnOffAllNotifications() {
    setState(() {
      for (var category in _categories) {
        for (var setting in category.settings) {
          setting.isEnabled = false;
        }
      }
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, isLandscape) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1A3A6B), Color(0xFF2C5299)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: ResponsiveUtils.getResponsivePadding(context),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            if (_hasChanges) {
                              _showUnsavedChangesDialog();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Notification Settings',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.help_outline, color: Colors.white),
                          onPressed: () {
                            _showHelpDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _hasError
                        ? _buildErrorState()
                        : _buildContent(deviceType, isLandscape),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isLandscape ? 12.0 : 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, -3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed:
                      _isSaving || !_hasChanges ? null : _saveNotificationSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3A6B),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: EdgeInsets.symmetric(vertical: isLandscape ? 12.0 : 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Save Settings',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF1A3A6B),
          ),
          SizedBox(height: 16),
          Text(
            'Loading notification settings...',
            style: TextStyle(
              color: Color(0xFF1A3A6B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load notification settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadNotificationSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A6B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(DeviceType deviceType, bool isLandscape) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var category in _categories) ...[
              _buildSectionTitle(category.title),
              const SizedBox(height: 12),
              _buildNotificationSection(category, deviceType, isLandscape),
              SizedBox(height: isLandscape ? 16 : 24),
            ],
            Center(
              child: TextButton(
                onPressed: _turnOffAllNotifications,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1A3A6B),
                ),
                child: Text(
                  'Turn off all notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A6B),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A3A6B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(NotificationCategory category, DeviceType deviceType, bool isLandscape) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: category.settings.asMap().entries.map((entry) {
          final index = entry.key;
          final setting = entry.value;

          return Column(
            children: [
              _buildNotificationItem(
                category.id,
                setting,
                (value) => _toggleNotification(category.id, setting.id, value),
                deviceType,
                isLandscape,
              ),
              if (index < category.settings.length - 1)
                Padding(
                  padding: EdgeInsets.only(
                    left: isLandscape ? 48.0 : 64.0,
                  ),
                  child: Divider(
                    height: 1,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationItem(
    String categoryId,
    NotificationSetting setting,
    Function(bool) onChanged,
    DeviceType deviceType,
    bool isLandscape,
  ) {
    final iconSize = isLandscape ? 36.0 : 40.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 12.0 : 16.0,
        vertical: isLandscape ? 10.0 : 14.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              setting.icon,
              size: isLandscape ? 16 : 20,
              color: const Color(0xFF1A3A6B)
            ),
          ),
          SizedBox(width: isLandscape ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setting.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      isLandscape ? 14 : 16
                    ),
                    color: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  setting.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      isLandscape ? 12 : 14
                    ),
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: deviceType == DeviceType.mobile ? 0.8 : 1.0,
            child: Switch(
              value: setting.isEnabled,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF1A3A6B),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. Do you want to save them before leaving?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveNotificationSettings().then((_) {
                Navigator.of(context).pop();
              });
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Important Notice',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'These notifications are critical for your account security and transaction updates.',
              ),
              SizedBox(height: 12),
              Text(
                'Promotional Notifications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'These are marketing notifications about offers and promotions.',
              ),
              SizedBox(height: 12),
              Text(
                'Engagement Notifications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'These notifications are about social interactions within the app.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
