import 'package:fintechnic/models/user.dart';

class Wallet {
  final int id;
  final double balance;
  final User user;
  final String walletType;
  final String walletStatus;
  final double? interestRate;
  final String lastUpdated;

  Wallet({
    required this.id,
    required this.balance,
    required this.user,
    required this.walletType,
    required this.walletStatus,
    this.interestRate,
    required this.lastUpdated,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] ?? 0,
      balance: (json['balance'] ?? 0.0).toDouble(),
      user: User.fromJson(json['user'] ?? {}),
      walletType: json['walletType'] ?? '',
      walletStatus: json['walletStatus'] ?? '',
      interestRate: json['interestRate']?.toDouble(),
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }
}

class AdminTransaction {
  final int id;
  final String transactionCode;
  final String transactionType;
  final String transactionStatus;
  final double amount;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final Wallet fromWallet;
  final Wallet toWallet;

  AdminTransaction({
    required this.id,
    required this.transactionCode,
    required this.transactionType,
    required this.transactionStatus,
    required this.amount,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.fromWallet,
    required this.toWallet,
  });

  factory AdminTransaction.fromJson(Map<String, dynamic> json) {
    return AdminTransaction(
      id: json['id'] ?? 0,
      transactionCode: json['transactionCode'] ?? '',
      transactionType: json['transactionType'] ?? '',
      transactionStatus: json['transactionStatus'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      description: json['description'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      fromWallet: Wallet.fromJson(json['fromWallet'] ?? {}),
      toWallet: Wallet.fromJson(json['toWallet'] ?? {}),
    );
  }

  // Helper method to get formatted date
  String get formattedDate {
    try {
      final dateTime = DateTime.parse(createdAt);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
    } catch (e) {
      return createdAt;
    }
  }

  // Helper for getting sender name
  String get senderName => fromWallet.user.username;

  // Helper for getting receiver name
  String get receiverName => toWallet.user.username;

  // Check if it's a self-transaction (same user for both wallets)
  bool get isSelfTransaction => fromWallet.user.id == toWallet.user.id;

  // Helper to get a short transaction code
  String get shortTransactionCode {
    if (transactionCode.length > 12) {
      return "${transactionCode.substring(0, 8)}...";
    }
    return transactionCode;
  }
}

// Class to handle pagination data from API
class PaginationData {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  PaginationData({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      size: json['size'] ?? 10,
      number: json['number'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

// Filter class for admin transaction filtering
class TransactionFilter {
  String? transactionType;
  double? minAmount;
  double? maxAmount;
  String? keyword;
  String? transactionStatus;
  String? fromDate;
  int? fromWalletId;
  String? transactionCode;
  int? toWalletId;

  TransactionFilter({
    this.transactionType,
    this.minAmount,
    this.maxAmount,
    this.keyword,
    this.transactionStatus,
    this.fromDate,
    this.fromWalletId,
    this.transactionCode,
    this.toWalletId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (transactionType != null) data['transactionType'] = transactionType;
    if (minAmount != null) data['minAmount'] = minAmount;
    if (maxAmount != null) data['maxAmount'] = maxAmount;
    if (keyword != null) data['keyword'] = keyword;
    if (transactionStatus != null) data['transactionStatus'] = transactionStatus;
    if (fromDate != null) data['fromDate'] = fromDate;
    if (fromWalletId != null) data['fromWalletId'] = fromWalletId;
    if (transactionCode != null) data['transactionCode'] = transactionCode;
    if (toWalletId != null) data['toWalletId'] = toWalletId;
    
    return data;
  }
} 