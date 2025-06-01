class Transaction {
  final int id;
  final String type; // transfer, withdraw, top-up, etc.
  final double amount;
  final String? description;
  final String createdAt;
  final String? senderPhoneNumber;
  final String? receiverPhoneNumber;
  final String? counterparty;
  final String? status;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    this.description,
    required this.createdAt,
    this.senderPhoneNumber,
    this.receiverPhoneNumber,
    this.counterparty,
    this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      // Handle potential type conversion issues
      id: _parseId(json['id']),
      type: json['type'] ?? _determineTransactionType(json['transaction_code']),
      // Safely parse amount
      amount: _parseAmount(json['amount']),
      description: json['description'],
      // Handle different field names and provide fallback
      createdAt: json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String(),
      senderPhoneNumber: json['senderPhoneNumber'],
      receiverPhoneNumber: json['receiverPhoneNumber'],
      counterparty: json['counterparty'],
      status: json['status'],
    );
  }
  
  // Parse ID safely
  static int _parseId(dynamic id) {
    if (id == null) return 0;
    if (id is int) return id;
    try {
      return int.parse(id.toString());
    } catch (e) {
      return 0;
    }
  }
  
  // Parse amount safely
  static double _parseAmount(dynamic amount) {
    if (amount == null) return 0.0;
    if (amount is double) return amount;
    if (amount is int) return amount.toDouble();
    try {
      return double.parse(amount.toString());
    } catch (e) {
      return 0.0;
    }
  }
  
  // Helper method to determine transaction type from transaction_code
  static String _determineTransactionType(dynamic transactionCode) {
    if (transactionCode == null) return 'unknown';
    
    String code = transactionCode.toString();
    if (code.startsWith('TX-')) {
      if (code.contains('deposit')) return 'deposit';
      if (code.contains('withdraw')) return 'withdraw';
      if (code.contains('transfer')) return 'transfer';
      if (code.contains('bill')) return 'bill_payment';
      if (code.contains('top')) return 'top_up';
    }
    
    return 'transfer'; // Default type
  }
  
  // Check if transaction is an expense based on amount (negative = expense)
  bool get isExpense => amount < 0;
}