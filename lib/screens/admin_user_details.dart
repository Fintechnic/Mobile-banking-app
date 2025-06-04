import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import '../utils/role_constants.dart';

class AdminUserDetailsScreen extends StatefulWidget {
  final int userId;

  const AdminUserDetailsScreen({super.key, required this.userId});

  @override
  State<AdminUserDetailsScreen> createState() => _AdminUserDetailsScreenState();
}

class _AdminUserDetailsScreenState extends State<AdminUserDetailsScreen> {
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserDetails();
    });
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  
  Future<void> _loadUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.getUserDetailsById(widget.userId);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserDetails,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Error: ${userProvider.error}',
                          style: TextStyle(color: Colors.red[700]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadUserDetails,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                final user = userProvider.selectedUser;
                if (user == null) {
                  return const Center(child: Text('User not found'));
                }
                
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserHeader(user),
                        const SizedBox(height: 24),
                        _buildUserInfoCard(user),
                        const SizedBox(height: 24),
                        _buildActionButtons(user),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildUserHeader(User user) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: user.isAdmin ? Colors.blue : Colors.green,
              child: Text(
                user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showUpdateRoleDialog(user),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: user.isAdmin ? Colors.blue[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: user.isAdmin ? Colors.blue[400]! : Colors.green[400]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.role,
                            style: TextStyle(
                              color: user.isAdmin ? Colors.blue[800] : Colors.green[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.edit,
                            size: 14,
                            color: user.isAdmin ? Colors.blue[800] : Colors.green[800],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(User user) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildInfoRow('User ID', '${user.id ?? 'N/A'}'),
            _buildInfoRow('Email', user.email),
            _buildInfoRow('Phone Number', user.phoneNumber ?? 'Not provided'),
            _buildInfoRow('Account Status', user.accountStatus,
                isHighlighted: true,
                color: user.accountLocked ? Colors.red : Colors.green),
            _buildInfoRow(
                'Failed Login Attempts', user.failedLoginAttempts.toString()),
            _buildInfoRow('Account Created', user.formattedCreatedAt),
            if (user.lastFailedLogin != null)
              _buildInfoRow('Last Failed Login', user.lastFailedLogin!),
            if (user.activeTokens != null)
              _buildInfoRow(
                  'Active Sessions', '${user.activeTokens!.length}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isHighlighted = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(User user) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.lock_open,
                  label: user.accountLocked ? 'Unlock Account' : 'Account Active',
                  color: user.accountLocked ? Colors.green : Colors.grey,
                  onPressed: user.accountLocked ? () => _unlockAccount(user) : null,
                ),
                _buildActionButton(
                  icon: Icons.password,
                  label: 'Reset Password',
                  color: Colors.blue,
                  onPressed: () => _resetUserPassword(user),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
    );
  }

  Future<void> _unlockAccount(User user) async {
    if (user.username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final success = await userProvider.unlockUserByUsername(user.username);
      
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to unlock account: ${userProvider.error ?? "Unknown error"}'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account unlocked successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh the user details to update the locked status
        _loadUserDetails();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showUpdateRoleDialog(User user) async {
    if (user.id == null) return;
    
    final currentRole = user.role;
    String selectedRole = currentRole;
    
    // List of available roles using constants
    final roles = [RoleConstants.USER, RoleConstants.ADMIN];
    
    debugPrint("Opening update role dialog. Current role: $currentRole");
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Update User Role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current role: $currentRole'),
              const SizedBox(height: 16),
              const Text('Select new role:'),
              const SizedBox(height: 8),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedRole,
                items: roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedRole = value;
                      debugPrint("Role selected: $selectedRole");
                    });
                  }
                },
              ),
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
                if (selectedRole != currentRole) {
                  debugPrint("Updating role from $currentRole to $selectedRole");
                  _updateUserRole(user.id!, selectedRole);
                } else {
                  debugPrint("Role unchanged, not updating");
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserRole(int userId, String newRole) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final success = await userProvider.updateUserRole(userId, newRole);
      
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update user role'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User role updated to $newRole'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetUserPassword(User user) async {
    if (user.id == null) return;
    
    final TextEditingController passwordController = TextEditingController();
    
    final resetType = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: const Text(
          'How would you like to reset the password?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'auto'),
            child: const Text('Auto-generate Password'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'custom'),
            child: const Text('Set Custom Password'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    
    if (resetType == 'cancel' || resetType == null) return;
    
    if (resetType == 'custom') {
      final customPassword = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Set Custom Password'),
          content: TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password cannot be empty'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.pop(context, passwordController.text);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Set Password'),
            ),
          ],
        ),
      );
      
      if (customPassword == null || customPassword.isEmpty) return;
      
      setState(() {
        _isLoading = true;
      });
      
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final success = await userProvider.resetUserPasswordWithCustomPassword(
          user.id!,
          customPassword,
        );
        
        if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to reset password'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successful'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      // Auto-generate password
      setState(() {
        _isLoading = true;
      });
      
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final success = await userProvider.resetUserPassword(user.id!);
        
        if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to reset password'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successful. New password sent to user email.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
} 