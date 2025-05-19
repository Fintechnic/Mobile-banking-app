import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Avatar & Tên Người Dùng
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.person, size: 60, color: Colors.blue.shade700),
          ),
          const SizedBox(height: 12),
          const Text(
            'Mr. A',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Danh sách các mục
          Expanded(
            child: ListView(
              children: [
                _buildProfileOption(
                  context,
                  icon: Icons.lock_outline,
                  title: 'Security',
                  onTap: () {},
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.language,
                  title: 'Languages',
                  onTap: () {},
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.info_outline,
                  title: 'App Information',
                  onTap: () {},
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.support_agent,
                  title: 'Customer Care',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hàm tạo danh sách Profile Option
  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.blue.shade100, // Hiệu ứng chạm
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
            Icon(icon, color: Colors.blue.shade700, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
