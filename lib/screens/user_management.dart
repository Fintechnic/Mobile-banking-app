import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildProfileDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 300,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.blue.shade200,
                height: 200,
                width: double.infinity,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.menu, color: Colors.black54),
                    Expanded(
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
                            Text('Search', style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ),
                    const Icon(CupertinoIcons.bell, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Container(
              height: 130,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
            ),
          ),
          
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: ClipOval(
                    child: Image.network(
                      'https://i.ibb.co/gTYL6TG/avatar-placeholder.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, size: 60, color: Colors.black45);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Center(
              child: const Text(
                'Mr. A',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 210,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('100', 'Posts'),
                _buildStat('159', 'Friends'),
                _buildStat('1.4K', 'Followers', isBlue: true),
              ],
            ),
          ),
          
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit Details'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.security_outlined, size: 16),
                      label: const Text('Edit Permission'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, {bool isBlue = false}) {
    return Column(
      children: [
        Text(
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoItem('EMAIL', 'einsz.bogatsich@orland.tv'),
        const SizedBox(height: 16),
        
        _buildInfoItem('MOBILE', '0834120411'),
        const SizedBox(height: 16),
        
        _buildActionItem(
          'Reliability',
          '1000',
          Icons.check_box,
          Colors.blue,
        ),
        
        _buildActionItem(
          'Following',
          '340',
          Icons.people_outline,
          Colors.blue,
        ),
        
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.362,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '362.000/1.000.000',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(String label, String value, IconData icon, Color color) {
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
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
