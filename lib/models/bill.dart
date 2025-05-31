class Bill {
  final int id;
  final String type;
  final double amount;
  final bool isPaid;
  final String createdAt;

  Bill({
    required this.id,
    required this.type,
    required this.amount,
    required this.isPaid,
    required this.createdAt,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      type: json['type'],
      amount: double.parse(json['amount'].toString()),
      isPaid: json['isPaid'] ?? false,
      createdAt: json['createdAt'],
    );
  }
}
