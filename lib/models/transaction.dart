class Transaction {
  final int id;
  final String type; // transfer, withdraw, top-up, etc.
  final double amount;
  final String? description;
  final String createdAt;
  final String? senderPhoneNumber;
  final String? receiverPhoneNumber;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    this.description,
    required this.createdAt,
    this.senderPhoneNumber,
    this.receiverPhoneNumber,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: double.parse(json['amount'].toString()),
      description: json['description'],
      createdAt: json['createdAt'],
      senderPhoneNumber: json['senderPhoneNumber'],
      receiverPhoneNumber: json['receiverPhoneNumber'],
    );
  }
}
