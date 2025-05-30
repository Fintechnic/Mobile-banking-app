import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF1A3A6B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5A8ED0),
          primary: const Color(0xFF1A3A6B),
        ),
      ),
      home: const ProfileSettingsScreen(),
    );
  }
}

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> with SingleTickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = true;
  bool _darkModeEnabled = false;
  
 
  late AnimationController _animationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _profileAnimation;
  final List<Animation<double>> _sectionAnimations = [];
  
  
  int? _tappedItemIndex;
  
  @override
  void initState() {
    super.initState();
    
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    
    _headerAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    
    
    _profileAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    );
    
    
    for (int i = 0; i < 3; i++) {
      _sectionAnimations.add(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.4 + (i * 0.1),
            0.7 + (i * 0.1),
            curve: Curves.easeOut,
          ),
        ),
      );
    }
    
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A3A6B),
                  const Color(0xFF5A8ED0).withValues(alpha: _headerAnimation.value),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Transform.translate(
                    offset: Offset(-100 * (1 - _headerAnimation.value), 0),
                    child: Opacity(
                      opacity: _headerAnimation.value,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                
                                _animationController.reverse().then((_) {
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(0, 100 * (1 - _headerAnimation.value)),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: ListView(
                          padding: const EdgeInsets.all(20.0),
                          children: [
                            const SizedBox(height: 20),
                            
                            Transform.scale(
                              scale: 0.8 + (0.2 * _profileAnimation.value),
                              child: Opacity(
                                opacity: _profileAnimation.value,
                                child: _buildProfileSection(),
                              ),
                            ),
                            const SizedBox(height: 30),
                            
                            
                            _buildAnimatedSection(
                              'Account Settings',
                              [
                                _buildSettingItemData(
                                  icon: Icons.person_outline,
                                  title: 'Personal Information',
                                  subtitle: 'Manage your personal details',
                                ),
                                _buildSettingItemData(
                                  icon: Icons.lock_outline,
                                  title: 'Security',
                                  subtitle: 'Change password, PIN',
                                ),
                                _buildSettingItemData(
                                  icon: Icons.credit_card,
                                  title: 'Payment Methods',
                                  subtitle: 'Manage your cards and accounts',
                                ),
                                _buildSettingItemData(
                                  icon: Icons.notifications_outlined,
                                  title: 'Notifications',
                                  subtitle: 'Manage your notification preferences',
                                  hasSwitch: true,
                                  switchValue: _notificationsEnabled,
                                  onSwitchChanged: (value) {
                                    setState(() {
                                      _notificationsEnabled = value;
                                    });
                                  },
                                ),
                              ],
                              _sectionAnimations[0],
                              0,
                            ),
                            
                            const SizedBox(height: 30),
                            
                            
                            _buildAnimatedSection(
                              'App Settings',
                              [
                                _buildSettingItemData(
                                  icon: Icons.language,
                                  title: 'Language',
                                  subtitle: 'English',
                                ),
                                _buildSettingItemData(
                                  icon: Icons.fingerprint,
                                  title: 'Biometric Authentication',
                                  subtitle: 'Use fingerprint to login',
                                  hasSwitch: true,
                                  switchValue: _biometricEnabled,
                                  onSwitchChanged: (value) {
                                    setState(() {
                                      _biometricEnabled = value;
                                    });
                                  },
                                ),
                                _buildSettingItemData(
                                  icon: Icons.dark_mode_outlined,
                                  title: 'Dark Mode',
                                  subtitle: 'Change app appearance',
                                  hasSwitch: true,
                                  switchValue: _darkModeEnabled,
                                  onSwitchChanged: (value) {
                                    setState(() {
                                      _darkModeEnabled = value;
                                    });
                                  },
                                ),
                              ],
                              _sectionAnimations[1],
                              4,
                            ),
                            
                            const SizedBox(height: 30),
                            
                            
                            _buildAnimatedSection(
                              'About',
                              [
                                _buildSettingItemData(
                                  icon: Icons.info_outline,
                                  title: 'About FINTECHNIC',
                                  subtitle: 'Learn more about our bank',
                                ),
                                _buildSettingItemData(
                                  icon: Icons.help_outline,
                                  title: 'Help & Support',
                                  subtitle: 'Get help with your account',
                                ),
                                _buildSettingItemData(
                                  icon: Icons.privacy_tip_outlined,
                                  title: 'Privacy Policy',
                                  subtitle: 'Read our privacy policy',
                                ),
                                _buildSettingItemData(
                                  icon: Icons.description_outlined,
                                  title: 'Terms & Conditions',
                                  subtitle: 'Read our terms and conditions',
                                ),
                              ],
                              _sectionAnimations[2],
                              7,
                            ),
                            
                            const SizedBox(height: 30),
                            
                            
                            _buildAnimatedLogoutButton(),
                            
                            const SizedBox(height: 20),
                            
                            
                            Opacity(
                              opacity: _sectionAnimations[2].value,
                              child: Center(
                                child: Text(
                                  'App Version 1.0.0',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.95, end: 1.05),
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/150?img=8'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mr. A',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'uit@gmail.com',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return InkWell(
              onTap: () {
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit profile tapped'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              onHover: (hovering) {
                
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF93B5E1).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    if (value > 0.5)
                      BoxShadow(
                        color: const Color(0xFF5A8ED0).withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                  ],
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Color(0xFF5A8ED0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedSection(String title, List<Map<String, dynamic>> items, Animation<double> animation, int startIndex) {
    return Opacity(
      opacity: animation.value,
      child: Transform.translate(
        offset: Offset(0, 50 * (1 - animation.value)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(title),
            const SizedBox(height: 15),
            ...items.asMap().entries.map((entry) {
              final int index = entry.key;
              final Map<String, dynamic> item = entry.value;
              
              
              final double delay = index * 0.1;
              final Animation<double> itemAnimation = CurvedAnimation(
                parent: animation,
                curve: Interval(delay, 1.0, curve: Curves.easeOut),
              );
              
              return Opacity(
                opacity: itemAnimation.value,
                child: Transform.translate(
                  offset: Offset(100 * (1 - itemAnimation.value), 0),
                  child: _buildSettingItem(
                    icon: item['icon'],
                    title: item['title'],
                    subtitle: item['subtitle'],
                    hasSwitch: item['hasSwitch'] ?? false,
                    switchValue: item['switchValue'] ?? false,
                    onSwitchChanged: item['onSwitchChanged'],
                    index: startIndex + index,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF1A3A6B),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Map<String, dynamic> _buildSettingItemData({
    required IconData icon,
    required String title,
    required String subtitle,
    bool hasSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
  }) {
    return {
      'icon': icon,
      'title': title,
      'subtitle': subtitle,
      'hasSwitch': hasSwitch,
      'switchValue': switchValue,
      'onSwitchChanged': onSwitchChanged,
    };
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool hasSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    required int index,
  }) {
    return GestureDetector(
      onTapDown: (_) {
        if (!hasSwitch) {
          setState(() {
            _tappedItemIndex = index;
          });
        }
      },
      onTapUp: (_) {
        if (!hasSwitch) {
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              setState(() {
                _tappedItemIndex = null;
              });
            }
          });
          
         
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title tapped'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      onTapCancel: () {
        if (!hasSwitch) {
          setState(() {
            _tappedItemIndex = null;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: _tappedItemIndex == index ? const Color(0xFFF5F9FF) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: _tappedItemIndex == index 
                ? const Color(0xFF5A8ED0).withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: _tappedItemIndex == index 
            ? Border.all(color: const Color(0xFF5A8ED0).withValues(alpha: 0.3), width: 1)
            : null,
        ),
        child: Row(
          children: [
           
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF93B5E1).withAlpha((0.2 * 255).toInt()),
                    shape: BoxShape.circle,
                    boxShadow: _tappedItemIndex == index 
                      ? [
                          BoxShadow(
                            color: const Color(0xFF5A8ED0).withValues(alpha: 0.3 * value),
                            blurRadius: 8 * value,
                            spreadRadius: 1 * value,
                          ),
                        ]
                      : null,
                  ),
                  child: Icon(
                    icon, 
                    color: const Color(0xFF1A3A6B), 
                    size: 20 + (2 * (_tappedItemIndex == index ? 1 : 0)),
                  ),
                );
              },
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: _tappedItemIndex == index 
                        ? const Color(0xFF1A3A6B)
                        : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600, 
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (hasSwitch)
              _buildAnimatedSwitch(switchValue, onSwitchChanged)
            else
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.chevron_right, 
                  color: _tappedItemIndex == index 
                    ? const Color(0xFF5A8ED0)
                    : Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSwitch(bool value, ValueChanged<bool>? onChanged) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * animValue),
          child: Switch(
            value: value,
            onChanged: (newValue) {
              if (onChanged != null) {
              
                HapticFeedback.lightImpact();
                onChanged(newValue);
              }
            },
            activeColor: const Color(0xFF5A8ED0),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogoutButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
       
                  HapticFeedback.mediumImpact();
                  
   
                  showDialog(
                    context: context,
                    builder: (context) => _buildAnimatedDialog(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3A6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'LOGOUT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDialog() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Logout Confirmation'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        );
      },
    );
  }
}

