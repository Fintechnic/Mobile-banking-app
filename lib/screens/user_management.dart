import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const UserProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// User model
class User {
  final String name;
  final String email;
  final String mobile;
  final String avatarUrl;
  final int posts;
  final int friends;
  final int followers;
  final int reliability;
  final int following;
  final double paidOutLimit;
  final double maxPaidOutLimit;

  User({
    required this.name,
    required this.email,
    required this.mobile,
    required this.avatarUrl,
    required this.posts,
    required this.friends,
    required this.followers,
    required this.reliability,
    required this.following,
    required this.paidOutLimit,
    required this.maxPaidOutLimit,
  });

  // Create a copy of the user with updated fields
  User copyWith({
    String? name,
    String? email,
    String? mobile,
    String? avatarUrl,
    int? posts,
    int? friends,
    int? followers,
    int? reliability,
    int? following,
    double? paidOutLimit,
    double? maxPaidOutLimit,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      posts: posts ?? this.posts,
      friends: friends ?? this.friends,
      followers: followers ?? this.followers,
      reliability: reliability ?? this.reliability,
      following: following ?? this.following,
      paidOutLimit: paidOutLimit ?? this.paidOutLimit,
      maxPaidOutLimit: maxPaidOutLimit ?? this.maxPaidOutLimit,
    );
  }
}

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  User? _user;
  bool _isFollowing = true;
  bool _isEditing = false;

  // Controllers for editing
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Initialize controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();

    // Load user data
    _loadUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  // Load user data with simulated network delay
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate fetching user data
      final user = User(
        name: 'Mr. A',
        email: 'einsz.bogatsich@orland.tv',
        mobile: '0834120411',
        avatarUrl: 'https://i.ibb.co/gTYL6TG/avatar-placeholder.png',
        posts: 100,
        friends: 159,
        followers: 1400,
        reliability: 1000,
        following: 340,
        paidOutLimit: 362000,
        maxPaidOutLimit: 1000000,
      );

      // Update controllers
      _nameController.text = user.name;
      _emailController.text = user.email;
      _mobileController.text = user.mobile;

      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });

        // Start animations
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load user data. Please try again.';
        });
      }
    }
  }

  // Toggle follow status
  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_user != null) {
        _user = _user!.copyWith(
          followers: _isFollowing ? _user!.followers + 1 : _user!.followers - 1,
        );
      }
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing
            ? 'You are now following Mr. A'
            : 'You unfollowed Mr. A'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Toggle edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;

      // Reset controllers if canceling edit
      if (!_isEditing && _user != null) {
        _nameController.text = _user!.name;
        _emailController.text = _user!.email;
        _mobileController.text = _user!.mobile;
      }
    });
  }

  // Save user details
  Future<void> _saveUserDetails() async {
    if (_user == null) return;

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Update user with new values
      final updatedUser = _user!.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        mobile: _mobileController.text,
      );

      if (mounted) {
        setState(() {
          _user = updatedUser;
          _isLoading = false;
          _isEditing = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Show permissions dialog
  void _showPermissionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Permissions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPermissionSwitch('View profile', true),
            _buildPermissionSwitch('Edit profile', true),
            _buildPermissionSwitch('View friends', true),
            _buildPermissionSwitch('Post content', false),
            _buildPermissionSwitch('Admin access', false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Permissions updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Build permission switch
  Widget _buildPermissionSwitch(String label, bool initialValue) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool value = initialValue;
        return SwitchListTile(
          title: Text(label),
          value: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
          },
          dense: true,
        );
      },
    );
  }

  // Show search dialog
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search'),
        content: const TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search users, posts, etc.',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search feature coming soon')),
              );
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  // Show notifications
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              'John liked your post',
              '2 hours ago',
              Icons.favorite,
              Colors.red,
            ),
            _buildNotificationItem(
              'Sarah commented on your photo',
              '5 hours ago',
              Icons.comment,
              Colors.blue,
            ),
            _buildNotificationItem(
              'New friend request from Mike',
              '1 day ago',
              Icons.person_add,
              Colors.green,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  // Build notification item
  Widget _buildNotificationItem(
      String text, String time, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(text),
      subtitle: Text(time),
      dense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _user == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading profile...'),
            ],
          ),
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUserData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildProfileDetails(),
              ),
            ],
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_user == null) return const SizedBox.shrink();

    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: Colors.blue.shade200,
                height: 200,
                width: double.infinity,
                curve: Curves.easeInOut,
              ),
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // App bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.menu, color: Colors.black54),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showSearchDialog,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Icon(Icons.search, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text('Search',
                                  style:
                                      TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showNotifications,
                      child: const Icon(CupertinoIcons.bell,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // White rounded container
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      height: 130,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Profile picture
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Center(
                    child: Hero(
                      tag: 'profile_avatar',
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: Image.network(
                              _user!.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person,
                                    size: 60, color: Colors.black45);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Name
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Center(
                    child: _isEditing
                        ? SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _nameController,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          )
                        : Text(
                            _user!.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),

          // Stats
          Positioned(
            top: 210,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value * 0.5),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(_user!.posts.toString(), 'Posts'),
                        _buildStat(_user!.friends.toString(), 'Friends'),
                        GestureDetector(
                          onTap: _toggleFollow,
                          child: _buildStat(
                            _formatNumber(_user!.followers),
                            'Followers',
                            isBlue: true,
                            showAnimation: _isFollowing,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Action buttons
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value * 0.3),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(
                                _isEditing ? Icons.save : Icons.edit,
                                size: 16,
                              ),
                              label: Text(_isEditing ? 'Save' : 'Edit Details'),
                              onPressed: _isEditing
                                  ? _saveUserDetails
                                  : _toggleEditMode,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black54,
                                backgroundColor: Colors.white,
                                elevation: 0,
                                side: BorderSide(color: Colors.grey.shade300),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon:
                                  const Icon(Icons.security_outlined, size: 16),
                              label: const Text('Edit Permission'),
                              onPressed: _showPermissionsDialog,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black54,
                                backgroundColor: Colors.white,
                                elevation: 0,
                                side: BorderSide(color: Colors.grey.shade300),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
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
    );
  }

  Widget _buildStat(String value, String label,
      {bool isBlue = false, bool showAnimation = false}) {
    return Column(
      children: [
        showAnimation
            ? TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isBlue ? Colors.blue : Colors.black87,
                  ),
                ),
              )
            : Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isBlue ? Colors.blue : Colors.black87,
                ),
              ),
        Text(
          label,
          style: TextStyle(
            color: isBlue ? Colors.blue : Colors.black54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetails() {
    if (_user == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value * 0.2),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoItem(
                  'EMAIL',
                  _user!.email,
                  isEditing: _isEditing,
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                _buildInfoItem(
                  'MOBILE',
                  _user!.mobile,
                  isEditing: _isEditing,
                  controller: _mobileController,
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  'Reliability',
                  _user!.reliability.toString(),
                  Icons.check_box,
                  Colors.blue,
                ),
                _buildActionItem(
                  'Following',
                  _user!.following.toString(),
                  Icons.people_outline,
                  Colors.blue,
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PAID OUT LIMIT',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: _user!.paidOutLimit / _user!.maxPaidOutLimit,
                          ),
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                                minHeight: 8,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_formatNumber(_user!.paidOutLimit)}/${_formatNumber(_user!.maxPaidOutLimit)}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(
    String label,
    String value, {
    bool isEditing = false,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        isEditing && controller != null
            ? TextField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            : Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
      ],
    );
  }

  Widget _buildActionItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(num number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
