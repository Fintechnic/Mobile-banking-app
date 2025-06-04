import 'package:flutter/material.dart';
import '../utils/icon_utils.dart';

class Bill {
  final String id;
  final String serviceId;
  final String serviceName;
  final IconData serviceIcon;
  final String accountNumber;
  final double amount;
  final DateTime dueDate;

  Bill({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceIcon,
    required this.accountNumber,
    required this.amount,
    required this.dueDate,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      serviceIcon: IconUtils.getIconFromString(json['serviceIcon'] ?? 'receipt_long'),
      accountNumber: json['accountNumber'],
      amount: (json['amount'] is int) 
          ? (json['amount'] as int).toDouble()
          : json['amount'],
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate'])
          : DateTime.now().add(const Duration(days: 7)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceIcon': IconUtils.getStringFromIcon(serviceIcon),
      'accountNumber': accountNumber,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
    };
  }
}
