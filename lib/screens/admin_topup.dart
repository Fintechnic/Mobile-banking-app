import 'package:flutter/material.dart';
import 'package:fintechnic/services/wallet_service.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AdminTopupScreen extends StatefulWidget {
  const AdminTopupScreen({super.key});

  @override
  State<AdminTopupScreen> createState() => _AdminTopupScreenState();
}

class _AdminTopupScreenState extends State<AdminTopupScreen> {
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
  
  @override
  void dispose() {
    _phoneNumberController.dispose();
    _amountController.dispose();
    _noteController.dispose();
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top-up Management'),
        backgroundColor: Colors.amber[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
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
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return const Text(
      'Add Money to User Account',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  
  Widget _buildTopupForm() {
    return Form(
      key: _formKey,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top-up Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
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
                decoration: const InputDecoration(
                  labelText: 'Amount (\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
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
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _processTopup,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.account_balance_wallet),
                  label: const Text('Process Top-up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
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
  
  Widget _buildTopupResult() {
    final result = _lastTopupResult!;
    
    return Card(
      elevation: 2,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildUserInfoRow('Username', result['username'] ?? 'N/A'),
            _buildUserInfoRow('New Balance', '\$${_currencyFormatter.format(result['newBalance'] ?? 0.0)}'),
            _buildUserInfoRow('Transaction Code', result['transactionCode'] ?? 'N/A'),
            _buildUserInfoRow('Amount', '\$${_currencyFormatter.format(result['amount'] ?? 0.0)}'),
            if (result['description'] != null) 
              _buildUserInfoRow('Description', result['description']),
            _buildUserInfoRow(
              'Status',
              result['status'] ?? 'N/A',
              isHighlighted: true,
              color: (result['status'] == 'SUCCESS') ? Colors.green[800] : Colors.red[800],
            ),
            _buildUserInfoRow('Created At', _formatDateTime(result['createdAt'] ?? '')),
          ],
        ),
      ),
    );
  }
  
  String _formatDateTime(String dateTimeStr) {
    if (dateTimeStr.isEmpty) return 'N/A';
    
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }
  
  Widget _buildUserInfoRow(String label, String value, {bool isHighlighted = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isHighlighted ? (color ?? Colors.green[800]) : Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? (color ?? Colors.green[800]) : Colors.black,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSuccessMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _successMessage!,
              style: TextStyle(color: Colors.green[700]),
            ),
          ),
        ],
      ),
    );
  }
} 