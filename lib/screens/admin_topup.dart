import 'package:flutter/material.dart';
import 'package:fintechnic/services/wallet_service.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/responsive_utils.dart';

class AdminTopupScreen extends StatefulWidget {
  const AdminTopupScreen({super.key});

  @override
  State<AdminTopupScreen> createState() => _AdminTopupScreenState();
}

class _AdminTopupScreenState extends State<AdminTopupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final WalletService _walletService = WalletService();
  final _currencyFormatter = NumberFormat("#,##0.00", "en_US");
  
  final _phoneNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  Map<String, dynamic>? _lastTopupResult;
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
  }
  
  @override
  void dispose() {
    _phoneNumberController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _processTopup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
      _lastTopupResult = null;
    });
    
    try {
      final phoneNumber = _phoneNumberController.text.trim();
      final amount = double.tryParse(_amountController.text.trim());
      final note = _noteController.text.trim();
      
      if (phoneNumber.isEmpty) {
        setState(() {
          _errorMessage = 'Phone number is required';
          _isLoading = false;
        });
        return;
      }
      
      if (amount == null || amount <= 0) {
        setState(() {
          _errorMessage = 'Please enter a valid amount';
          _isLoading = false;
        });
        return;
      }
      
      // Process topup using the API
      final response = await _walletService.adminTopUp(
        phoneNumber,
        amount,
        description: note.isNotEmpty ? note : null,
      );
      
      if (response.containsKey("error")) {
        setState(() {
          _errorMessage = response["error"] ?? 'Phone number not found';
          _isLoading = false;
        });
        return;
      }
      
      setState(() {
        _lastTopupResult = response;
        _successMessage = 'Successfully topped up \$${_currencyFormatter.format(amount)} to user ${response['username'] ?? 'user'}';
        _isLoading = false;
        // Clear form
        _amountController.clear();
        _noteController.clear();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  Future<void> _resetForm() async {
    setState(() {
      _phoneNumberController.clear();
      _amountController.clear();
      _noteController.clear();
      _errorMessage = null;
      _successMessage = null;
      _lastTopupResult = null;
    });
    return Future.delayed(const Duration(milliseconds: 300)); // Small delay for better UX
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _resetForm,
                  color: const Color(0xFF1A3A6B),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopupForm(),
                        if (_lastTopupResult != null) ...[
                          const SizedBox(height: 24),
                          _buildTopupResult(),
                        ],
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          _buildErrorMessage(),
                        ],
                        if (_successMessage != null) ...[
                          const SizedBox(height: 16),
                          _buildSuccessMessage(),
                        ],
                        const SizedBox(height: 24),
                        // Add extra space for pull-to-refresh on small content
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        'Top-up Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Add funds to user accounts',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopupForm() {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Money to User Account',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A3A6B),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1A3A6B), width: 2),
                ),
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF1A3A6B)),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount (\$)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1A3A6B), width: 2),
                ),
                prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF1A3A6B)),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1A3A6B), width: 2),
                ),
                prefixIcon: const Icon(Icons.note, color: Color(0xFF1A3A6B)),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _processTopup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3A6B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: _isLoading
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('Processing...'),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.account_balance_wallet),
                          const SizedBox(width: 12),
                          Text('Process Top-up'),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTopupResult() {
    final result = _lastTopupResult!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A6B).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1A3A6B).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top-up Result',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A3A6B),
            ),
          ),
          const SizedBox(height: 16),
          _buildResultRow('Username', result['username'] ?? 'Unknown'),
          _buildResultRow('Phone', result['phone'] ?? 'Unknown'),
          _buildResultRow('Amount', '\$${_currencyFormatter.format(result['amount'] ?? 0)}'),
          _buildResultRow('Transaction ID', result['transactionId'] ?? 'Unknown'),
          _buildResultRow('Time', result['timestamp'] != null 
            ? DateFormat('MMM dd, yyyy HH:mm').format(DateTime.parse(result['timestamp'])) 
            : 'Unknown'
          ),
          _buildResultRow('Status', 'Success'),
        ],
      ),
    );
  }
  
  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A8ED0),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1A3A6B),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade700,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSuccessMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green.shade700,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _successMessage!,
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 