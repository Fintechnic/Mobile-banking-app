import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: const BillPaymentScreen(),
    );
  }
}

// Data models
class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class Bill {
  final String id;
  final String serviceId;
  final String serviceName;
  final IconData serviceIcon;
  final String accountNumber;
  final double amount;
  final DateTime dueDate;
  final bool isPaid;

  Bill({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceIcon,
    required this.accountNumber,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      serviceIcon: _getIconFromString(json['serviceIcon']),
      accountNumber: json['accountNumber'],
      amount: json['amount'].toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      isPaid: json['isPaid'] ?? false,
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'bolt':
        return Icons.bolt;
      case 'water_drop_outlined':
        return Icons.water_drop_outlined;
      case 'tv':
        return Icons.tv;
      case 'smartphone':
        return Icons.smartphone;
      case 'school':
        return Icons.school;
      case 'wifi':
        return Icons.wifi;
      default:
        return Icons.receipt_long;
    }
  }
}


class BillService {
  static const String baseUrl = 'https://api.example.com'; // Replace with your API URL
  
  
  static Future<List<ServiceCategory>> getServiceCategories() async {
    try {
      
      await Future.delayed(const Duration(milliseconds: 800));
    
      return [
        ServiceCategory(
          id: 'electricity',
          name: 'Electricity',
          icon: Icons.bolt,
          color: const Color(0xFF1A3A6B),
        ),
        ServiceCategory(
          id: 'water',
          name: 'Water',
          icon: Icons.water_drop_outlined,
          color: const Color(0xFF1A3A6B),
        ),
        ServiceCategory(
          id: 'cable',
          name: 'Cable TV',
          icon: Icons.tv,
          color: const Color(0xFF1A3A6B),
        ),
        ServiceCategory(
          id: 'mobile',
          name: 'Mobile phone',
          icon: Icons.smartphone,
          color: const Color(0xFF1A3A6B),
        ),
        ServiceCategory(
          id: 'tuition',
          name: 'Tuition',
          icon: Icons.school,
          color: const Color(0xFF1A3A6B),
        ),
        ServiceCategory(
          id: 'internet',
          name: 'Internet',
          icon: Icons.wifi,
          color: const Color(0xFF1A3A6B),
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load service categories: $e');
    }
  }
  
  
  static Future<List<Bill>> getUserBills() async {
    try {
      
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        Bill(
          id: 'bill1',
          serviceId: 'electricity',
          serviceName: 'Electricity',
          serviceIcon: Icons.bolt,
          accountNumber: 'EL-123456789',
          amount: 78.50,
          dueDate: DateTime.now().add(const Duration(days: 5)),
        ),
        Bill(
          id: 'bill2',
          serviceId: 'internet',
          serviceName: 'Internet',
          serviceIcon: Icons.wifi,
          accountNumber: 'IN-987654321',
          amount: 45.00,
          dueDate: DateTime.now().add(const Duration(days: 10)),
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load user bills: $e');
    }
  }
  
  
  static Future<bool> addNewBill(String serviceId) async {
    try {
     
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('Failed to add new bill: $e');
    }
  }
}

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  bool _isLoadingServices = true;
  bool _isLoadingBills = true;
  bool _hasServicesError = false;
  bool _hasBillsError = false;
  List<ServiceCategory> _services = [];
  List<Bill> _bills = [];
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _loadServices();
    _loadBills();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoadingServices = true;
      _hasServicesError = false;
    });

    try {
      final services = await BillService.getServiceCategories();
      setState(() {
        _services = services;
        _isLoadingServices = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingServices = false;
        _hasServicesError = true;
      });
    }
  }

  Future<void> _loadBills() async {
    setState(() {
      _isLoadingBills = true;
      _hasBillsError = false;
    });

    try {
      final bills = await BillService.getUserBills();
      setState(() {
        _bills = bills;
        _isLoadingBills = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBills = false;
        _hasBillsError = true;
      });
    }
  }

  Future<void> _addNewBill(String serviceId) async {
    try {
      
      _showLoadingDialog();
      
      final success = await BillService.addNewBill(serviceId);
      
     
      Navigator.of(context).pop();
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bill added successfully'),
            backgroundColor: Color(0xFF1A3A6B),
          ),
        );
        
        
        _loadBills();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add bill'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing...'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A3A6B), Color(0xFF93B5E1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Bill payment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBookmarked = !_isBookmarked;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFFB3D1F2),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        
                        RefreshIndicator(
                          onRefresh: _loadData,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Add new',
                                    style: TextStyle(
                                      color: Color(0xFF5A8ED0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  _isLoadingServices
                                      ? _buildLoadingServices()
                                      : _hasServicesError
                                          ? _buildServicesError()
                                          : _buildServicesGrid(),
                                  const SizedBox(height: 30),
                                  const Text(
                                    'My bills',
                                    style: TextStyle(
                                      color: Color(0xFF5A8ED0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  
                                  _isLoadingBills
                                      ? _buildLoadingBills()
                                      : _hasBillsError
                                          ? _buildBillsError()
                                          : _buildBillsList(),
                                  
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingServices() {
    return SizedBox(
      height: 160,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A3A6B)),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading services...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesError() {
    return SizedBox(
      height: 160,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text(
              'Failed to load services',
              style: TextStyle(color: Colors.grey[800]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadServices,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A6B),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid() {

    final rows = <List<ServiceCategory>>[];
    for (var i = 0; i < _services.length; i += 3) {
      final end = i + 3 <= _services.length ? i + 3 : _services.length;
      rows.add(_services.sublist(i, end));
    }

    return Column(
      children: rows.map((rowServices) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowServices.map((service) {
              return _buildServiceItem(
                icon: service.icon,
                label: service.name,
                color: service.color,
                onTap: () => _addNewBill(service.id),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingBills() {
    return Column(
      children: [
        _buildShimmerBill(),
        const SizedBox(height: 15),
        _buildShimmerBill(),
      ],
    );
  }

  Widget _buildShimmerBill() {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 120,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 180,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 30,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsError() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text(
              'Failed to load bills',
              style: TextStyle(color: Colors.red.shade800),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadBills,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A6B),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillsList() {
    if (_bills.isEmpty) {
      return Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long, color: Colors.grey.shade400, size: 40),
              const SizedBox(height: 8),
              Text(
                'No bills found',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                'Add a new bill from the services above',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _bills.map((bill) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildBillItem(bill),
        );
      }).toList(),
    );
  }

  Widget _buildBillItem(Bill bill) {
    final daysLeft = bill.dueDate.difference(DateTime.now()).inDays;
    
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A6B).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Icon(bill.serviceIcon, color: const Color(0xFF1A3A6B), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.serviceName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Account: ${bill.accountNumber}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                Text(
                  'Due in $daysLeft days',
                  style: TextStyle(
                    color: daysLeft < 3 ? Colors.red : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () {
                // Handle pay button
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text('\$${bill.amount.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.black87, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}