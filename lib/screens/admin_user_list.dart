import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'admin_user_details.dart';
import '../utils/responsive_utils.dart';

class AdminUserListScreen extends StatefulWidget {
  const AdminUserListScreen({super.key});

  @override
  State<AdminUserListScreen> createState() => _AdminUserListScreenState();
}

class _AdminUserListScreenState extends State<AdminUserListScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String? _searchQuery;
  bool _isSearching = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsers();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUsers(usernameFilter: _searchQuery);
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim().isNotEmpty
          ? _searchController.text.trim()
          : null;
      _isSearching = false;
    });
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadUsers,
                  color: const Color(0xFF1A3A6B),
                  child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      if (userProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
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
                                onPressed: _loadUsers,
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
                        );
                      }
                      
                      final users = userProvider.users;
                      if (users.isEmpty) {
                        return Center(
                          child: Text(
                            _searchQuery == null
                                ? 'No users found'
                                : 'No users found matching "$_searchQuery"',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                // We need to ensure ListView always allows scrolling for RefreshIndicator to work
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final user = users[index];
                                  return _buildUserListItem(user);
                                },
                              ),
                            ),
                            if (userProvider.totalPages > 1)
                              _buildPagination(userProvider),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: ResponsiveUtils.getHeightPercentage(context, 2),
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
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  backgroundColor: Colors.white30,
                  radius: 18,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Manage users and their accounts',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by username',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF1A3A6B)),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          if (_isSearching)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5A8ED0)),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = null;
                });
                _loadUsers();
              },
            ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A6B),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: _performSearch,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserListItem(User user) {
    return Hero(
      tag: 'user_${user.id}',
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (user.id != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminUserDetailsScreen(userId: user.id!),
                  ),
                ).then((_) => _loadUsers());
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: user.isAdmin ? const Color(0xFF1A3A6B) : const Color(0xFF5A8ED0),
                    radius: 22,
                    child: Text(
                      user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1A3A6B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Phone: ${user.phoneNumber ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: user.isAdmin ? const Color(0xFF1A3A6B).withOpacity(0.1) : const Color(0xFF5A8ED0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user.role,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: user.isAdmin ? const Color(0xFF1A3A6B) : const Color(0xFF5A8ED0),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: user.accountLocked
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user.accountStatus,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: user.accountLocked ? Colors.red[700] : Colors.green[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF5A8ED0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPagination(UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: userProvider.hasPreviousPage
                  ? () => userProvider.previousPage(usernameFilter: _searchQuery)
                  : null,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: userProvider.hasPreviousPage
                      ? const Color(0xFF1A3A6B).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_left,
                  color: userProvider.hasPreviousPage
                      ? const Color(0xFF1A3A6B)
                      : Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Page ${userProvider.currentPage + 1} of ${userProvider.totalPages}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3A6B),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: userProvider.hasNextPage
                  ? () => userProvider.nextPage(usernameFilter: _searchQuery)
                  : null,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: userProvider.hasNextPage
                      ? const Color(0xFF1A3A6B).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: userProvider.hasNextPage
                      ? const Color(0xFF1A3A6B)
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 