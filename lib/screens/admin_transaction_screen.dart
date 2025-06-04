import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/admin_transaction_provider.dart';
import '../models/admin_transaction.dart';
import '../utils/responsive_utils.dart';

class AdminTransactionScreen extends StatefulWidget {
  const AdminTransactionScreen({super.key});

  @override
  State<AdminTransactionScreen> createState() => _AdminTransactionScreenState();
}

class _AdminTransactionScreenState extends State<AdminTransactionScreen> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();
  final _transactionCodeController = TextEditingController();
  String? _selectedType;
  String? _selectedStatus;
  DateTime? _fromDate;
  
  final _formatter = NumberFormat("#,##0.00", "en_US");
  
  bool _isFilterExpanded = false;
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // List of transaction types and statuses
  final List<String> _transactionTypes = ['TRANSFER', 'WITHDRAW', 'DEPOSIT', 'BILL_PAYMENT'];
  final List<String> _transactionStatuses = ['SUCCESS', 'PENDING', 'FAILED'];
  
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
      _loadTransactions();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _minAmountController.dispose();
    _maxAmountController.dispose();
    _transactionCodeController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _loadTransactions() async {
    final provider = Provider.of<AdminTransactionProvider>(context, listen: false);
    await provider.fetchTransactions();
  }
  
  void _applyFilters() {
    // Collapse filter after applying to give more space to results
    setState(() {
      _isFilterExpanded = false;
    });
    
    // Create a filter object with all the filter values
    final filter = TransactionFilter(
      keyword: _searchController.text.isNotEmpty ? _searchController.text : null,
      transactionType: _selectedType,
      transactionStatus: _selectedStatus,
      minAmount: _minAmountController.text.isNotEmpty ? double.tryParse(_minAmountController.text) : null,
      maxAmount: _maxAmountController.text.isNotEmpty ? double.tryParse(_maxAmountController.text) : null,
      fromDate: _fromDate?.toIso8601String(),
      transactionCode: _transactionCodeController.text.isNotEmpty ? _transactionCodeController.text : null,
    );
    
    // Apply the filter
    final provider = Provider.of<AdminTransactionProvider>(context, listen: false);
    provider.applyFilter(filter);
  }
  
  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _minAmountController.clear();
      _maxAmountController.clear();
      _transactionCodeController.clear();
      _selectedType = null;
      _selectedStatus = null;
      _fromDate = null;
    });
    
    // Clear filters in provider
    final provider = Provider.of<AdminTransactionProvider>(context, listen: false);
    provider.clearFilters();
  }
  
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A3A6B),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Close keyboard when tapping outside input fields
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Use constraints to make UI responsive
                      return Column(
                        children: [
                          // Filter Panel
                          _buildFilterPanel(constraints),
                          
                          // Transactions List
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: _loadTransactions,
                              color: const Color(0xFF1A3A6B),
                              child: Consumer<AdminTransactionProvider>(
                                builder: (context, provider, child) {
                                  if (provider.isLoading) {
                                    return const Center(child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A3A6B)),
                                    ));
                                  }
                                  
                                  if (provider.error != null) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Error: ${provider.error}',
                                              style: TextStyle(color: Colors.red[700]),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 12),
                                            ElevatedButton(
                                              onPressed: _loadTransactions,
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
                                      ),
                                    );
                                  }
                                  
                                  final transactions = provider.transactions;
                                  if (transactions.isEmpty) {
                                    return ListView(
                                      // Always allow scrolling for empty state to enable pull-to-refresh
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        SizedBox(height: 100),
                                        Center(
                                          child: Text('No transactions found'),
                                        ),
                                      ],
                                    );
                                  }
                                  
                                  // Scrollable transaction list with pagination
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            itemCount: transactions.length,
                                            itemBuilder: (context, index) {
                                              return _buildTransactionItem(transactions[index]);
                                            },
                                          ),
                                        ),
                                        if (provider.pagination != null)
                                          _buildPagination(provider),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
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
                    'Transaction Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Manage and monitor transactions',
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
    );
  }
  
  Widget _buildFilterPanel(BoxConstraints constraints) {
    final isLandscape = constraints.maxWidth > constraints.maxHeight;
    final smallScreen = constraints.maxHeight < 600;
    
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filter header
            ListTile(
              title: const Text(
                'Filters',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _resetFilters,
                    tooltip: 'Reset Filters',
                  ),
                  IconButton(
                    icon: Icon(_isFilterExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _isFilterExpanded = !_isFilterExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            // Expandable filter content
            if (_isFilterExpanded)
              Container(
                constraints: BoxConstraints(
                  maxHeight: smallScreen 
                      ? constraints.maxHeight * 0.6 
                      : constraints.maxHeight * 0.45,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: smallScreen ? 8.0 : 16.0,
                  ),
                  child: isLandscape 
                      ? _buildLandscapeFilterForm()
                      : _buildPortraitFilterForm(),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // Filter form for portrait orientation
  Widget _buildPortraitFilterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search by description
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search by description',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
        
        // Transaction code
        TextField(
          controller: _transactionCodeController,
          decoration: const InputDecoration(
            labelText: 'Transaction Code',
            prefixIcon: Icon(Icons.code),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
        
        // Amount range
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Min Amount',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _maxAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Max Amount',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Transaction type
        DropdownButtonFormField<String>(
          value: _selectedType,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Transaction Type',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: _transactionTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedType = newValue;
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Transaction status
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: _transactionStatuses.map((String status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedStatus = newValue;
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Date picker
        InkWell(
          onTap: _selectDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'From Date',
              prefixIcon: const Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            child: Text(
              _fromDate != null
                  ? DateFormat('yyyy-MM-dd').format(_fromDate!)
                  : 'Select a date',
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Apply filter button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: _applyFilters,
            child: const Text(
              'Apply Filters',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
  
  // Filter form for landscape orientation - more compact layout
  Widget _buildLandscapeFilterForm() {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      alignment: WrapAlignment.spaceBetween,
      children: [
        // First row - Search and code
        SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 32,
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search by description',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 32,
          child: TextField(
            controller: _transactionCodeController,
            decoration: const InputDecoration(
              labelText: 'Transaction Code',
              prefixIcon: Icon(Icons.code),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        
        // Second row - Amount range
        SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 32,
          child: TextField(
            controller: _minAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Min Amount',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 32,
          child: TextField(
            controller: _maxAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Max Amount',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        
        // Third row - Type and status
        SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 32,
          child: DropdownButtonFormField<String>(
            value: _selectedType,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Transaction Type',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            items: _transactionTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedType = newValue;
              });
            },
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 32,
          child: DropdownButtonFormField<String>(
            value: _selectedStatus,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            items: _transactionStatuses.map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedStatus = newValue;
              });
            },
          ),
        ),
        
        // Fourth row - Date picker and apply button
        SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 32,
          child: InkWell(
            onTap: _selectDate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'From Date',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              child: Text(
                _fromDate != null
                    ? DateFormat('yyyy-MM-dd').format(_fromDate!)
                    : 'Select a date',
              ),
            ),
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 32,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: _applyFilters,
            child: const Text(
              'Apply Filters',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTransactionItem(AdminTransaction transaction) {
    // Choose color based on transaction status
    Color statusColor;
    switch (transaction.transactionStatus) {
      case 'SUCCESS':
        statusColor = Colors.green;
        break;
      case 'PENDING':
        statusColor = Colors.orange;
        break;
      case 'FAILED':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }
    
    // Choose icon and color based on transaction type
    IconData typeIcon;
    Color typeColor;
    switch (transaction.transactionType) {
      case 'TRANSFER':
        typeIcon = Icons.swap_horiz;
        typeColor = Colors.blue;
        break;
      case 'WITHDRAW':
        typeIcon = Icons.call_made;
        typeColor = Colors.orange;
        break;
      case 'DEPOSIT':
        typeIcon = Icons.call_received;
        typeColor = Colors.green;
        break;
      case 'BILL_PAYMENT':
        typeIcon = Icons.receipt_long;
        typeColor = Colors.purple;
        break;
      default:
        typeIcon = Icons.sync_alt;
        typeColor = Colors.grey;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Icon(typeIcon, color: Colors.blue[800]),
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust layout based on available width
            final isNarrow = constraints.maxWidth < 280;
            
            return isNarrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.shortTransactionCode,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          transaction.transactionStatus,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.transactionCode,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          transaction.transactionStatus,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
          }
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount: \$${_formatter.format(transaction.amount)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                // Display transaction type with appropriate color
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: typeColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    transaction.transactionType,
                    style: TextStyle(
                      color: typeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Date: ${transaction.formattedDate}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (transaction.description != null && transaction.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Description: ${transaction.description}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                const Divider(),
                _buildWalletInfo('From', transaction.fromWallet),
                const Divider(),
                _buildWalletInfo('To', transaction.toWallet),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWalletInfo(String label, Wallet wallet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${wallet.user.username}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text('Wallet ID: ${wallet.id}'),
        Text('Wallet Type: ${wallet.walletType}'),
        Text('Balance: \$${_formatter.format(wallet.balance)}'),
      ],
    );
  }
  
  Widget _buildPagination(AdminTransactionProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: provider.hasPreviousPage ? () => provider.previousPage() : null,
          ),
          Text(
            'Page ${provider.currentPage + 1} of ${provider.totalPages}',
            style: const TextStyle(fontSize: 14),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: provider.hasNextPage ? () => provider.nextPage() : null,
          ),
        ],
      ),
    );
  }
} 