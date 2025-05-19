import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintechnic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFDCEAF9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFDCEAF9),
          elevation: 0,
        ),
      ),
      home: const InformationScreen(),
    );
  }
}


class AppInfo {
  final String version;
  final String buildNumber;
  
  AppInfo({required this.version, required this.buildNumber});
  
  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      version: json['version'] ?? 'Unknown',
      buildNumber: json['buildNumber'] ?? 'Unknown',
    );
  }
}

class InfoLink {
  final String title;
  final String url;
  
  InfoLink({required this.title, required this.url});
  
  factory InfoLink.fromJson(Map<String, dynamic> json) {
    return InfoLink(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class CompanyInfo {
  final String description;
  
  CompanyInfo({required this.description});
  
  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      description: json['description'] ?? '',
    );
  }
}


class ApiService {
  static const String baseUrl = 'https://api.example.com'; // Replace with your API URL
  
  static Future<AppInfo> getAppInfo() async {
    try {
      
      await Future.delayed(const Duration(seconds: 1));
      
     
      return AppInfo(
        version: '1.x.4.x',
        buildNumber: '1234',
      );
    } catch (e) {
      throw Exception('Failed to load app info: $e');
    }
  }
  
  static Future<List<InfoLink>> getLegalLinks() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      
      return [
        InfoLink(title: 'Terms & Conditions', url: 'https://example.com/terms'),
        InfoLink(title: 'Privacy Policy', url: 'https://example.com/privacy'),
        InfoLink(title: 'Operating Regulations', url: 'https://example.com/regulations'),
      ];
    } catch (e) {
      throw Exception('Failed to load legal links: $e');
    }
  }
  
  static Future<List<InfoLink>> getSocialLinks() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      
      // Mock data
      return [
        InfoLink(title: 'Vote for Fintechnic', url: 'https://example.com/vote'),
        InfoLink(title: 'Fintechnic on Facebook', url: 'https://facebook.com/fintechnic'),
        InfoLink(title: 'Website', url: 'https://fintechnic.com'),
      ];
    } catch (e) {
      throw Exception('Failed to load social links: $e');
    }
  }
  
  static Future<CompanyInfo> getCompanyInfo() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      
      // Mock data
      return CompanyInfo(
        description: '(information about the company)',
      );
    } catch (e) {
      throw Exception('Failed to load company info: $e');
    }
  }
}

// Dynamic Information Screen
class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  late Future<AppInfo> _appInfoFuture;
  late Future<List<InfoLink>> _legalLinksFuture;
  late Future<List<InfoLink>> _socialLinksFuture;
  late Future<CompanyInfo> _companyInfoFuture;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  void _loadData() {
    _appInfoFuture = ApiService.getAppInfo();
    _legalLinksFuture = ApiService.getLegalLinks();
    _socialLinksFuture = ApiService.getSocialLinks();
    _companyInfoFuture = ApiService.getCompanyInfo();
  }
  
  void _refreshData() {
    setState(() {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDCEAF9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Information',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                
                _buildAppInfoSection(),
                
                const SizedBox(height: 16),
                
                
                _buildLegalLinksSection(),
                
                const SizedBox(height: 16),
                
                
                _buildSocialLinksSection(),
                
                const SizedBox(height: 24),
                
                
                _buildCompanyInfoSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppInfoSection() {
    return FutureBuilder<AppInfo>(
      future: _appInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard(height: 180);
        } else if (snapshot.hasError) {
          return _buildErrorCard('Failed to load app info');
        } else if (snapshot.hasData) {
          final appInfo = snapshot.data!;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'F',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'version ${appInfo.version} build ${appInfo.buildNumber}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          );
        } else {
          return _buildErrorCard('No app info available');
        }
      },
    );
  }
  
  Widget _buildLegalLinksSection() {
    return FutureBuilder<List<InfoLink>>(
      future: _legalLinksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard(height: 180);
        } else if (snapshot.hasError) {
          return _buildErrorCard('Failed to load legal information');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final links = snapshot.data!;
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                for (int i = 0; i < links.length; i++) ...[
                  _buildInfoLink(links[i].title, onTap: () {
                    _handleLinkTap(links[i]);
                  }),
                  if (i < links.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          );
        } else {
          return _buildErrorCard('No legal information available');
        }
      },
    );
  }
  
  Widget _buildSocialLinksSection() {
    return FutureBuilder<List<InfoLink>>(
      future: _socialLinksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard(height: 180);
        } else if (snapshot.hasError) {
          return _buildErrorCard('Failed to load social links');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final links = snapshot.data!;
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                for (int i = 0; i < links.length; i++) ...[
                  _buildInfoLink(links[i].title, onTap: () {
                    _handleLinkTap(links[i]);
                  }),
                  if (i < links.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          );
        } else {
          return _buildErrorCard('No social links available');
        }
      },
    );
  }
  
  Widget _buildCompanyInfoSection() {
    return FutureBuilder<CompanyInfo>(
      future: _companyInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text(
            'Failed to load company information',
            style: TextStyle(color: Colors.red),
          );
        } else if (snapshot.hasData) {
          return Center(
            child: Text(
              snapshot.data!.description,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
  
  Widget _buildInfoLink(String title, {required VoidCallback onTap}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
  
  Widget _buildLoadingCard({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  Widget _buildErrorCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _refreshData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  void _handleLinkTap(InfoLink link) {
    // In a real app, you would use url_launcher package to open the URL
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: ${link.title} (${link.url})'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}